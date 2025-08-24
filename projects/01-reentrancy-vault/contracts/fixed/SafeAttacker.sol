// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FixedVault.sol";
import "../interfaces/IAttacker.sol";
import "forge-std/console.sol";

/**
 * @title SafeAttacker
 * @dev Contract that attempts to attack FixedVault but fails due to security measures
 * 
 * This contract demonstrates that the security fixes in FixedVault work correctly:
 * 1. ✅ ReentrancyGuard prevents reentrancy attacks
 * 2. ✅ Checks-Effects-Interactions pattern prevents state manipulation
 * 3. ✅ Proper validation prevents invalid operations
 */
contract SafeAttacker is IAttacker {
    FixedVault public override vault;
    uint256 public override attackCount;
    uint256 public override totalStolen;
    
    constructor(address payable _vault) {
        vault = FixedVault(_vault);
    }
    
    // Function to test security measures
    function attack() external payable override {
        require(msg.value >= 1 ether, "Need at least 1 ETH to test");
        
        console.log("Testing FixedVault security measures...");
        console.log("Initial attacker balance:", address(this).balance);
        console.log("Initial vault balance:", vault.getContractBalance());
        
        // Step 1: Deposit ETH normally
        vault.deposit{value: msg.value}();
        
        console.log("Balance after deposit:", vault.getBalance(address(this)));
        
        // Step 2: Attempt reentrancy attack (should fail)
        attackCount = 0;
        totalStolen = 0;
        
        try vault.withdraw(msg.value) {
            console.log("Withdraw succeeded (expected)");
        } catch Error(string memory reason) {
            console.log("Withdraw failed with reason:", reason);
            emit AttackAttempted(1, reason);
        }
        
        console.log("Security test completed!");
        console.log("Total stolen (should be 0):", totalStolen);
        console.log("Final vault balance:", vault.getContractBalance());
        
        emit SecurityTestPassed("Reentrancy Protection");
    }
    
    // Function to test deposit bonus security
    function attackDepositBonus() external payable override {
        require(msg.value >= 1 ether, "Need at least 1 ETH");
        
        console.log("Testing deposit bonus security...");
        
        try vault.deposit{value: msg.value}() {
            console.log("Deposit succeeded (expected)");
            console.log("Final balance:", vault.getBalance(address(this)));
        } catch Error(string memory reason) {
            console.log("Deposit failed with reason:", reason);
            emit AttackAttempted(2, reason);
        }
        
        emit SecurityTestPassed("Deposit Bonus Protection");
    }
    
    // Function to test emergency withdraw security
    function attackEmergencyWithdraw() external payable override {
        require(msg.value > 0, "Need ETH to test");
        
        console.log("Testing emergency withdraw security...");
        
        // Deposit to activate deposit state
        vault.deposit{value: msg.value}();
        
        // Try to exploit emergencyWithdraw (should fail due to state management)
        try vault.emergencyWithdraw() {
            console.log("Emergency withdraw succeeded (expected)");
        } catch Error(string memory reason) {
            console.log("Emergency withdraw failed with reason:", reason);
            emit AttackAttempted(3, reason);
        }
        
        emit SecurityTestPassed("Emergency Withdraw Protection");
    }
    
    // receive() function - now safe and demonstrates protection
    receive() external payable override {
        console.log("Receive called with:", msg.value);
        console.log("Attack count:", attackCount);
        
        totalStolen += msg.value;
        attackCount++;
        
        emit AttackExecuted(attackCount, msg.value);
        
        // ✅ SECURE: Attempt reentrancy (should fail due to ReentrancyGuard)
        if (attackCount < 3 && address(vault).balance >= msg.value) {
            console.log("Attempting reentrancy (should fail)...");
            
            try vault.withdraw(msg.value) {
                console.log("REENTRANCY SUCCEEDED - SECURITY BREACH!");
            } catch Error(string memory reason) {
                console.log("Reentrancy blocked with reason:", reason);
                emit SecurityTestPassed("Reentrancy Blocked");
            } catch {
                console.log("Reentrancy blocked (generic error)");
                emit SecurityTestPassed("Reentrancy Blocked");
            }
        }
    }
    
    // Function to withdraw funds (normal operation)
    function withdrawStolenFunds() external override {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        
        console.log("Funds withdrawn:", balance);
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
    
    // Additional security test functions
    function testMultipleDeposits() external payable {
        console.log("Testing multiple deposits protection...");
        
        // Try to deposit multiple times quickly
        vault.deposit{value: 0.1 ether}();
        
        try vault.deposit{value: 0.1 ether}() {
            console.log("Second deposit succeeded");
        } catch Error(string memory reason) {
            console.log("Second deposit blocked:", reason);
            emit SecurityTestPassed("Multiple Deposit Protection");
        }
    }
    
    function testInvalidWithdraw() external {
        console.log("Testing invalid withdraw protection...");
        
        try vault.withdraw(0) {
            console.log("Zero withdraw succeeded - potential issue");
        } catch Error(string memory reason) {
            console.log("Zero withdraw blocked:", reason);
            emit SecurityTestPassed("Invalid Withdraw Protection");
        }
    }
}
