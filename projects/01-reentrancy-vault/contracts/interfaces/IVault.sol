// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IVault
 * @dev Interface for Vault contracts (vulnerable and fixed versions)
 */
interface IVault {
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    
    // Core functions
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function emergencyWithdraw() external;
    
    // View functions
    function getContractBalance() external view returns (uint256);
    function getBalance(address user) external view returns (uint256);
    function balances(address user) external view returns (uint256);
    function isDepositing(address user) external view returns (bool);
    
    // Receive function
    receive() external payable;
}
