// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title MultiSigVault
 * @dev Advanced contract with Multi-Signature and Timelock functionality
 * 
 * LEVEL 3: Multi-Signature + Timelock
 * - Multi-signature approval for critical operations
 * - Timelock delays for security
 * - Role-based access control
 * - Emergency procedures
 * 
 * SECURITY FEATURES:
 * ✅ Multi-signature approval system
 * ✅ Timelock delays (24 hours)
 * ✅ Role-based access control
 * ✅ Emergency procedures
 * ✅ Comprehensive auditing
 * ✅ Proposal management
 * 
 * USE CASES:
 * - DeFi protocols requiring governance
 * - High-value asset management
 * - Institutional-grade security
 * - DAO treasury management
 */
contract MultiSigVault is AccessControl, ReentrancyGuard, Pausable {
    using Counters for Counters.Counter;
    
    // Role definitions
    bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");
    bytes32 public constant MULTISIG_ROLE = keccak256("MULTISIG_ROLE");
    
    // Multi-signature configuration
    uint256 public constant REQUIRED_SIGNATURES = 2;
    uint256 public constant TIMELOCK_DURATION = 24 hours;
    uint256 public constant PROPOSAL_EXPIRY = 7 days;
    
    // State variables
    mapping(address => uint256) public balances;
    uint256 public totalFunds;
    uint256 public maxWithdrawal;
    
    // Proposal management
    Counters.Counter private _proposalId;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public proposalApprovals;
    mapping(uint256 => uint256) public proposalApprovalCounts;
    
    // Structs
    struct Proposal {
        address proposer;
        ProposalType proposalType;
        uint256 amount;
        address target;
        bytes data;
        uint256 timestamp;
        bool executed;
        bool cancelled;
    }
    
    enum ProposalType {
        WITHDRAW,
        PAUSE,
        UNPAUSE,
        UPDATE_PARAMETERS,
        EMERGENCY_ACTION
    }
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, ProposalType proposalType);
    event ProposalApproved(uint256 indexed proposalId, address indexed approver);
    event ProposalExecuted(uint256 indexed proposalId, address indexed executor);
    event ProposalCancelled(uint256 indexed proposalId, address indexed canceller);
    event EmergencyAction(address indexed guardian, string action);
    
    /**
     * @dev Constructor with multi-signature setup
     * @param _maxWithdrawal Maximum withdrawal amount
     * @param _multisigSigners Array of multi-signature signers
     */
    constructor(uint256 _maxWithdrawal, address[] memory _multisigSigners) {
        require(_multisigSigners.length >= REQUIRED_SIGNATURES, "Insufficient signers");
        maxWithdrawal = _maxWithdrawal;
        
        // Grant DEFAULT_ADMIN_ROLE to contract deployer
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        
        // Grant initial roles to deployer
        _grantRole(WITHDRAW_ROLE, msg.sender);
        _grantRole(PAUSE_ROLE, msg.sender);
        _grantRole(OPERATOR_ROLE, msg.sender);
        _grantRole(GUARDIAN_ROLE, msg.sender);
        _grantRole(MULTISIG_ROLE, msg.sender);
        
        // Grant MULTISIG_ROLE to all signers
        for (uint256 i = 0; i < _multisigSigners.length; i++) {
            require(_multisigSigners[i] != address(0), "Invalid signer address");
            _grantRole(MULTISIG_ROLE, _multisigSigners[i]);
        }
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
     * @dev Create withdrawal proposal - requires MULTISIG_ROLE
     * @param amount Amount to withdraw
     */
    function createWithdrawProposal(uint256 amount) external onlyRole(MULTISIG_ROLE) returns (uint256) {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount <= maxWithdrawal, "Exceeds max withdrawal limit");
        
        _proposalId.increment();
        uint256 proposalId = _proposalId.current();
        
        proposals[proposalId] = Proposal({
            proposer: msg.sender,
            proposalType: ProposalType.WITHDRAW,
            amount: amount,
            target: address(0),
            data: "",
            timestamp: block.timestamp,
            executed: false,
            cancelled: false
        });
        
        emit ProposalCreated(proposalId, msg.sender, ProposalType.WITHDRAW);
        return proposalId;
    }
    
    /**
     * @dev Create pause proposal - requires MULTISIG_ROLE
     */
    function createPauseProposal() external onlyRole(MULTISIG_ROLE) returns (uint256) {
        _proposalId.increment();
        uint256 proposalId = _proposalId.current();
        
        proposals[proposalId] = Proposal({
            proposer: msg.sender,
            proposalType: ProposalType.PAUSE,
            amount: 0,
            target: address(0),
            data: "",
            timestamp: block.timestamp,
            executed: false,
            cancelled: false
        });
        
        emit ProposalCreated(proposalId, msg.sender, ProposalType.PAUSE);
        return proposalId;
    }
    
    /**
     * @dev Approve proposal - requires MULTISIG_ROLE
     * @param proposalId ID of the proposal to approve
     */
    function approveProposal(uint256 proposalId) external onlyRole(MULTISIG_ROLE) {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.proposer != address(0), "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        require(!proposal.cancelled, "Proposal cancelled");
        require(!proposalApprovals[proposalId][msg.sender], "Already approved");
        require(block.timestamp <= proposal.timestamp + PROPOSAL_EXPIRY, "Proposal expired");
        
        proposalApprovals[proposalId][msg.sender] = true;
        proposalApprovalCounts[proposalId]++;
        
        emit ProposalApproved(proposalId, msg.sender);
    }
    
    /**
     * @dev Execute proposal - requires MULTISIG_ROLE and sufficient approvals
     * @param proposalId ID of the proposal to execute
     */
    function executeProposal(uint256 proposalId) external onlyRole(MULTISIG_ROLE) {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.proposer != address(0), "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        require(!proposal.cancelled, "Proposal cancelled");
        require(proposalApprovalCounts[proposalId] >= REQUIRED_SIGNATURES, "Insufficient approvals");
        require(block.timestamp >= proposal.timestamp + TIMELOCK_DURATION, "Timelock not expired");
        require(block.timestamp <= proposal.timestamp + PROPOSAL_EXPIRY, "Proposal expired");
        
        proposal.executed = true;
        
        if (proposal.proposalType == ProposalType.WITHDRAW) {
            _executeWithdraw(proposal.amount);
        } else if (proposal.proposalType == ProposalType.PAUSE) {
            _pause();
        }
        
        emit ProposalExecuted(proposalId, msg.sender);
    }
    
    /**
     * @dev Cancel proposal - only proposer can cancel
     * @param proposalId ID of the proposal to cancel
     */
    function cancelProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.proposer == msg.sender, "Only proposer can cancel");
        require(!proposal.executed, "Proposal already executed");
        require(!proposal.cancelled, "Proposal already cancelled");
        
        proposal.cancelled = true;
        
        emit ProposalCancelled(proposalId, msg.sender);
    }
    
    /**
     * @dev Emergency pause - requires GUARDIAN_ROLE
     * @notice Bypasses multi-signature for emergency situations
     */
    function emergencyPause() external onlyRole(GUARDIAN_ROLE) {
        _pause();
        emit EmergencyAction(msg.sender, "Emergency pause activated");
    }
    
    /**
     * @dev Emergency withdraw - requires GUARDIAN_ROLE
     * @notice Bypasses multi-signature for emergency situations
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
     * @dev Execute withdrawal internally
     * @param amount Amount to withdraw
     */
    function _executeWithdraw(uint256 amount) internal {
        totalFunds -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
    
    /**
     * @dev Get proposal details
     * @param proposalId ID of the proposal
     */
    function getProposal(uint256 proposalId) external view returns (
        address proposer,
        ProposalType proposalType,
        uint256 amount,
        address target,
        bytes memory data,
        uint256 timestamp,
        bool executed,
        bool cancelled
    ) {
        Proposal storage proposal = proposals[proposalId];
        return (
            proposal.proposer,
            proposal.proposalType,
            proposal.amount,
            proposal.target,
            proposal.data,
            proposal.timestamp,
            proposal.executed,
            proposal.cancelled
        );
    }
    
    /**
     * @dev Check if address has approved proposal
     * @param proposalId ID of the proposal
     * @param approver Address to check
     */
    function hasApproved(uint256 proposalId, address approver) external view returns (bool) {
        return proposalApprovals[proposalId][approver];
    }
    
    /**
     * @dev Get approval count for proposal
     * @param proposalId ID of the proposal
     */
    function getApprovalCount(uint256 proposalId) external view returns (uint256) {
        return proposalApprovalCounts[proposalId];
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
     * @dev Get total proposal count
     */
    function getProposalCount() external view returns (uint256) {
        return _proposalId.current();
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
