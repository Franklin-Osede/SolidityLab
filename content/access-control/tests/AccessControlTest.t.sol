// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/01-vulnerable/VulnerableVault.sol";
import "../contracts/02-ownable/SecureVaultOwnable.sol";
import "../contracts/03-access-control/AdvancedVault.sol";
import "../contracts/04-multisig/MultiSigVault.sol";

/**
 * @title AccessControlTest
 * @dev Simplified test suite for Access Control patterns
 * 
 * TEST COVERAGE:
 * ✅ 4 Main vulnerability exploitation tests
 * ✅ Access control validation tests
 * ✅ Role management tests
 * ✅ Multi-signature workflow tests
 * ✅ Emergency procedure tests
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
    
    // ========== VULNERABLE VAULT TESTS - 4 MAIN VULNERABILITIES ==========
    
    function test_Vulnerability1_MissingAccessModifiers() public {
        // Setup: User deposits funds
        vm.prank(user1);
        vulnerableVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Attack: Attacker withdraws user's funds (should not be possible!)
        vm.prank(attacker);
        vulnerableVault.withdraw(DEPOSIT_AMOUNT);
        
        // Verify: Attacker received the funds (vulnerability exploited)
        assertEq(attacker.balance, 100 ether + DEPOSIT_AMOUNT);
        assertEq(vulnerableVault.getContractBalance(), 0);
        
        console.log("❌ VULNERABILITY 1: Anyone can withdraw funds from any account");
        console.log("   Real case: Bybit hack where anyone could withdraw");
    }
    
    function test_Vulnerability2_FaultyRBAC() public {
        // Attack: Attacker assigns admin role to themselves
        vm.prank(attacker);
        vulnerableVault.assignRole(attacker, keccak256("ADMIN_ROLE"));
        
        // Verify: Attacker has admin role (vulnerability exploited)
        assertEq(vulnerableVault.userRoles(attacker), keccak256("ADMIN_ROLE"));
        assertTrue(vulnerableVault.isAdmin(attacker));
        
        console.log("❌ VULNERABILITY 2: Anyone can assign admin roles to themselves");
        console.log("   Real case: Many protocols hacked due to role management issues");
    }
    
    function test_Vulnerability3_UnprotectedInitialization() public {
        // Attack: Attacker becomes owner by calling initialize
        vm.prank(attacker);
        vulnerableVault.initialize();
        
        // Verify: Attacker is now owner (vulnerability exploited)
        assertEq(vulnerableVault.owner(), attacker);
        assertTrue(vulnerableVault.isAdmin(attacker));
        assertTrue(vulnerableVault.initialized());
        
        // Attack: Can be called multiple times
        vm.prank(user1);
        vulnerableVault.initialize();
        assertEq(vulnerableVault.owner(), user1);
        
        console.log("❌ VULNERABILITY 3: Anyone can become owner by calling initialize");
        console.log("   Real case: Proxy pattern vulnerabilities in many protocols");
    }
    
    function test_Vulnerability4_EmergencyFunctionWithoutAccessControl() public {
        // Attack: Attacker pauses the contract
        vm.prank(attacker);
        vulnerableVault.pause();
        
        // Verify: Contract is paused by attacker (vulnerability exploited)
        assertTrue(vulnerableVault.paused());
        
        // Attack: Attacker can also unpause
        vm.prank(attacker);
        vulnerableVault.unpause();
        assertFalse(vulnerableVault.paused());
        
        console.log("❌ VULNERABILITY 4: Anyone can pause/unpause the contract");
        console.log("   Real case: Critical functions without protection");
    }
    
    function test_VulnerableVault_AnyoneCanAddAdmin() public {
        // Attack: Attacker adds themselves as admin
        vm.prank(attacker);
        vulnerableVault.addAdmin(attacker);
        
        // Verify: Attacker is now admin
        assertTrue(vulnerableVault.isAdmin(attacker));
        
        console.log("❌ BONUS VULNERABILITY: Anyone can add admins");
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
    
    function test_AdvancedVault_DailyWithdrawalLimit() public {
        // Setup: Grant WITHDRAW_ROLE
        vm.prank(owner);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), user1);
        
        // Setup: User deposits funds
        vm.prank(user2);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: First withdrawal within daily limit
        vm.prank(user1);
        advancedVault.withdraw(5 ether);
        
        // Test: Second withdrawal within daily limit
        vm.prank(user1);
        advancedVault.withdraw(5 ether);
        
        // Test: Third withdrawal exceeds daily limit
        vm.prank(user1);
        vm.expectRevert("Exceeds daily withdrawal limit");
        advancedVault.withdraw(1 ether);
    }
    
    function test_AdvancedVault_EmergencyGuardian() public {
        // Setup: User deposits funds
        vm.prank(user1);
        advancedVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Guardian can emergency withdraw (bypasses daily limits)
        vm.prank(guardian);
        advancedVault.emergencyWithdraw();
        
        // Verify: All funds withdrawn
        assertEq(advancedVault.getContractBalance(), 0);
        assertEq(guardian.balance, 100 ether + DEPOSIT_AMOUNT);
    }
    
    // ========== MULTI-SIG VAULT TESTS ==========
    
    function test_MultiSigVault_ProposalWorkflow() public {
        // Setup: User deposits funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Step 1: Create withdrawal proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Step 2: Approve proposal
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // Step 3: Wait for timelock (24 hours)
        vm.warp(block.timestamp + 24 hours);
        
        // Step 4: Execute proposal
        vm.prank(owner);
        multiSigVault.executeProposal(proposalId);
        
        // Verify: Withdrawal successful
        assertEq(owner.balance, 100 ether + WITHDRAW_AMOUNT);
    }
    
    function test_MultiSigVault_InsufficientApprovals() public {
        // Setup: User deposits funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Step 1: Create withdrawal proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        
        // Step 2: Only one approval (insufficient)
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        
        // Step 3: Try to execute without enough approvals
        vm.warp(block.timestamp + 24 hours);
        vm.prank(owner);
        vm.expectRevert("Insufficient approvals");
        multiSigVault.executeProposal(proposalId);
    }
    
    function test_MultiSigVault_TimelockProtection() public {
        // Setup: User deposits funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Step 1: Create and approve proposal
        vm.prank(owner);
        uint256 proposalId = multiSigVault.createWithdrawProposal(WITHDRAW_AMOUNT);
        vm.prank(owner);
        multiSigVault.approveProposal(proposalId);
        vm.prank(guardian);
        multiSigVault.approveProposal(proposalId);
        
        // Step 2: Try to execute before timelock expires
        vm.prank(owner);
        vm.expectRevert("Timelock not expired");
        multiSigVault.executeProposal(proposalId);
        
        // Step 3: Execute after timelock expires
        vm.warp(block.timestamp + 24 hours);
        vm.prank(owner);
        multiSigVault.executeProposal(proposalId);
    }
    
    function test_MultiSigVault_EmergencyGuardian() public {
        // Setup: User deposits funds
        vm.prank(user1);
        multiSigVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Test: Guardian can emergency withdraw (bypasses multi-sig)
        vm.prank(guardian);
        multiSigVault.emergencyWithdraw();
        
        // Verify: All funds withdrawn
        assertEq(multiSigVault.getContractBalance(), 0);
        assertEq(guardian.balance, 100 ether + DEPOSIT_AMOUNT);
    }
}
