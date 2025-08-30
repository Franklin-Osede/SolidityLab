// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title VulnerableVault
 * @dev Vulnerable contract demonstrating real Access Control problems
 * 
 * IMPLEMENTED VULNERABILITIES:
 * 1. Missing Access Modifiers - Functions without restrictions
 * 2. Faulty RBAC - Insecure role management
 * 3. Unprotected Initialization - Multiple initialization
 * 4. External Call Dependencies - External calls without validation
 * 5. Inconsistent Permissions - Inconsistent permissions across modules
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
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event AdminAdded(address indexed admin);
    event RoleAssigned(address indexed user, bytes32 role);
    
    /**
     * @dev Constructor - No access control
     */
    constructor() {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
    }
    
    /**
     * @dev VULNERABILITY 1: Missing Access Modifiers
     * @notice Anyone can withdraw funds
     */
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        totalFunds -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
    
    /**
     * @dev VULNERABILITY 2: Faulty RBAC Implementation
     * @notice Anyone can assign roles
     */
    function assignRole(address user, bytes32 role) external {
        // ❌ NO CALLER VALIDATION
        userRoles[user] = role;
        emit RoleAssigned(user, role);
    }
    
    /**
     * @dev VULNERABILITY 3: Unprotected Initialization
     * @notice Can be called multiple times
     */
    function initialize() external {
        // ❌ NO INITIALIZATION CHECK
        owner = msg.sender;
        isAdmin[msg.sender] = true;
        initialized = true;
    }
    
    /**
     * @dev VULNERABILITY 4: External Call Dependencies
     * @notice External calls without validation
     */
    function executeExternalCall(address target, bytes calldata data) external {
        // ❌ NO TARGET VALIDATION
        (bool success, ) = target.call(data);
        require(success, "External call failed");
    }
    
    /**
     * @dev VULNERABILITY 5: Inconsistent Permissions
     * @notice This function has access control
     */
    function secureFunction() external {
        require(isAdmin[msg.sender], "Only admin");
        // Secure implementation
    }
    
    /**
     * @dev VULNERABILITY 5: Inconsistent Permissions
     * @notice This function has NO access control
     */
    function insecureFunction() external {
        // ❌ NO ACCESS CONTROL - INCONSISTENT
        // Can be called by anyone
    }
    
    /**
     * @dev Deposit function
     */
    function deposit() external payable {
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
     * @dev Function to pause contract (vulnerable)
     */
    function pause() external {
        // ❌ NO ACCESS CONTROL
        // Anyone can pause the contract
    }
    
    /**
     * @dev Function to update parameters (vulnerable)
     */
    function updateParameters(uint256 newValue) external {
        // ❌ NO ACCESS CONTROL
        // Anyone can change critical parameters
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
