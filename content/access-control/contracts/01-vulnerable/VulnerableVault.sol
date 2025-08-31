// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title VulnerableVault
 * @dev Simplified vulnerable contract demonstrating real Access Control problems
 * 
 * IMPLEMENTED VULNERABILITIES:
 * 1. Missing Access Modifiers - Anyone can withdraw funds
 * 2. Faulty RBAC - Anyone can assign admin roles
 * 3. Unprotected Initialization - Anyone can become owner
 * 4. Emergency Function without Access Control - Anyone can pause contract
 * 
 * REAL CASES: Bybit, Nobitex, KiloEx ($7.4M hack)
 */
contract VulnerableVault {
    // State variables
    mapping(address => uint256) public balances;
    mapping(address => bool) public isAdmin;
    mapping(address => bytes32) public userRoles;
    
    address public owner;
    bool public initialized;
    uint256 public totalFunds;
    bool public paused;
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event AdminAdded(address indexed admin);
    event RoleAssigned(address indexed user, bytes32 role);
    event ContractPaused(address indexed pauser);
    
    /**
     * @dev Constructor - No access control
     */
    constructor() {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
    }
    
    /**
     * @dev VULNERABILITY 1: Missing Access Modifiers
     * @notice Anyone can withdraw funds from any account
     * REAL CASE: Bybit hack where anyone could withdraw
     */
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(!paused, "Contract is paused");
        
        balances[msg.sender] -= amount;
        totalFunds -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
    
    /**
     * @dev VULNERABILITY 2: Faulty RBAC Implementation
     * @notice Anyone can assign admin roles to themselves
     * REAL CASE: Many protocols hacked due to role management issues
     */
    function assignRole(address user, bytes32 role) external {
        // ❌ NO CALLER VALIDATION - ANYONE CAN ASSIGN ROLES
        userRoles[user] = role;
        if (role == keccak256("ADMIN_ROLE")) {
            isAdmin[user] = true;
        }
        emit RoleAssigned(user, role);
    }
    
    /**
     * @dev VULNERABILITY 3: Unprotected Initialization
     * @notice Anyone can become owner by calling this function
     * REAL CASE: Proxy pattern vulnerabilities in many protocols
     */
    function initialize() external {
        // ❌ NO INITIALIZATION CHECK - CAN BE CALLED MULTIPLE TIMES
        owner = msg.sender;
        isAdmin[msg.sender] = true;
        initialized = true;
    }
    
    /**
     * @dev VULNERABILITY 4: Emergency Function without Access Control
     * @notice Anyone can pause the contract
     * REAL CASE: Critical functions without protection
     */
    function pause() external {
        // ❌ NO ACCESS CONTROL - ANYONE CAN PAUSE
        paused = true;
        emit ContractPaused(msg.sender);
    }
    
    /**
     * @dev Function to unpause - also vulnerable
     */
    function unpause() external {
        // ❌ NO ACCESS CONTROL - ANYONE CAN UNPAUSE
        paused = false;
    }
    
    /**
     * @dev Deposit function - basic functionality
     */
    function deposit() external payable {
        require(!paused, "Contract is paused");
        require(msg.value > 0, "Amount must be greater than 0");
        
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @dev Function to add admin (vulnerable)
     */
    function addAdmin(address newAdmin) external {
        // ❌ NO VALIDATION - ANYONE CAN ADD ADMINS
        isAdmin[newAdmin] = true;
        emit AdminAdded(newAdmin);
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
}
