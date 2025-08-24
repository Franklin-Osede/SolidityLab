# 🚨 Project #1: Reentrancy Vault

## 📋 Bug Summary

**Reentrancy** is one of the most famous bugs in Solidity, responsible for the DAO hack in 2016 that resulted in the loss of $60 million. This project demonstrates multiple variants of the reentrancy bug in a vault contract.

## 🎯 Learning Objectives

- Understand how reentrancy attacks work
- Learn to use `forge debug` for step-by-step analysis
- Master the Checks-Effects-Interactions pattern
- Implement ReentrancyGuard correctly
- Analyze storage and gas during debugging

## 🐛 Implemented Bugs

### Bug #1: Reentrancy in `withdraw()`
```solidity
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // ❌ BUG: CALL antes de actualizar estado
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
    
    // ❌ BUG: Estado actualizado DESPUÉS del CALL
    balances[msg.sender] -= amount;
}
```

**Problema:** El estado se actualiza después del CALL externo, permitiendo reentrancy.

### Bug #2: Reentrancy en `deposit()` con bonus
```solidity
function deposit() external payable {
    require(msg.value > 0, "Must send ETH");
    
    // ❌ BUG: Estado actualizado antes de validación completa
    balances[msg.sender] += msg.value;
    isDepositing[msg.sender] = true;
    
    // ❌ BUG: CALL externo sin protección
    if (msg.value >= 1 ether) {
        (bool success, ) = msg.sender.call{value: 0.1 ether}("");
        if (success) {
            balances[msg.sender] += 0.1 ether;
        }
    }
}
```

**Problema:** CALL externo durante el depósito permite reentrancy.

### Bug #3: Reentrancy en `emergencyWithdraw()`
```solidity
function emergencyWithdraw() external {
    require(isDepositing[msg.sender], "Not in deposit state");
    
    uint256 balance = balances[msg.sender];
    require(balance > 0, "No balance to withdraw");
    
    // ❌ BUG: Estado limpiado antes del CALL
    balances[msg.sender] = 0;
    isDepositing[msg.sender] = false;
    
    // ❌ BUG: CALL después de limpiar estado
    (bool success, ) = msg.sender.call{value: balance}("");
    require(success, "Transfer failed");
}
```

**Problema:** Estado limpiado antes del CALL, pero lógica vulnerable.

## 🛠️ Herramientas de Debugging

### Foundry Debug
```bash
# Compilar contratos
forge build

# Ejecutar tests con trazas detalladas
forge test -vvvv

# Debug paso a paso
forge debug <txHash>

# Análisis de gas
forge test --gas-report
```

### Comandos de Debugging Específicos
```bash
# Debug del test de reentrancy
forge test --match-test testReentrancyWithdraw -vvvv

# Debug paso a paso de una transacción específica
forge debug --sig "withdraw(uint256)" --args 1000000000000000000

# Análisis de storage
cast storage <vault_address> <slot_number>
```

## 📊 Análisis del Ataque

### Flujo del Ataque
1. **Depósito inicial:** Atacante deposita 1 ETH
2. **Primera llamada:** `withdraw(1 ETH)` es llamado
3. **CALL externo:** ETH es enviado al atacante
4. **Reentrancy:** `receive()` del atacante es llamado
5. **Segunda llamada:** `withdraw(1 ETH)` es llamado nuevamente
6. **Repetición:** El proceso se repite hasta agotar el vault

### Puntos de Debugging Clave
- **Storage antes del CALL:** Verificar que el balance no se ha actualizado
- **CALL stack:** Analizar las llamadas anidadas
- **Gas consumption:** Monitorear el gas durante el ataque
- **Estado final:** Verificar el estado corrupto del vault

## 🔧 Soluciones

### Solución #1: Patrón Checks-Effects-Interactions
```solidity
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // ✅ CHECK: Validar balance
    // ✅ EFFECTS: Actualizar estado ANTES del CALL
    balances[msg.sender] -= amount;
    
    // ✅ INTERACTIONS: CALL externo al final
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

### Solución #2: ReentrancyGuard
```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SecureVault is ReentrancyGuard {
    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
```

## 🎬 Guión para Video

### Estructura del Video (5-8 minutos)

1. **Hook (30s):** "Hoy voy a romper este vault y robar todo su ETH usando reentrancy"

2. **Setup (1min):** 
   - Explicar el contrato VulnerableVault
   - Mostrar los bugs intencionales
   - Deployar contratos

3. **Bug Demo (2min):**
   - Ejecutar `testReentrancyWithdraw()`
   - Mostrar cómo el atacante roba múltiples veces
   - Analizar logs y resultados

4. **Debugging (3min):**
   - Usar `forge debug` para stepping
   - Mostrar storage antes/después del CALL
   - Analizar call stack y gas

5. **Fix (1min):**
   - Implementar patrón Checks-Effects-Interactions
   - Mostrar ReentrancyGuard
   - Verificar que el ataque falla

6. **Verificación (30s):**
   - Ejecutar tests de seguridad
   - Mostrar comparación antes/después

## 📈 Métricas de Debugging

### Antes del Fix
- **Gas usado:** ~50,000 por withdraw
- **Ataques exitosos:** 5 reentrancy calls
- **ETH robado:** 5x el depósito inicial
- **Estado final:** Vault completamente drenado

### Después del Fix
- **Gas usado:** ~30,000 por withdraw
- **Ataques exitosos:** 0
- **ETH robado:** 0
- **Estado final:** Vault seguro

## 🔍 Puntos de Debugging Avanzado

### Análisis de Storage
```bash
# Obtener slot de storage para balances[address]
cast storage <vault_address> $(cast keccak256 $(cast abi-encode "address,uint256" <user_address> 0))
```

### Análisis de Gas
```bash
# Ver gas usado por función
forge test --gas-report --match-test testGasAnalysis
```

### Call Stack Analysis
```bash
# Debug con call stack
forge debug --verbosity 4
```

## 🎯 Próximos Pasos

1. **Ejecutar tests:** `forge test -vvvv`
2. **Debug paso a paso:** `forge debug <txHash>`
3. **Analizar storage:** Usar `cast storage`
4. **Implementar fixes:** Crear contrato seguro
5. **Comparar resultados:** Antes vs después

## 📚 Recursos Adicionales

- [Reentrancy Attack - SWC-107](https://swcregistry.io/docs/SWC-107)
- [Checks-Effects-Interactions Pattern](https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern)
- [OpenZeppelin ReentrancyGuard](https://docs.openzeppelin.com/contracts/4.x/api/security#ReentrancyGuard)
- [The DAO Hack Explained](https://www.gemini.com/cryptopedia/the-dao-hack-blockchain)
