// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/vulnerable/VulnerableVault.sol";
import "../contracts/vulnerable/Attacker.sol";
import "../contracts/fixed/FixedVault.sol";
import "../contracts/fixed/SafeAttacker.sol";

/**
 * @title ReentrancyDemo
 * @dev Tests para demostración de reentrancy attack en video
 */
contract ReentrancyDemo is Test {
    VulnerableVault public vulnerableVault;
    Attacker public attacker;
    FixedVault public fixedVault;
    SafeAttacker public safeAttacker;
    
    address public user = address(0x1);
    address public attackerAddress = address(0x2);
    
    event DemoStep(string step, uint256 vaultBalance, uint256 attackerBalance);
    
    function setUp() public {
        // Deploy contracts
        vulnerableVault = new VulnerableVault();
        attacker = new Attacker(payable(address(vulnerableVault)));
        fixedVault = new FixedVault();
        safeAttacker = new SafeAttacker(payable(address(fixedVault)));
        
        // Fund vaults
        vm.deal(address(vulnerableVault), 10 ether);
        vm.deal(address(fixedVault), 10 ether);
        
        // Fund user and attacker
        vm.deal(user, 5 ether);
        vm.deal(attackerAddress, 2 ether);
    }
    
    function testVulnerabilityDemo() public {
        console.log("=== DEMOSTRACIÓN DE VULNERABILIDAD ===");
        
        // Step 1: User deposits
        vm.startPrank(user);
        vulnerableVault.deposit{value: 1 ether}();
        console.log("User depositó 1 ETH");
        console.log("User balance en vault:", vulnerableVault.getBalance(user));
        vm.stopPrank();
        
        emit DemoStep("After User Deposit", 
                     vulnerableVault.getContractBalance(), 
                     address(attacker).balance);
        
        // Step 2: Attacker deposits
        vm.startPrank(attackerAddress);
        attacker.attack{value: 1 ether}();
        vm.stopPrank();
        
        console.log("\n=== RESULTADOS DEL ATAQUE ===");
        console.log("Vault balance final:", vulnerableVault.getContractBalance());
        console.log("Attacker balance final:", address(attacker).balance);
        console.log("User balance en vault:", vulnerableVault.getBalance(user));
        
        emit DemoStep("After Attack", 
                     vulnerableVault.getContractBalance(), 
                     address(attacker).balance);
        
        // Verify attack was successful
        assertTrue(address(attacker).balance > 1 ether, "Attack failed");
        assertTrue(vulnerableVault.getContractBalance() < 9 ether, "Vault not drained");
    }
    
    function testSecurityDemo() public {
        console.log("=== DEMOSTRACIÓN DE SEGURIDAD ===");
        
        // Step 1: User deposits
        vm.startPrank(user);
        fixedVault.deposit{value: 1 ether}();
        console.log("User depositó 1 ETH");
        console.log("User balance en vault:", fixedVault.getBalance(user));
        vm.stopPrank();
        
        emit DemoStep("After User Deposit (Secure)", 
                     fixedVault.getContractBalance(), 
                     address(safeAttacker).balance);
        
        // Step 2: Attacker tries to attack
        vm.startPrank(attackerAddress);
        safeAttacker.attack{value: 1 ether}();
        vm.stopPrank();
        
        console.log("\n=== RESULTADOS DEL ATAQUE SEGURO ===");
        console.log("Vault balance final:", fixedVault.getContractBalance());
        console.log("SafeAttacker balance final:", address(safeAttacker).balance);
        console.log("User balance en vault:", fixedVault.getBalance(user));
        
        emit DemoStep("After Secure Attack", 
                     fixedVault.getContractBalance(), 
                     address(safeAttacker).balance);
        
        // Verify attack was blocked
        assertTrue(address(safeAttacker).balance <= 1 ether, "Attack succeeded when it should have failed");
        assertTrue(fixedVault.getContractBalance() >= 9 ether, "Vault was drained");
    }
    
    function testComparison() public {
        console.log("=== COMPARACIÓN VULNERABLE vs SEGURO ===");
        
        // Test vulnerable version
        vm.startPrank(user);
        vulnerableVault.deposit{value: 1 ether}();
        vm.stopPrank();
        
        vm.startPrank(attackerAddress);
        attacker.attack{value: 1 ether}();
        vm.stopPrank();
        
        uint256 vulnerableVaultBalance = vulnerableVault.getContractBalance();
        uint256 vulnerableAttackerBalance = address(attacker).balance;
        
        console.log("Vulnerable Vault balance:", vulnerableVaultBalance);
        console.log("Vulnerable Attacker balance:", vulnerableAttackerBalance);
        
        // Reset for secure test
        setUp();
        
        // Test secure version
        vm.startPrank(user);
        fixedVault.deposit{value: 1 ether}();
        vm.stopPrank();
        
        vm.startPrank(attackerAddress);
        safeAttacker.attack{value: 1 ether}();
        vm.stopPrank();
        
        uint256 secureVaultBalance = fixedVault.getContractBalance();
        uint256 secureAttackerBalance = address(safeAttacker).balance;
        
        console.log("Secure Vault balance:", secureVaultBalance);
        console.log("Secure Attacker balance:", secureAttackerBalance);
        
        // Comparison
        console.log("\n=== DIFERENCIAS ===");
        console.log("Vault balance difference:", vulnerableVaultBalance - secureVaultBalance);
        console.log("Attacker balance difference:", vulnerableAttackerBalance - secureAttackerBalance);
        
        // Assertions
        assertTrue(vulnerableVaultBalance < secureVaultBalance, "Vulnerable vault should have less balance");
        assertTrue(vulnerableAttackerBalance > secureAttackerBalance, "Vulnerable attacker should have more balance");
    }
    
    function testStepByStepVulnerability() public {
        console.log("=== ANÁLISIS PASO A PASO DE LA VULNERABILIDAD ===");
        
        // Step 1: Initial state
        console.log("Estado inicial:");
        console.log("- Vault balance:", vulnerableVault.getContractBalance());
        console.log("- User balance:", user.balance);
        
        // Step 2: User deposit
        vm.startPrank(user);
        vulnerableVault.deposit{value: 1 ether}();
        console.log("\nDespués del depósito del usuario:");
        console.log("- User balance en vault:", vulnerableVault.getBalance(user));
        console.log("- Vault balance:", vulnerableVault.getContractBalance());
        vm.stopPrank();
        
        // Step 3: Attacker deposit and attack
        vm.startPrank(attackerAddress);
        console.log("\nIniciando ataque...");
        attacker.attack{value: 1 ether}();
        vm.stopPrank();
        
        // Step 4: Final state
        console.log("\nEstado final:");
        console.log("- Vault balance:", vulnerableVault.getContractBalance());
        console.log("- Attacker balance:", address(attacker).balance);
        console.log("- User balance en vault:", vulnerableVault.getBalance(user));
        
        // Show the vulnerability
        assertTrue(vulnerableVault.getBalance(user) > 0, "User balance should still exist");
        assertTrue(vulnerableVault.getContractBalance() < 9 ether, "Vault should be drained");
    }
    
    function testReentrancyGuardProtection() public {
        console.log("=== DEMOSTRACIÓN DE PROTECCIÓN ReentrancyGuard ===");
        
        // Try to call withdraw multiple times in the same transaction
        vm.startPrank(user);
        fixedVault.deposit{value: 1 ether}();
        
        console.log("Intentando múltiples llamadas a withdraw...");
        
        // This should fail due to ReentrancyGuard
        try fixedVault.withdraw(0.5 ether) {
            console.log("Primera llamada a withdraw exitosa");
            
            // Try second call - should fail
            try fixedVault.withdraw(0.5 ether) {
                console.log("❌ SEGUNDA LLAMADA EXITOSA - VULNERABILIDAD!");
            } catch Error(string memory reason) {
                console.log("✅ Segunda llamada bloqueada:", reason);
            }
        } catch Error(string memory reason) {
            console.log("Primera llamada falló:", reason);
        }
        
        vm.stopPrank();
    }
    
    function testChecksEffectsInteractions() public {
        console.log("=== DEMOSTRACIÓN DEL PATRÓN Checks-Effects-Interactions ===");
        
        vm.startPrank(user);
        fixedVault.deposit{value: 1 ether}();
        
        console.log("Balance antes del withdraw:", fixedVault.getBalance(user));
        
        // This should work correctly
        fixedVault.withdraw(0.5 ether);
        
        console.log("Balance después del withdraw:", fixedVault.getBalance(user));
        console.log("User ETH balance:", user.balance);
        
        vm.stopPrank();
        
        // Verify state was updated correctly
        assertTrue(fixedVault.getBalance(user) == 0.5 ether, "Balance not updated correctly");
    }
}
