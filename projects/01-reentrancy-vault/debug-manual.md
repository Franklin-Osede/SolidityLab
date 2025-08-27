# 🔍 Debugging Manual para Video de LinkedIn

## 🎯 Método 1: Debugging Visual con Console.log

### 📍 Breakpoints Estratégicos en el Código

#### En `VulnerableVault.sol` - Línea 23:
```solidity
// ❌ BREAKPOINT CLAVE - Antes del CALL
console.log("🛑 ANTES DEL CALL - Balance:", balances[msg.sender]);
console.log("🛑 ANTES DEL CALL - Amount a retirar:", amount);

(bool success, ) = msg.sender.call{value: amount}("");

// ❌ BREAKPOINT CLAVE - Después del CALL
console.log("🛑 DESPUÉS DEL CALL - Balance:", balances[msg.sender]);
console.log("🛑 DESPUÉS DEL CALL - Success:", success);

balances[msg.sender] -= amount; // ❌ BUG: Estado actualizado DESPUÉS
```

#### En `Attacker.sol` - Línea 75:
```solidity
receive() external payable override {
    console.log("🛑 RECEIVE CALLED - Attack count:", attackCount);
    console.log("🛑 RECEIVE CALLED - Amount received:", msg.value);
    
    totalStolen += msg.value;
    attackCount++;
    
    // ❌ BREAKPOINT CLAVE - Condición de reentrancy
    if (attackCount < 5 && address(vault).balance >= msg.value) {
        console.log("🛑 EJECUTANDO REENTRANCY - Attack count:", attackCount);
        vault.withdraw(msg.value); // ❌ SEGUNDA LLAMADA
    }
}
```

## 🎬 Script para el Video

### **Paso 1: Mostrar el Código con Breakpoints Visuales**
```
"Vamos a agregar console.log estratégicos para ver el estado en cada momento"
```

### **Paso 2: Ejecutar el Test**
```bash
forge test --match-test testReentrancyWithdraw -vvvv
```

### **Paso 3: Analizar la Salida**
```
"Observa los logs - el balance NO cambia hasta el final"
```

## 🎯 Método 2: Debugging con Forge Debug

### Comando Interactivo:
```bash
forge test --match-test testReentrancyWithdraw -vvvv --debug
```

### Comandos de Debug:
- `b 23` - Breakpoint en línea 23
- `b 26` - Breakpoint en línea 26
- `c` - Continue
- `n` - Next
- `s` - Step into
- `p balances[msg.sender]` - Print variable

## 🎯 Método 3: Análisis de Storage

### Ver Storage Layout:
```bash
forge inspect VulnerableVault storage-layout
```

### Ver Storage en Runtime:
```bash
cast storage <VAULT_ADDRESS> <SLOT_NUMBER>
```

## 📊 Variables Clave para Monitorear

### En VulnerableVault:
- `balances[attacker]` - Balance del atacante
- `address(this).balance` - Balance del contrato

### En Attacker:
- `attackCount` - Número de ataques
- `totalStolen` - Total robado
- `address(this).balance` - Balance del atacante

## 🎬 Puntos Clave para el Video

1. **"El estado se actualiza DESPUÉS del CALL"**
2. **"5 llamadas anidadas exitosas"**
3. **"Balance no cambia hasta el final"**
4. **"Resultado: 0.5 ETH robados con 0.1 ETH depositado"**

## 🛡️ Comparación con Solución Segura

```bash
# Test del vault seguro
forge test --match-test testFixedVault -vvvv
```

## 💡 Tips para el Video

1. **Usar colores** en los console.log para destacar puntos clave
2. **Pausar** en cada breakpoint visual
3. **Mostrar** la traza completa
4. **Comparar** vulnerable vs seguro
5. **Enfatizar** el patrón Checks-Effects-Interactions
