// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title SecureVaultOwnable
 * @dev Secure contract using OpenZeppelin Ownable pattern
 * 
 * LEVEL 1: Basic Access Control
 * - Uses Ownable for critical functions
 * - Implements Pausable for emergencies
 * - Uses ReentrancyGuard to prevent reentrancy
 * 
 * IMPLEMENTED IMPROVEMENTS:
 * ✅ Access modifiers on all critical functions
 * ✅ Pausable for emergencies
 * ✅ ReentrancyGuard for additional security
 * ✅ Events for auditing
 * ✅ Input validations
 */
contract SecureVaultOwnable is Ownable, ReentrancyGuard, Pausable {
    // State variables
    mapping(address => uint256) public balances;
    uint256 public totalFunds;
    uint256 public maxWithdrawal;
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event MaxWithdrawalUpdated(uint256 oldValue, uint256 newValue);
    event EmergencyWithdraw(address indexed owner, uint256 amount);
    
    /**
     * @dev Constructor with initial configuration
     */
    constructor(uint256 _maxWithdrawal) {
        maxWithdrawal = _maxWithdrawal;
    }
    
    /**
     * @dev Deposit function - public but pausable
     */
    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "Amount must be greater than 0");
        
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @dev Withdrawal function - owner only
     * @notice Only the owner can withdraw funds
     */
    function withdraw(uint256 amount) external onlyOwner nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount <= maxWithdrawal, "Exceeds max withdrawal limit");
        
        totalFunds -= amount;
        
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
    
    /**
     * @dev Function to pause the contract - owner only
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Function to unpause the contract - owner only
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Function to update withdrawal limit - owner only
     */
    function updateMaxWithdrawal(uint256 newMaxWithdrawal) external onlyOwner {
        require(newMaxWithdrawal > 0, "Max withdrawal must be greater than 0");
        
        uint256 oldValue = maxWithdrawal;
        maxWithdrawal = newMaxWithdrawal;
        
        emit MaxWithdrawalUpdated(oldValue, newMaxWithdrawal);
    }
    
    /**
     * @dev Emergency function - owner only
     * @notice Allows withdrawing everything in case of emergency
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        totalFunds = 0;
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Transfer failed");
        
        emit EmergencyWithdraw(msg.sender, balance);
    }
    
    /**
     * @dev Function to get user balance
     */
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
    
    /**
     * @dev Function to get contract balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Function to receive ETH
     */
    receive() external payable {}
    
    /**
     * @dev Function to transfer ownership - override of Ownable
     * @notice Adds additional validation
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        super.transferOwnership(newOwner);
    }
}
