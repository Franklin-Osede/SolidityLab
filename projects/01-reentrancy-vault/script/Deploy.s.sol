// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/vulnerable/VulnerableVault.sol";
import "../contracts/vulnerable/Attacker.sol";
import "../contracts/fixed/FixedVault.sol";
import "../contracts/fixed/SafeAttacker.sol";

/**
 * @title DeployScript
 * @dev Script to deploy both vulnerable and fixed versions for comparison
 */
contract DeployScript is Script {
    VulnerableVault public vulnerableVault;
    Attacker public attacker;
    FixedVault public fixedVault;
    SafeAttacker public safeAttacker;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying contracts with address:", deployer);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy vulnerable contracts
        console.log("Deploying VulnerableVault...");
        vulnerableVault = new VulnerableVault();
        console.log("VulnerableVault deployed at:", address(vulnerableVault));
        
        console.log("Deploying Attacker...");
        attacker = new Attacker(payable(address(vulnerableVault)));
        console.log("Attacker deployed at:", address(attacker));
        
        // Deploy fixed contracts
        console.log("Deploying FixedVault...");
        fixedVault = new FixedVault();
        console.log("FixedVault deployed at:", address(fixedVault));
        
        console.log("Deploying SafeAttacker...");
        safeAttacker = new SafeAttacker(payable(address(fixedVault)));
        console.log("SafeAttacker deployed at:", address(safeAttacker));
        
        vm.stopBroadcast();
        
        // Log deployment summary
        console.log("\n=== DEPLOYMENT SUMMARY ===");
        console.log("VulnerableVault:", address(vulnerableVault));
        console.log("Attacker:", address(attacker));
        console.log("FixedVault:", address(fixedVault));
        console.log("SafeAttacker:", address(safeAttacker));
        
        // Save deployment addresses
        string memory deploymentData = string.concat(
            '{"vulnerableVault":"', vm.toString(address(vulnerableVault)), '",',
            '"attacker":"', vm.toString(address(attacker)), '",',
            '"fixedVault":"', vm.toString(address(fixedVault)), '",',
            '"safeAttacker":"', vm.toString(address(safeAttacker)), '"}'
        );
        
        vm.writeFile("deployment.json", deploymentData);
        console.log("\nDeployment addresses saved to deployment.json");
    }
    
    // Function to fund vaults for testing
    function fundVaults() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Fund vulnerable vault
        (bool success1, ) = address(vulnerableVault).call{value: 10 ether}("");
        require(success1, "Failed to fund vulnerable vault");
        console.log("Funded VulnerableVault with 10 ETH");
        
        // Fund fixed vault
        (bool success2, ) = address(fixedVault).call{value: 10 ether}("");
        require(success2, "Failed to fund fixed vault");
        console.log("Funded FixedVault with 10 ETH");
        
        vm.stopBroadcast();
    }
    
    // Function to demonstrate vulnerability
    function demonstrateVulnerability() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("\n=== DEMONSTRATING VULNERABILITY ===");
        console.log("Initial vault balance:", vulnerableVault.getContractBalance());
        
        // Attack the vulnerable vault
        attacker.attack{value: 1 ether}();
        
        console.log("Final vault balance:", vulnerableVault.getContractBalance());
        console.log("Attacker balance:", address(attacker).balance);
        
        vm.stopBroadcast();
    }
    
    // Function to demonstrate security
    function demonstrateSecurity() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("\n=== DEMONSTRATING SECURITY ===");
        console.log("Initial vault balance:", fixedVault.getContractBalance());
        
        // Try to attack the fixed vault
        safeAttacker.attack{value: 1 ether}();
        
        console.log("Final vault balance:", fixedVault.getContractBalance());
        console.log("SafeAttacker balance:", address(safeAttacker).balance);
        
        vm.stopBroadcast();
    }
}
