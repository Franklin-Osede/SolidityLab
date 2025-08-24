// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IVault.sol";

/**
 * @title VulnerableVault
 * @dev Contract vulnerable to reentrancy with multiple attack vectors
 * 
 * Intentional bugs:
 * 1. Reentrancy in withdraw() - state updated after CALL
 * 2. Reentrancy in deposit() - vulnerable logic
 * 3. Missing ReentrancyGuard
 * 4. Inconsistent state during reentrancy
 */
contract VulnerableVault is IVault {
    mapping(address => uint256) public balances;
    mapping(address => bool) public isDepositing;
    
    // Bug #1: Reentrancy in withdraw - state updated AFTER the CALL
    function withdraw(uint256 amount) external override {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // ❌ BUG: State updated AFTER the CALL
        // This allows reentrancy
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        // ❌ BUG: State updated after the CALL
        balances[msg.sender] -= amount;
        
        emit Withdraw(msg.sender, amount);
    }
    
    // Bug #2: Reentrancy in deposit with vulnerable logic
    function deposit() external payable override {
        require(msg.value > 0, "Must send ETH");
        
        // ❌ BUG: State updated before complete validation
        balances[msg.sender] += msg.value;
        isDepositing[msg.sender] = true;
        
        // ❌ BUG: External CALL without protection
        if (msg.value >= 1 ether) {
            // Bonus for large deposits - vulnerable to reentrancy
            (bool success, ) = msg.sender.call{value: 0.1 ether}("");
            if (success) {
                balances[msg.sender] += 0.1 ether;
            }
        }
        
        isDepositing[msg.sender] = false;
        emit Deposit(msg.sender, msg.value);
    }
    
    // Bug #3: Vulnerable emergency function
    function emergencyWithdraw() external override {
        require(isDepositing[msg.sender], "Not in deposit state");
        
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        
        // ❌ BUG: State cleared before the CALL
        balances[msg.sender] = 0;
        isDepositing[msg.sender] = false;
        
        // ❌ BUG: CALL after clearing state
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        
        emit EmergencyWithdraw(msg.sender, balance);
    }
    
    // Function to get contract balance
    function getContractBalance() external view override returns (uint256) {
        return address(this).balance;
    }
    
    // Function to get user balance
    function getBalance(address user) external view override returns (uint256) {
        return balances[user];
    }
    
    // Function to receive ETH
    receive() external payable override {
        // ❌ BUG: Allows deposits without validation
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
}
