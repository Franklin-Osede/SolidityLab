// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/01-vulnerable/VulnerableVault.sol";
import "../contracts/02-ownable/SecureVaultOwnable.sol";
import "../contracts/03-access-control/AdvancedVault.sol";
import "../contracts/04-multisig/MultiSigVault.sol";

/**
 * @title DeployScript
 * @dev Professional deployment script for Access Control demonstration
 * 
 * DEPLOYMENT FEATURES:
 * ✅ Environment-specific configuration
 * ✅ Multi-contract deployment
 * ✅ Role setup and configuration
 * ✅ Verification and validation
 * ✅ Gas optimization
 * ✅ Security checks
 * 
 * USAGE:
 * forge script Deploy --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
 */
contract DeployScript is Script {
    // Configuration constants
    uint256 constant MAX_WITHDRAWAL = 20 ether;
    uint256 constant DAILY_LIMIT = 10 ether;
    uint256 constant REQUIRED_SIGNATURES = 2;
    
    // Environment variables
    address public owner;
    address[] public multisigSigners;
    
    // Contract instances
    VulnerableVault public vulnerableVault;
    SecureVaultOwnable public secureVault;
    AdvancedVault public advancedVault;
    MultiSigVault public multiSigVault;
    
    function setUp() public {
        // Load environment variables
        owner = vm.envAddress("OWNER_ADDRESS");
        
        // Setup multi-signature signers
        multisigSigners = new address[](REQUIRED_SIGNATURES);
        multisigSigners[0] = vm.envAddress("SIGNER_1_ADDRESS");
        multisigSigners[1] = vm.envAddress("SIGNER_2_ADDRESS");
        
        // Validate configuration
        require(owner != address(0), "Invalid owner address");
        require(multisigSigners[0] != address(0), "Invalid signer 1 address");
        require(multisigSigners[1] != address(0), "Invalid signer 2 address");
        require(multisigSigners[0] != multisigSigners[1], "Duplicate signer addresses");
    }
    
    function run() public {
        // Start broadcasting transactions
        vm.startBroadcast();
        
        // Deploy contracts
        _deployVulnerableVault();
        _deploySecureVault();
        _deployAdvancedVault();
        _deployMultiSigVault();
        
        // Configure contracts
        _configureContracts();
        
        // Validate deployment
        _validateDeployment();
        
        vm.stopBroadcast();
        
        // Log deployment information
        _logDeploymentInfo();
    }
    
    /**
     * @dev Deploy vulnerable vault (for demonstration purposes)
     */
    function _deployVulnerableVault() internal {
        console.log("Deploying VulnerableVault...");
        
        vulnerableVault = new VulnerableVault();
        
        console.log("VulnerableVault deployed at:", address(vulnerableVault));
    }
    
    /**
     * @dev Deploy secure vault with Ownable pattern
     */
    function _deploySecureVault() internal {
        console.log("Deploying SecureVaultOwnable...");
        
        secureVault = new SecureVaultOwnable(MAX_WITHDRAWAL);
        
        console.log("SecureVaultOwnable deployed at:", address(secureVault));
    }
    
    /**
     * @dev Deploy advanced vault with RBAC
     */
    function _deployAdvancedVault() internal {
        console.log("Deploying AdvancedVault...");
        
        advancedVault = new AdvancedVault(MAX_WITHDRAWAL, DAILY_LIMIT);
        
        console.log("AdvancedVault deployed at:", address(advancedVault));
    }
    
    /**
     * @dev Deploy multi-signature vault
     */
    function _deployMultiSigVault() internal {
        console.log("Deploying MultiSigVault...");
        
        multiSigVault = new MultiSigVault(MAX_WITHDRAWAL, multisigSigners);
        
        console.log("MultiSigVault deployed at:", address(multiSigVault));
    }
    
    /**
     * @dev Configure deployed contracts
     */
    function _configureContracts() internal {
        console.log("Configuring contracts...");
        
        // Configure AdvancedVault roles
        _configureAdvancedVaultRoles();
        
        // Configure MultiSigVault roles
        _configureMultiSigVaultRoles();
        
        console.log("Contract configuration completed");
    }
    
    /**
     * @dev Configure roles for AdvancedVault
     */
    function _configureAdvancedVaultRoles() internal {
        // Grant WITHDRAW_ROLE to additional signers
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), multisigSigners[0]);
        advancedVault.grantRole(advancedVault.WITHDRAW_ROLE(), multisigSigners[1]);
        
        // Grant PAUSE_ROLE to signers
        advancedVault.grantRole(advancedVault.PAUSE_ROLE(), multisigSigners[0]);
        advancedVault.grantRole(advancedVault.PAUSE_ROLE(), multisigSigners[1]);
        
        // Grant GUARDIAN_ROLE to signers
        advancedVault.grantRole(advancedVault.GUARDIAN_ROLE(), multisigSigners[0]);
        advancedVault.grantRole(advancedVault.GUARDIAN_ROLE(), multisigSigners[1]);
        
        console.log("AdvancedVault roles configured");
    }
    
    /**
     * @dev Configure roles for MultiSigVault
     */
    function _configureMultiSigVaultRoles() internal {
        // Grant additional roles to signers
        multiSigVault.grantRole(multiSigVault.WITHDRAW_ROLE(), multisigSigners[0]);
        multiSigVault.grantRole(multiSigVault.WITHDRAW_ROLE(), multisigSigners[1]);
        
        multiSigVault.grantRole(multiSigVault.PAUSE_ROLE(), multisigSigners[0]);
        multiSigVault.grantRole(multiSigVault.PAUSE_ROLE(), multisigSigners[1]);
        
        console.log("MultiSigVault roles configured");
    }
    
    /**
     * @dev Validate deployment
     */
    function _validateDeployment() internal {
        console.log("Validating deployment...");
        
        // Validate contract addresses
        require(address(vulnerableVault) != address(0), "VulnerableVault deployment failed");
        require(address(secureVault) != address(0), "SecureVault deployment failed");
        require(address(advancedVault) != address(0), "AdvancedVault deployment failed");
        require(address(multiSigVault) != address(0), "MultiSigVault deployment failed");
        
        // Validate role assignments
        require(advancedVault.hasRole(advancedVault.DEFAULT_ADMIN_ROLE(), owner), "Owner not admin");
        require(advancedVault.hasRole(advancedVault.WITHDRAW_ROLE(), multisigSigners[0]), "Signer 1 not withdraw role");
        require(advancedVault.hasRole(advancedVault.WITHDRAW_ROLE(), multisigSigners[1]), "Signer 2 not withdraw role");
        
        require(multiSigVault.hasRole(multiSigVault.DEFAULT_ADMIN_ROLE(), owner), "Owner not admin in MultiSig");
        require(multiSigVault.hasRole(multiSigVault.MULTISIG_ROLE(), multisigSigners[0]), "Signer 1 not multisig role");
        require(multiSigVault.hasRole(multiSigVault.MULTISIG_ROLE(), multisigSigners[1]), "Signer 2 not multisig role");
        
        console.log("Deployment validation passed");
    }
    
    /**
     * @dev Log deployment information
     */
    function _logDeploymentInfo() internal view {
        console.log("\n=== DEPLOYMENT SUMMARY ===");
        console.log("Network:", vm.envString("NETWORK"));
        console.log("Owner:", owner);
        console.log("Signer 1:", multisigSigners[0]);
        console.log("Signer 2:", multisigSigners[1]);
        console.log("\n=== CONTRACT ADDRESSES ===");
        console.log("VulnerableVault:", address(vulnerableVault));
        console.log("SecureVaultOwnable:", address(secureVault));
        console.log("AdvancedVault:", address(advancedVault));
        console.log("MultiSigVault:", address(multiSigVault));
        console.log("\n=== CONFIGURATION ===");
        console.log("Max Withdrawal:", MAX_WITHDRAWAL);
        console.log("Daily Limit:", DAILY_LIMIT);
        console.log("Required Signatures:", REQUIRED_SIGNATURES);
        console.log("========================\n");
    }
    
    /**
     * @dev Emergency deployment function
     * @notice Deploy only secure contracts in production
     */
    function deploySecureOnly() public {
        vm.startBroadcast();
        
        _deploySecureVault();
        _deployAdvancedVault();
        _deployMultiSigVault();
        _configureContracts();
        _validateDeployment();
        
        vm.stopBroadcast();
        
        _logDeploymentInfo();
    }
    
    /**
     * @dev Test deployment function
     * @notice Deploy all contracts for testing
     */
    function deployForTesting() public {
        vm.startBroadcast();
        
        _deployVulnerableVault();
        _deploySecureVault();
        _deployAdvancedVault();
        _deployMultiSigVault();
        _configureContracts();
        _validateDeployment();
        
        vm.stopBroadcast();
        
        _logDeploymentInfo();
    }
}
