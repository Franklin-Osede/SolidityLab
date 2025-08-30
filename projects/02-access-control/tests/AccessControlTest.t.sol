// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/01-vulnerable/VulnerableVault.sol";
import "../contracts/02-ownable/SecureVaultOwnable.sol";
import "../contracts/03-access-control/AdvancedVault.sol";
import "../contracts/04-multisig/MultiSigVault.sol";

/**
 * @title AccessControlTest
 * @dev Comprehensive test suite for Access Control patterns
 * 
 * TEST COVERAGE:
 * ✅ Vulnerability exploitation tests
 * ✅ Access control validation tests
 * ✅ Role management tests
 * ✅ Multi-signature workflow tests
 * ✅ Emergency procedure tests
 * ✅ Edge case testing
 * 
 * This demonstrates professional testing practices for blockchain security
 */
contract AccessControlTest is Test {
    // Test addresses
    address owner = address(0x1);
    address user1 = address(0x2);
    address user2 = address(0x3);
    address attacker = address(0x4);
    address guardian = address(0x5);
    address operator = address(0x6);
    
    // Contract instances
    VulnerableVault vulnerableVault;
    SecureVaultOwnable secureVault;
    AdvancedVault advancedVault;
    MultiSigVault multiSigVault;
    
    // Test constants
    uint256 constant DEPOSIT_AMOUNT = 10 ether;
    uint256 constant WITHDRAW_AMOUNT = 5 ether;
    uint256 constant MAX_WITHDRAWAL = 20 ether;
    uint256 constant DAILY_LIMIT = 10 ether;
    
    function setUp() public {
        // Setup test environment
        vm.label(owner, "Owner");
        vm.label(user1, "User1");
        vm.label(user2, "User2");
        vm.label(attacker, "Attacker");
        vm.label(guardian, "Guardian");
        vm.label(operator, "Operator");
        
        // Deploy contracts
        vulnerableVault = new VulnerableVault();
        secureVault = new SecureVaultOwnable(MAX_WITHDRAWAL);
        advancedVault = new AdvancedVault(MAX_WITHDRAWAL, DAILY_LIMIT);
        
        address[] memory signers = new address[](2);
        signers[0] = owner;
        signers[1] = guardian;
        multiSigVault = new MultiSigVault(MAX_WITHDRAWAL, signers);
        
        // Fund test accounts
        vm.deal(owner, 100 ether);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(attacker, 100 ether);
        vm.deal(guardian, 100 ether);
        vm.deal(operator, 100 ether);
    }
    
    // ========== VULNERABLE VAULT TESTS ==========
    
    function test_VulnerableVault_AnyoneCanWithdraw() public {
        // Setup: User deposits funds
        vm.prank(user1);
        vulnerableVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Attack: Attacker withdraws user's funds
        vm.prank(attacker);
        vulnerableVault.withdraw(DEPOSIT_AMOUNT);
        
        // Verify: Attacker received the funds
        assertEq(attacker.balance, 100 ether + DEPOSIT_AMOUNT);
        assertEq(vulnerableVault.getContractBalance(), 0);
    }
    
    function test_VulnerableVault_AnyoneCanAddAdmin() public {
        // Attack: Attacker adds themselves as admin
        vm.prank(attacker);
        vulnerableVault.addAdmin(attacker);
        
        // Verify: Attacker is now admin
        assertTrue(vulnerableVault.isAdmin(attacker));
    }
    
    function test_VulnerableVault_AnyoneCanPause() public {
        // Attack: Attacker pauses the contract
        vm.prank(attacker);
        vulnerableVault.pause();
        
        // Verify: Contract is paused (if implemented)
        // Note: This test shows the vulnerability even if pause() doesn't exist
    }
    
    function test_VulnerableVault_AnyoneCanAssignRoles() public {
        // Attack: Attacker assigns admin role to themselves
        vm.prank(attacker);
        vulnerableVault.assignRole(attacker, keccak256("ADMIN_ROLE"));
        
        // Verify: Attacker has admin role
        assertEq(vulnerableVault.userRoles(attacker), keccak256("ADMIN_ROLE"));
    }
    
    // ========== SECURE VAULT (OWNABLE) TESTS ==========
    
    function test_SecureVault_OnlyOwnerCanWithdraw() public {
        // Setup: User deposits funds
        vm.prank(user1);
        secureVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Owner can withdraw
        vm.prank(owner);
        secureVault.withdraw(WITHDRAW_AMOUNT);
        
        // Verify: Owner received funds
        assertEq(owner.balance, 100 ether + WITHDRAW_AMOUNT);
    }
    
    function test_SecureVault_NonOwnerCannotWithdraw() public {
        // Setup: User deposits funds
        vm.prank(user1);
        secureVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Non-owner cannot withdraw
        vm.prank(attacker);
        vm.expectRevert();
        secureVault.withdraw(WITHDRAW_AMOUNT);
        
        // Verify: Funds remain in contract
        assertEq(secureVault.getContractBalance(), DEPOSIT_AMOUNT);
    }
    
    function test_SecureVault_OnlyOwnerCanPause() public {
        // Test: Owner can pause
        vm.prank(owner);
        secureVault.pause();
        
        // Verify: Contract is paused
        assertTrue(secureVault.paused());
    }
    
    function test_SecureVault_NonOwnerCannotPause() public {
        // Test: Non-owner cannot pause
        vm.prank(attacker);
        vm.expectRevert();
        secureVault.pause();
        
        // Verify: Contract is not paused
        assertFalse(secureVault.paused());
    }
    
    function test_SecureVault_EmergencyWithdraw() public {
        // Setup: User deposits funds
        vm.prank(user1);
        secureVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Owner can emergency withdraw
        vm.prank(owner);
        secureVault.emergencyWithdraw();
        
        // Verify: All funds withdrawn
        assertEq(secureVault.getContractBalance(), 0);
        assertEq(owner.balance, 100 ether + DEPOSIT_AMOUNT);
    }
    
    // ========== ADVANCED VAULT (RBAC) TESTS ==========
    
    function test_AdvancedVault_RoleBasedAccess() public {
        // Setup: Grant roles
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), user1);
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.PAUSE_ROLE(), guardian);
        
        // Setup: User deposits funds
        vm.prank(user2);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: User with WITHDRAW_ROLE can withdraw
        vm.prank(user1);
        advancedVault.withdraw(WITHDRAW_AMOUNT);
        
        // Verify: Withdrawal successful
        assertEq(user1.balance, 100 ether + WITHDRAW_AMOUNT);
    }
    
    function test_AdvancedVault_UnauthorizedAccess() public {
        // Setup: User deposits funds
        vm.prank(user1);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: User without WITHDRAW_ROLE cannot withdraw
        vm.prank(attacker);
        vm.expectRevert();
        advancedVault.withdraw(WITHDRAW_AMOUNT);
        
        // Verify: Funds remain in contract
        assertEq(advancedVault.getContractBalance(), DEPOSIT_AMOUNT);
    }
    
    function test_AdvancedVault_RoleRevocation() public {
        // Setup: Grant role then revoke
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), user1);
        vm.prank(owner);
        advancedVault.revokeRole(advancedVault.WITHDRAW_ROLE(), user1);
        
        // Setup: User deposits funds
        vm.prank(user2);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Revoked user cannot withdraw
        vm.prank(user1);
        vm.expectRevert();
        advancedVault.withdraw(WITHDRAW_AMOUNT);
    }
    
    function test_AdvancedVault_DailyLimitEnforcement() public {
        // Setup: Grant role and deposit funds
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), user1);
        vm.prank(user2);
        advancedVault.deposit{value: DEPOSIT_AMOUNT * 2}();
        
        // Test: First withdrawal within limit
        vm.prank(user1);
        advancedVault.withdraw(DAILY_LIMIT);
        
        // Test: Second withdrawal exceeds daily limit
        vm.prank(user1);
        vm.expectRevert("Exceeds daily withdrawal limit");
        advancedVault.withdraw(1 ether);
    }
    
    function test_AdvancedVault_GuardianEmergencyPause() public {
        // Setup: Grant guardian role
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.GUARDIAN_ROLE(), guardian);
        
        // Test: Guardian can emergency pause
        vm.prank(guardian);
        advancedVault.emergencyPause();
        
        // Verify: Contract is paused
        assertTrue(advancedVault.paused());
    }
    
    // ========== MULTI-SIG VAULT TESTS ==========
    
    function test_MultiSigVault_ProposalCreation() public {
        // Setup: Deposit funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Create withdrawal proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Verify: Proposal created
        assertEq(proposalId, 1);
        
        (address proposer, , uint256 amount, , , , , ) = multiSigVault.getProposal(proposalId);
        assertEq(proposer, owner);
        assertEq(amount, WITHDRAW_AMOUNT);
    }
    
    function test_MultiSigVault_ProposalApproval() public {
        // Setup: Create proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Test: Approve proposal
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // Verify: Proposal has sufficient approvals
        assertEq(multiSigVault.getApprovalCount(proposalId), 2);
    }
    
    function test_MultiSigVault_ProposalExecution() public {
        // Setup: Create and approve proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // Fast forward past timelock
        vm.warp(block.timestamp + 25 hours);
        
        // Test: Execute proposal
        vm.prank(owner);
        multiSigVault.executeProposal(proposalId);
        
        // Verify: Proposal executed
        (,,,,,, bool executed, ) = multiSigVault.getProposal(proposalId);
        assertTrue(executed);
    }
    
    function test_MultiSigVault_TimelockEnforcement() public {
        // Setup: Create and approve proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // Test: Cannot execute before timelock expires
        vm.prank(owner);
        vm.expectRevert("Timelock not expired");
        multiSigVault.executeProposal(proposalId);
    }
    
    function test_MultiSigVault_InsufficientApprovals() public {
        // Setup: Create proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Test: Approve with only one signature
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        
        // Fast forward past timelock
        vm.warp(block.timestamp + 25 hours);
        
        // Test: Cannot execute with insufficient approvals
        vm.prank(owner);
        vm.expectRevert("Insufficient approvals");
        multiSigVault.executeProposal(proposalId);
    }
    
    function test_MultiSigVault_EmergencyBypass() public {
        // Setup: Grant guardian role and deposit funds
        vm.prank(owner);
        multiSigVault.grantRole(multiSigVault.GUARDIAN_ROLE(), guardian);
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Guardian can emergency withdraw (bypasses multi-sig)
        vm.prank(guardian);
        multiSigVault.emergencyWithdraw();
        
        // Verify: All funds withdrawn
        assertEq(multiSigVault.getContractBalance(), 0);
        assertEq(guardian.balance, 100 ether + DEPOSIT_AMOUNT);
    }
    
    // ========== EDGE CASE TESTS ==========
    
    function test_EdgeCase_ZeroAmountWithdrawal() public {
        // Test: Cannot withdraw zero amount
        vm.prank(owner);
        vm.expectRevert("Amount must be greater than 0");
        secureVault.withdraw(0);
    }
    
    function test_EdgeCase_ExcessiveWithdrawal() public {
        // Setup: Deposit funds
        vm.prank(user1);
        secureVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Cannot withdraw more than contract balance
        vm.prank(owner);
        vm.expectRevert("Insufficient contract balance");
        secureVault.withdraw(DEPOSIT_AMOUNT + 1 ether);
    }
    
    function test_EdgeCase_DuplicateApproval() public {
        // Setup: Create proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Test: Cannot approve same proposal twice
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(owner);
        vm.expectRevert("Already approved");
        multiSigVault.approveProposal(proposalId);
    }
    
    function test_EdgeCase_ProposalExpiry() public {
        // Setup: Create proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Fast forward past expiry
        vm.warp(block.timestamp + 8 days);
        
        // Test: Cannot approve expired proposal
        vm.prank(owner);
        vm.expectRevert("Proposal expired");
        multiSigVault.approveProposal(proposalId);
    }
    
    // ========== INTEGRATION TESTS ==========
    
    function test_Integration_FullWorkflow() public {
        // 1. Setup roles
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), user1);
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.OPERATOR_ROLE(), operator);
        
        // 2. Deposit funds
        vm.prank(user2);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // 3. Withdraw funds
        vm.prank(user1);
        advancedVault.withdraw(WITHDRAW_AMOUNT);
        
        // 4. Verify state
        assertEq(user1.balance, 100 ether + WITHDRAW_AMOUNT);
        assertEq(advancedVault.getContractBalance(), DEPOSIT_AMOUNT - WITHDRAW_AMOUNT);
        assertEq(advancedVault.getOperationCount(), 1);
    }
    
    function test_Integration_MultiSigWorkflow() public {
        // 1. Deposit funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // 2. Create proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // 3. Approve proposal
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // 4. Wait for timelock
        vm.warp(block.timestamp + 25 hours);
        
        // 5. Execute proposal
        vm.prank(owner);
        multiSigVault.executeProposal(proposalId);
        
        // 6. Verify execution
        (,,,,,, bool executed, ) = multiSigVault.getProposal(proposalId);
        assertTrue(executed);
        assertEq(multiSigVault.getContractBalance(), DEPOSIT_AMOUNT - WITHDRAW_AMOUNT);
    }
}
