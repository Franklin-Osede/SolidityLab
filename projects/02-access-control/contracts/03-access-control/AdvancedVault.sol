// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title AdvancedVault
 * @dev Advanced contract using OpenZeppelin AccessControl with role-based permissions
 * 
 * LEVEL 2: Role-Based Access Control (RBAC)
 * - Multiple roles with specific permissions
 * - Hierarchical role management
 * - Granular access control
 * - Role assignment and revocation
 * 
 * ROLES IMPLEMENTED:
 * - DEFAULT_ADMIN_ROLE: Can manage all roles
 * - WITHDRAW_ROLE: Can withdraw funds
 * - PAUSE_ROLE: Can pause/unpause contract
 * - OPERATOR_ROLE: Can perform daily operations
 * - GUARDIAN_ROLE: Emergency actions
 * 
 * SECURITY FEATURES:
 * ✅ Role-based access control
 * ✅ ReentrancyGuard protection
 * ✅ Pausable functionality
 * ✅ Comprehensive event logging
 * ✅ Input validation
 * ✅ Emergency procedures
 */
contract AdvancedVault is AccessControl, ReentrancyGuard, Pausable {
    using Counters for Counters.Counter;
    
    // Role definitions
    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");
    
    // State variables
    mapping(address => uint256) public balances;
    uint256 public totalFunds;
    uint256 public maxWithdrawal;
    uint256 public dailyWithdrawalLimit;
    mapping(address => uint256) public dailyWithdrawals;
    mapping(uint256 => uint256) public dailyWithdrawalTimestamps;
    
    Counters.Counter private _operationId;
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount, uint256 operationId);

    event EmergencyAction(address indexed guardian, string action);
    event DailyLimitUpdated(uint256 oldLimit, uint256 newLimit);
    event MaxWithdrawalUpdated(uint256 oldLimit, uint256 newLimit);
    
    /**
     * @dev Constructor with initial role setup
     * @param _maxWithdrawal Maximum withdrawal amount per transaction
     * @param _dailyLimit Daily withdrawal limit
     */
    constructor(uint256 _maxWithdrawal, uint256 _dailyLimit) {
        maxWithdrawal = _maxWithdrawal;
        dailyWithdrawalLimit = _dailyLimit;
        
        // Grant DEFAULT_ADMIN_ROLE to contract deployer
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        
        // Grant initial roles to deployer
        _grantRole(WITHDRAW_ROLE, msg.sender);
        _grantRole(PAUSE_ROLE, msg.sender);
        _grantRole(OPERATOR_ROLE, msg.sender);
        _grantRole(GUARDIAN_ROLE, msg.sender);
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
     * @dev Withdraw function - requires WITHDRAW_ROLE
     * @param amount Amount to withdraw
     */
    function withdraw(uint256 amount) external onlyRole(WITHDRAW_ROLE) nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount <= maxWithdrawal, "Exceeds max withdrawal limit");
        
        // Check daily withdrawal limit
        _checkDailyWithdrawalLimit(msg.sender, amount);
        
        totalFunds -= amount;
        dailyWithdrawals[msg.sender] += amount;
        
        _operationId.increment();
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount, _operationId.current());
    }
    
    /**
     * @dev Pause contract - requires PAUSE_ROLE
     */
    function pause() external onlyRole(PAUSE_ROLE) {
        _pause();
    }
    
    /**
     * @dev Unpause contract - requires PAUSE_ROLE
     */
    function unpause() external onlyRole(PAUSE_ROLE) {
        _unpause();
    }
    
    /**
     * @dev Update max withdrawal limit - requires DEFAULT_ADMIN_ROLE
     * @param newMaxWithdrawal New maximum withdrawal amount
     */
    function updateMaxWithdrawal(uint256 newMaxWithdrawal) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newMaxWithdrawal > 0, "Max withdrawal must be greater than 0");
        
        uint256 oldValue = maxWithdrawal;
        maxWithdrawal = newMaxWithdrawal;
        
        emit MaxWithdrawalUpdated(oldValue, newMaxWithdrawal);
    }
    
    /**
     * @dev Update daily withdrawal limit - requires DEFAULT_ADMIN_ROLE
     * @param newDailyLimit New daily withdrawal limit
     */
    function updateDailyLimit(uint256 newDailyLimit) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newDailyLimit > 0, "Daily limit must be greater than 0");
        
        uint256 oldValue = dailyWithdrawalLimit;
        dailyWithdrawalLimit = newDailyLimit;
        
        emit DailyLimitUpdated(oldValue, newDailyLimit);
    }
    
    /**
     * @dev Emergency pause - requires GUARDIAN_ROLE
     * @notice Can be called even when contract is paused
     */
    function emergencyPause() external onlyRole(GUARDIAN_ROLE) {
        _pause();
        emit EmergencyAction(msg.sender, "Emergency pause activated");
    }
    
    /**
     * @dev Emergency withdraw - requires GUARDIAN_ROLE
     * @notice Bypasses all limits in emergency situations
     */
    function emergencyWithdraw() external onlyRole(GUARDIAN_ROLE) {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        totalFunds = 0;
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        
        emit EmergencyAction(msg.sender, "Emergency withdrawal executed");
    }
    
    /**
     * @dev Grant role to address - requires DEFAULT_ADMIN_ROLE
     * @param role Role to grant
     * @param account Address to grant role to
     */
    function grantRole(bytes32 role, address account) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        super.grantRole(role, account);
        emit RoleGranted(role, account, msg.sender);
    }
    
    /**
     * @dev Revoke role from address - requires DEFAULT_ADMIN_ROLE
     * @param role Role to revoke
     * @param account Address to revoke role from
     */
    function revokeRole(bytes32 role, address account) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        super.revokeRole(role, account);
        emit RoleRevoked(role, account, msg.sender);
    }
    
    /**
     * @dev Check daily withdrawal limit for user
     * @param user Address to check
     * @param amount Amount to withdraw
     */
    function _checkDailyWithdrawalLimit(address user, uint256 amount) internal {
        uint256 today = block.timestamp / 1 days;
        
        // Reset daily withdrawal if it's a new day
        if (dailyWithdrawalTimestamps[uint256(uint160(user))] != today) {
            dailyWithdrawals[user] = 0;
            dailyWithdrawalTimestamps[uint256(uint160(user))] = today;
        }
        
        require(
            dailyWithdrawals[user] + amount <= dailyWithdrawalLimit,
            "Exceeds daily withdrawal limit"
        );
    }
    
    /**
     * @dev Get user balance
     * @param user Address to check
     */
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
    
    /**
     * @dev Get contract balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Get daily withdrawal for user
     * @param user Address to check
     */
    function getDailyWithdrawal(address user) external view returns (uint256) {
        return dailyWithdrawals[user];
    }
    
    /**
     * @dev Get operation count
     */
    function getOperationCount() external view returns (uint256) {
        return _operationId.current();
    }
    
    /**
     * @dev Receive function
     */
    receive() external payable {}
    
    /**
     * @dev Override supportsInterface for AccessControl
     */
    function supportsInterface(bytes4 interfaceId) public view override(AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
