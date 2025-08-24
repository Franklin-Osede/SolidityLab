// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/vulnerable/VulnerableVault.sol";
import "../contracts/vulnerable/Attacker.sol";

/**
 * @title VulnerableVaultTest
 * @dev Tests that demonstrate reentrancy bugs
 * 
 * Test cases:
 * 1. Reentrancy in withdraw() - multiple withdrawals
 * 2. Reentrancy in deposit() - infinite bonus
 * 3. Reentrancy in emergencyWithdraw() - complete drain
 * 4. Gas analysis and debugging
 */
contract VulnerableVaultTest is Test {
    VulnerableVault public vault;
    Attacker public attacker;
    
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);
    
    event Debug(string message, uint256 value);
    event DebugAddress(string message, address addr);
    
    function setUp() public {
        // Deploy contracts
        vault = new VulnerableVault();
        attacker = new Attacker(payable(address(vault)));
        
        // Fund accounts
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(charlie, 10 ether);
        vm.deal(address(attacker), 5 ether);
        
        console.log("Setup completed");
        console.log("Vault address:", address(vault));
        console.log("Attacker address:", address(attacker));
    }
    
    // Test #1: Basic reentrancy in withdraw()
    function testReentrancyWithdraw() public {
        console.log("\nTest #1: Reentrancy in withdraw()");
        
        // Alice deposits ETH
        vm.startPrank(alice);
        vault.deposit{value: 2 ether}();
        
        uint256 initialBalance = vault.getBalance(alice);
        uint256 initialVaultBalance = vault.getContractBalance();
        
        console.log("Initial Alice balance:", initialBalance);
        console.log("Initial vault balance:", initialVaultBalance);
        
        // Deploy attacker for Alice
        Attacker aliceAttacker = new Attacker(payable(address(vault)));
        vm.deal(address(aliceAttacker), 1 ether);
        
        // Execute attack
        aliceAttacker.attack{value: 1 ether}();
        
        uint256 finalBalance = vault.getBalance(alice);
        uint256 finalVaultBalance = vault.getContractBalance();
        uint256 stolenAmount = aliceAttacker.totalStolen();
        
        console.log("Final Alice balance:", finalBalance);
        console.log("Final vault balance:", finalVaultBalance);
        console.log("Total stolen:", stolenAmount);
        
        // Verify attack was successful
        assertGt(stolenAmount, 1 ether, "Attack failed - not enough ETH stolen");
        assertLt(finalVaultBalance, initialVaultBalance, "Vault was not drained");
        
        vm.stopPrank();
    }
    
    // Test #2: Reentrancy in deposit() with bonus
    function testReentrancyDepositBonus() public {
        console.log("\nTest #2: Reentrancy en deposit() con bonus");
        
        vm.startPrank(bob);
        
        uint256 initialVaultBalance = vault.getContractBalance();
        console.log("Balance inicial del vault:", initialVaultBalance);
        
        // Deploy attacker for Bob
        Attacker bobAttacker = new Attacker(payable(address(vault)));
        vm.deal(address(bobAttacker), 2 ether);
        
        // Atacar el bonus de depósito
        bobAttacker.attackDepositBonus{value: 1 ether}();
        
        uint256 finalVaultBalance = vault.getContractBalance();
        uint256 stolenAmount = bobAttacker.totalStolen();
        
        console.log("Balance final del vault:", finalVaultBalance);
        console.log("Total robado:", stolenAmount);
        
        vm.stopPrank();
    }
    
    // Test #3: Reentrancy in emergencyWithdraw()
    function testReentrancyEmergencyWithdraw() public {
        console.log("\nTest #3: Reentrancy en emergencyWithdraw()");
        
        vm.startPrank(charlie);
        
        uint256 initialVaultBalance = vault.getContractBalance();
        console.log("Balance inicial del vault:", initialVaultBalance);
        
        // Deploy attacker for Charlie
        Attacker charlieAttacker = new Attacker(payable(address(vault)));
        vm.deal(address(charlieAttacker), 1 ether);
        
        // Atacar emergencyWithdraw
        charlieAttacker.attackEmergencyWithdraw{value: 0.5 ether}();
        
        uint256 finalVaultBalance = vault.getContractBalance();
        uint256 stolenAmount = charlieAttacker.totalStolen();
        
        console.log("Balance final del vault:", finalVaultBalance);
        console.log("Total robado:", stolenAmount);
        
        vm.stopPrank();
    }
    
    // Test #4: Gas analysis and debugging
    function testGasAnalysis() public {
        console.log("\nTest #4: Gas analysis");
        
        vm.startPrank(alice);
        
        // Medir gas de depósito normal
        uint256 gasBefore = gasleft();
        vault.deposit{value: 1 ether}();
        uint256 gasUsed = gasBefore - gasleft();
        
        console.log("Gas used in normal deposit:", gasUsed);
        
        // Measure gas for normal withdraw
        gasBefore = gasleft();
        vault.withdraw(0.5 ether);
        gasUsed = gasBefore - gasleft();
        
        console.log("Gas used in normal withdraw:", gasUsed);
        
        vm.stopPrank();
    }
    
    // Test #5: Step-by-step debugging
    function testDebuggingStepByStep() public {
        console.log("\nTest #5: Debugging paso a paso");
        
        vm.startPrank(alice);
        
        // Step 1: Deposit
        console.log("Step 1: Deposit 1 ETH");
        vault.deposit{value: 1 ether}();
        
        uint256 balance = vault.getBalance(alice);
        console.log("Balance after deposit:", balance);
        
        // Step 2: Verify state
        console.log("Step 2: Verify vault state");
        uint256 vaultBalance = vault.getContractBalance();
        console.log("Vault balance:", vaultBalance);
        
        // Step 3: Prepare attack
        console.log("Step 3: Prepare reentrancy attack");
        Attacker debugAttacker = new Attacker(payable(address(vault)));
        vm.deal(address(debugAttacker), 1 ether);
        
        // Step 4: Execute attack with debugging
        console.log("Step 4: Execute attack...");
        debugAttacker.attack{value: 1 ether}();
        
        // Step 5: Analyze results
        console.log("Step 5: Analyze results");
        (uint256 attackCount, uint256 stolen, uint256 attackerBalance) = debugAttacker.getAttackStats();
        
        console.log("Number of attacks:", attackCount);
        console.log("Total stolen:", stolen);
        console.log("Attacker balance:", attackerBalance);
        
        vm.stopPrank();
    }
    
    // Test #6: Comparison with secure contract
    function testComparisonWithSecureVault() public pure {
        // TODO: Implement when we have the secure contract
        // This test will compare with the secure contract
    }
    
    // Test #7: Storage analysis
    function testStorageAnalysis() public {
        console.log("\nTest #7: Storage analysis");
        
        vm.startPrank(alice);
        
        // Deposit and verify storage
        vault.deposit{value: 1 ether}();
        
        // Get storage slot for balances[alice]
        bytes32 slot = keccak256(abi.encode(alice, uint256(0))); // balances mapping slot
        uint256 balanceInStorage = uint256(vm.load(address(vault), slot));
        
        console.log("Storage slot for balances[alice]:", uint256(slot));
        console.log("Value in storage:", balanceInStorage);
        console.log("Balance reported by contract:", vault.getBalance(alice));
        
        vm.stopPrank();
    }
    
    // Test #8: Real attack simulation
    function testRealWorldAttack() public {
        console.log("\nTest #8: Real attack simulation");
        
        // Simulate multiple users
        address[] memory users = new address[](5);
        for (uint i = 0; i < 5; i++) {
            users[i] = address(uint160(1000 + i));
            vm.deal(users[i], 2 ether);
        }
        
        // Normal users deposit
        for (uint i = 0; i < 5; i++) {
            vm.prank(users[i]);
            vault.deposit{value: 1 ether}();
        }
        
        uint256 totalDeposits = vault.getContractBalance();
        console.log("Total deposits:", totalDeposits);
        
        // Attacker appears
        Attacker realAttacker = new Attacker(payable(address(vault)));
        vm.deal(address(realAttacker), 1 ether);
        
        // Execute massive attack
        realAttacker.attack{value: 1 ether}();
        
        uint256 stolenAmount = realAttacker.totalStolen();
        uint256 remainingBalance = vault.getContractBalance();
        
        console.log("Total stolen:", stolenAmount);
        console.log("Remaining balance in vault:", remainingBalance);
        console.log("Percentage stolen:", (stolenAmount * 100) / totalDeposits, "%");
        
        // Verify attack was devastating
        assertGt(stolenAmount, totalDeposits * 80 / 100, "Attack was not effective enough");
    }
}
