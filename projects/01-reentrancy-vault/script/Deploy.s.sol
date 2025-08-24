// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/vulnerable/VulnerableVault.sol";
import "../contracts/vulnerable/Attacker.sol";

/**
 * @title DeployScript
 * @dev Script to deploy the reentrancy project contracts
 */
contract DeployScript is Script {
    VulnerableVault public vault;
    Attacker public attacker;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deployando contratos...");
        console.log("Deployer:", deployer);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy VulnerableVault
        console.log("Deployando VulnerableVault...");
        vault = new VulnerableVault();
        console.log("VulnerableVault deployed at:", address(vault));
        
        // Deploy Attacker
        console.log("Deployando Attacker...");
        attacker = new Attacker(payable(address(vault)));
        console.log("Attacker deployed at:", address(attacker));
        
        vm.stopBroadcast();
        
        console.log("Deployment completado!");
        console.log("Vault address:", address(vault));
        console.log("Attacker address:", address(attacker));
        
        // Verificar deployment
        console.log("\nVerificando deployment...");
        console.log("Vault balance:", address(vault).balance);
        console.log("Attacker balance:", address(attacker).balance);
        
        // Guardar addresses para uso posterior
        string memory deploymentInfo = string(abi.encodePacked(
            "VulnerableVault: ", vm.toString(address(vault)), "\n",
            "Attacker: ", vm.toString(address(attacker)), "\n"
        ));
        
        vm.writeFile("deployment.txt", deploymentInfo);
        console.log("Deployment info guardado en deployment.txt");
    }
    
    // Función para setup inicial con fondos
    function setupWithFunds() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // address deployer = vm.addr(deployerPrivateKey); // Unused variable
        
        console.log("Setup con fondos...");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Enviar ETH al vault para simular depósitos
        (bool success, ) = address(vault).call{value: 10 ether}("");
        require(success, "Failed to fund vault");
        
        // Enviar ETH al attacker
        (success, ) = address(attacker).call{value: 5 ether}("");
        require(success, "Failed to fund attacker");
        
        vm.stopBroadcast();
        
        console.log("Setup con fondos completado!");
        console.log("Vault balance:", address(vault).balance);
        console.log("Attacker balance:", address(attacker).balance);
    }
}
