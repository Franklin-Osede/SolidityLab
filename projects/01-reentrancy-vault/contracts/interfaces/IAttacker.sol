// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IAttacker
 * @dev Interface for Attacker contracts (vulnerable and safe versions)
 */
interface IAttacker {
    // Events
    event AttackExecuted(uint256 attackCount, uint256 amount);
    event AttackCompleted(uint256 totalStolen);
    
    // Attack functions
    function attack() external payable;
    function attackDepositBonus() external payable;
    function attackEmergencyWithdraw() external payable;
    
    // Utility functions
    function withdrawStolenFunds() external;
    function getAttackStats() external view returns (uint256 attackCount, uint256 totalStolen, uint256 currentBalance);
    function getVaultBalance() external view returns (uint256);
    function getVaultUserBalance() external view returns (uint256);
    
    // State variables
    function vault() external view returns (address);
    function attackCount() external view returns (uint256);
    function totalStolen() external view returns (uint256);
    
    // Receive function for reentrancy attacks
    receive() external payable;
}
