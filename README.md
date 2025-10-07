# 🚀 Solidity Lab - Advanced Debugging

## 📋 Description

This project contains **15 vulnerable contracts** specifically designed to demonstrate advanced debugging skills in Solidity. Each contract includes intentional bugs that allow extraordinary debugging and deep EVM analysis.

## 🎯 Objectives

- **Demonstrate real expertise** in smart contract security
- **Teach advanced debugging** with professional tools
- **Create high-quality educational content**
- **Improve technical skills** in Solidity and EVM

## 🔍 Testing Commands - Access Control

### 🚀 Basic Commands
```bash
# Compile all contracts
forge build

# Clean and rebuild
forge clean && forge build

# Run all tests
forge test

# Tests with detailed output
forge test -vvv

# Tests with maximum verbosity (shows all logs)
forge test -vvvv

# Tests for a specific contract
forge test --match-contract AccessControlTest
```

### 🔍 Vulnerability Tests
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

### 🛡️ Security Solution Tests

#### Basic Security (Ownable Pattern)
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

#### Advanced Security (Role-Based Access Control)
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

#### Multi-Signature Security
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

### 🔧 Edge Cases and Integration Tests

#### Edge Cases
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

#### Integration Tests
```bash
# Test: Complete workflow integration
forge test --match-test "test_Integration_FullWorkflow" -vvvv

# Test: Multi-signature workflow
forge test --match-test "test_Integration_MultiSigWorkflow" -vvvv
```

### 📊 Analysis and Reporting

#### Gas Analysis
```bash
# Generate gas report for all tests
forge test --gas-report

# Gas report for specific test
forge test --match-test "test_MultiSigVault_ProposalExecution" --gas-report

# Gas report for specific contract
forge test --match-contract AccessControlTest --gas-report
```

#### Code Coverage
```bash
# Generate code coverage report
forge coverage

# Coverage for specific contract
forge coverage --match-contract AccessControlTest

# Coverage with detailed output
forge coverage --report lcov
```

### 🚀 Deployment Commands

#### Local Deployment
```bash
# Start local blockchain
anvil

# Deploy contracts locally
forge script content/access-control/scripts/Deploy.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv
```

#### Testnet Deployment
```bash
# Deploy to Sepolia testnet
forge script content/access-control/scripts/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### 🎬 LinkedIn Video Demo Script
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

### 🎯 Most Important Demo Commands
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

### 📝 Important Notes
- Use `-vvvv` for maximum verbosity to see all logs and transactions
- Use `--gas-report` to analyze gas consumption
- Use `--match-test` to run specific tests
- Use `--match-contract` to run all tests for a specific contract
- Use `forge coverage` to check code coverage
- Use `time` command to measure execution time

## 📁 Project Structure

```
Solidity Lab/
├── lib/                     # Foundry dependencies
├── projects/                # All projects organized
│   ├── 01-reentrancy-vault/ # Complete project
│   │   ├── contracts/
│   │   │   ├── vulnerable/  # Contracts with bugs
│   │   │   ├── fixed/       # Fixed contracts
│   │   │   └── interfaces/  # Interfaces
│   │   ├── test/            # Project tests
│   │   ├── script/          # Deployment scripts
│   │   └── docs/            # Documentation
│   ├── 02-integer-overflow/
│   ├── 03-tx-origin-confusion/
│   ├── 04-storage-packing/
│   ├── 05-timestamp-dependence/
│   ├── 06-dex-front-running/
│   ├── 07-proxy-storage-collision/
│   ├── 08-gas-griefing/
│   ├── 09-delegatecall-malicious/
│   ├── 10-short-address-attack/
│   ├── 11-selfdestruct-exploit/
│   ├── 12-memory-vs-storage/
│   ├── 13-loop-dos/
│   ├── 14-external-vs-public/
│   └── 15-event-logging/
├── tools/                   # Shared tools
│   ├── debug-scripts/       # Debugging scripts
│   ├── utilities/           # Common utilities
│   └── config/              # Configurations
├── videos/                  # Video scripts
├── docs/                    # General documentation
├── foundry.toml             # Foundry configuration
└── README.md                # This file
```

## 🚨 Debugging Projects

### 🔴 Critical Security (5 projects)
1. **Reentrancy Vault** - The most famous bug
2. **DEX Front-Running** - MEV and sandwich attacks
3. **Proxy Storage Collision** - Advanced delegatecall
4. **Malicious Delegatecall** - Unsafe external calls
5. **Integer Overflow/Underflow** - Financial calculations

### 🟡 Business Logic (5 projects)
6. **Timestamp Dependence** - Block manipulation
7. **Gas Griefing** - DoS by insufficient gas
8. **tx.origin Confusion** - Phishing attacks
9. **Selfdestruct Exploit** - Contract destruction
10. **Short Address Attack** - Calldata manipulation

### 🔵 Optimization (5 projects)
11. **Storage Packing** - Gas optimization
12. **Memory vs Storage** - Memory management
13. **External vs Public** - Function visibility
14. **Loop DoS** - Infinite loops
15. **Event Logging** - Log optimization

## 🛠️ Debugging Tools

### Foundry Suite
```bash
# Step-by-step debugging
forge debug <txHash>

# Detailed traces
forge test -vvvv

# Gas analysis
forge test --gas-report

# Storage inspection
cast storage <contract> <slot>
```

### Hardhat
```javascript
// Console logging
console.log("Debug:", value);

// Gas tracking
await contract.function({ gasLimit: 5000000 });
```

### Tenderly
- Visual transaction debugger
- Transaction simulation
- Real-time gas analysis

## 🚀 Getting Started

### Prerequisites
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install
```

### Configuration
```bash
# Copy environment variables
cp .env.example .env

# Configure variables
PRIVATE_KEY=your_private_key
MAINNET_RPC_URL=your_rpc_url
ETHERSCAN_API_KEY=your_api_key
```

### Run First Project
```bash
# Compile contracts
forge build

# Run reentrancy vault tests
forge test --match-contract VulnerableVaultTest -vvvv

# Step-by-step debug
forge debug --match-test testReentrancyWithdraw

# Run from project directory
cd projects/01-reentrancy-vault
forge test -vvvv
```

## 📊 Debugging Methodology

### Phase 1: Setup and Reproduction
1. Deploy vulnerable contract
2. Create test that reproduces the bug
3. Document expected vs actual behavior

### Phase 2: Deep Analysis
1. Use `forge debug` for stepping
2. Inspect storage and stack
3. Analyze gas consumption
4. Identify root cause

### Phase 3: Fix and Verification
1. Implement solution
2. Create security tests
3. Verify gas optimization
4. Document lessons learned

## 🎬 Video Format

### Structure (5-8 minutes)
1. **Hook (30s):** "Today I'm going to break this contract and fix it live"
2. **Setup (1min):** Explain the contract and its purpose
3. **Bug Demo (2min):** Show the bug working
4. **Debugging (3min):** Use tools to find the problem
5. **Fix (1min):** Implement the solution
6. **Verification (30s):** Confirm it's fixed

## 📈 Skills You Demonstrate

### EVM Internals
- Opcode analysis
- Storage layout understanding
- Gas mechanics
- Call stack manipulation

### Security Expertise
- Attack vector identification
- Vulnerability assessment
- Security pattern implementation
- Penetration testing

### Optimization Skills
- Gas efficiency analysis
- Storage optimization
- Contract design patterns
- Performance profiling

### Debugging Mastery
- Low-level debugging
- Transaction analysis
- Error root cause analysis
- Tool proficiency

## 🎯 Implementation Roadmap

### Week 1-2: Projects 1-5 (Critical Security)
- [x] Reentrancy Vault
- [ ] DEX Front-Running
- [ ] Proxy Storage Collision
- [ ] Malicious Delegatecall
- [ ] Integer Overflow

### Week 3-4: Projects 6-10 (Business Logic)
- [ ] Timestamp Dependence
- [ ] Gas Griefing
- [ ] tx.origin Confusion
- [ ] Selfdestruct Exploit
- [ ] Short Address Attack

### Week 5-6: Projects 11-15 (Optimization)
- [ ] Storage Packing
- [ ] Memory vs Storage
- [ ] External vs Public
- [ ] Loop DoS
- [ ] Event Logging

## 📚 Additional Resources

### Documentation
- [Solidity Docs](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)

### Tools
- [Tenderly](https://tenderly.co/)
- [Etherscan](https://etherscan.io/)
- [Hardhat](https://hardhat.org/)

### Community
- [Ethereum Stack Exchange](https://ethereum.stackexchange.com/)
- [OpenZeppelin Forum](https://forum.openzeppelin.com/)
- [Solidity Discord](https://discord.gg/solidity)

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Next Steps

1. **Run the first project:** `forge test --match-contract VulnerableVaultTest`
2. **Create the secure contract:** Implement fixes
3. **Record the first video:** Document the process
4. **Continue with the next project:** Integer Overflow
5. **Build the complete series:** All 15 projects

---

**Let's start with extraordinary debugging! 🚀**