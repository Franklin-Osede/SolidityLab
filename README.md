# Solidity Lab - Access Control Testing Commands

## 🚀 Quick Start Commands

### Build and Compile
```bash
# Compile all contracts
forge build

# Clean and rebuild
forge clean && forge build
```

### Run Tests
```bash
# Run all tests
forge test

# Run tests with detailed output
forge test -vvv

# Run tests with maximum verbosity (shows all logs)
forge test -vvvv

# Run specific test contract
forge test --match-contract AccessControlTest
```

## 🔍 Vulnerability Testing Commands

### Show Security Vulnerabilities
```bash
# Test: Anyone can withdraw funds (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

# Test: Anyone can become admin (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanAddAdmin" -vvvv

# Test: Anyone can pause contract (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanPause" -vvvv

# Test: Anyone can assign roles (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanAssignRoles" -vvvv
```

**What these tests show:**
- Demonstrates critical security flaws in basic contracts
- Shows how anyone can drain funds or take control
- Proves why access control is essential

## 🛡️ Security Solution Testing Commands

### Basic Security (Ownable Pattern)
```bash
# Test: Only owner can withdraw (SECURE)
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

# Test: Non-owners cannot withdraw (SECURE)
forge test --match-test "test_SecureVault_NonOwnerCannotWithdraw" -vvvv

# Test: Only owner can pause (SECURE)
forge test --match-test "test_SecureVault_OnlyOwnerCanPause" -vvvv

# Test: Non-owners cannot pause (SECURE)
forge test --match-test "test_SecureVault_NonOwnerCannotPause" -vvvv

# Test: Emergency withdraw functionality
forge test --match-test "test_SecureVault_EmergencyWithdraw" -vvvv
```

**What these tests show:**
- Demonstrates basic security with owner-only access
- Shows proper access control implementation
- Proves that unauthorized users cannot access funds

### Advanced Security (Role-Based Access Control)
```bash
# Test: Role-based access control
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

# Test: Daily limit enforcement
forge test --match-test "test_AdvancedVault_DailyLimitEnforcement" -vvvv

# Test: Guardian emergency pause
forge test --match-test "test_AdvancedVault_GuardianEmergencyPause" -vvvv

# Test: Role revocation
forge test --match-test "test_AdvancedVault_RoleRevocation" -vvvv

# Test: Unauthorized access prevention
forge test --match-test "test_AdvancedVault_UnauthorizedAccess" -vvvv
```

**What these tests show:**
- Demonstrates enterprise-grade access control
- Shows different roles with specific permissions
- Proves hierarchical security model
- Shows emergency procedures

### Multi-Signature Security
```bash
# Test: Proposal creation
forge test --match-test "test_MultiSigVault_ProposalCreation" -vvvv

# Test: Proposal approval process
forge test --match-test "test_MultiSigVault_ProposalApproval" -vvvv

# Test: Proposal execution with timelock
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

# Test: Timelock enforcement
forge test --match-test "test_MultiSigVault_TimelockEnforcement" -vvvv

# Test: Insufficient approvals rejection
forge test --match-test "test_MultiSigVault_InsufficientApprovals" -vvvv

# Test: Emergency bypass functionality
forge test --match-test "test_MultiSigVault_EmergencyBypass" -vvvv
```

**What these tests show:**
- Demonstrates institutional-grade security
- Shows multi-signature approval process
- Proves timelock security delays
- Shows emergency procedures
- Demonstrates governance mechanisms

## 🔧 Edge Cases and Integration Testing

### Edge Cases
```bash
# Test: Duplicate approval prevention
forge test --match-test "test_EdgeCase_DuplicateApproval" -vvvv

# Test: Excessive withdrawal prevention
forge test --match-test "test_EdgeCase_ExcessiveWithdrawal" -vvvv

# Test: Proposal expiry handling
forge test --match-test "test_EdgeCase_ProposalExpiry" -vvvv

# Test: Zero amount withdrawal
forge test --match-test "test_EdgeCase_ZeroAmountWithdrawal" -vvvv
```

### Integration Tests
```bash
# Test: Complete workflow integration
forge test --match-test "test_Integration_FullWorkflow" -vvvv

# Test: Multi-signature workflow
forge test --match-test "test_Integration_MultiSigWorkflow" -vvvv
```

**What these tests show:**
- Demonstrates complete system integration
- Shows end-to-end workflows
- Proves system robustness
- Shows error handling

## 📊 Analysis and Reporting Commands

### Gas Analysis
```bash
# Generate gas report for all tests
forge test --gas-report

# Gas report for specific test
forge test --match-test "test_MultiSigVault_ProposalExecution" --gas-report

# Gas report for specific contract
forge test --match-contract AccessControlTest --gas-report
```

### Code Coverage
```bash
# Generate code coverage report
forge coverage

# Coverage for specific contract
forge coverage --match-contract AccessControlTest

# Coverage with detailed output
forge coverage --report lcov
```

### Performance Analysis
```bash
# Time execution of tests
time forge test --match-test "test_Integration_FullWorkflow" -vvvv

# Memory usage analysis
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv | grep -i gas
```

## 🚀 Deployment Commands

### Local Deployment
```bash
# Start local blockchain
anvil

# Deploy contracts locally
forge script content/access-control/scripts/Deploy.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv
```

### Testnet Deployment
```bash
# Deploy to Sepolia testnet
forge script content/access-control/scripts/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

## 🎬 LinkedIn Video Demo Commands

### Step-by-Step Demo Script
```bash
#!/bin/bash

echo "=== SOLIDITY SECURITY DEMONSTRATION ==="
echo ""

echo "1. SHOWING VULNERABILITIES:"
echo "Anyone can withdraw funds:"
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

echo ""
echo "2. BASIC SECURITY SOLUTION:"
echo "Only owner can withdraw:"
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

echo ""
echo "3. ADVANCED SECURITY SOLUTION:"
echo "Role-based access control:"
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

echo ""
echo "4. ENTERPRISE SECURITY SOLUTION:"
echo "Multi-signature governance:"
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

echo ""
echo "5. COMPLETE WORKFLOW:"
echo "End-to-end integration:"
forge test --match-test "test_Integration_FullWorkflow" -vvvv
```

## 🔍 Debugging Commands

### Verbose Output Levels
```bash
# Level 1: Basic output
forge test -v

# Level 2: Show test results
forge test -vv

# Level 3: Show test results and logs
forge test -vvv

# Level 4: Show everything (transactions, logs, traces)
forge test -vvvv
```

### Specific Debugging
```bash
# Debug specific test with traces
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv --debug

# Show only failed tests
forge test --match-test "test_VulnerableVault" -vvvv | grep -A 10 -B 10 "FAIL"

# Show only console.log output
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv | grep "console.log"
```

## 📈 Monitoring Commands

### Real-time Monitoring
```bash
# Watch test results in real-time
watch -n 1 "forge test --match-test 'test_Integration_FullWorkflow' -vvvv"

# Monitor gas usage
forge test --gas-report --match-test "test_MultiSigVault_ProposalExecution" | grep -E "(gas|Gas)"
```

### Log Analysis
```bash
# Extract all events from tests
forge test -vvvv | grep -E "(emit|Event)"

# Extract all reverts
forge test -vvvv | grep -E "(revert|Revert)"

# Extract all console.log statements
forge test -vvvv | grep "console.log"
```

## 🎯 Quick Reference

### Most Important Commands for Demo
```bash
# Show vulnerabilities
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

# Show basic security
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

# Show advanced security
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

# Show multi-signature
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

# Show complete workflow
forge test --match-test "test_Integration_FullWorkflow" -vvvv
```

### All Tests by Category
```bash
# All vulnerability tests
forge test --match-test "test_VulnerableVault" -vvvv

# All security tests
forge test --match-test "test_SecureVault" -vvvv

# All advanced tests
forge test --match-test "test_AdvancedVault" -vvvv

# All multi-signature tests
forge test --match-test "test_MultiSigVault" -vvvv

# All integration tests
forge test --match-test "test_Integration" -vvvv

# All edge case tests
forge test --match-test "test_EdgeCase" -vvvv
```

---

## 📝 Notes

- Use `-vvvv` for maximum verbosity to see all logs and transactions
- Use `--gas-report` to analyze gas consumption
- Use `--match-test` to run specific tests
- Use `--match-contract` to run all tests in a specific contract
- Use `forge coverage` to check code coverage
- Use `time` command to measure execution time

## 🎬 For LinkedIn Video

Run the commands in this order:
1. Show vulnerabilities (problem)
2. Show basic security (solution 1)
3. Show advanced security (solution 2)
4. Show multi-signature (solution 3)
5. Show complete workflow (integration)

Each command will show detailed logs explaining what's happening in the smart contracts.