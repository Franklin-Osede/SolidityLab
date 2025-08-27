# 🔍 Breakpoints para Debugging Visual - Video de LinkedIn

## 📍 Breakpoints Estratégicos en el Código

### 🛑 **VulnerableVault.sol - Líneas Clave:**

#### **Línea 23-26: BREAKPOINT 1 - Antes del require**
```solidity
console.log("🛑 BREAKPOINT 1 - Antes del require:");
console.log("   - Balance actual:", balances[msg.sender]);
console.log("   - Amount a retirar:", amount);
console.log("   - Caller:", msg.sender);
```
**¿Qué verás?**
- Balance actual del usuario
- Cantidad que quiere retirar
- Dirección del caller

#### **Línea 30-33: BREAKPOINT 2 - Antes del CALL**
```solidity
console.log("🛑 BREAKPOINT 2 - Antes del CALL:");
console.log("   - Balance antes del CALL:", balances[msg.sender]);
console.log("   - Amount a enviar:", amount);
```
**¿Qué verás?**
- Balance antes de la llamada externa
- Cantidad que se va a enviar

#### **Línea 38-42: BREAKPOINT 3 - Después del CALL**
```solidity
console.log("🛑 BREAKPOINT 3 - Después del CALL:");
console.log("   - CALL exitoso:", success);
console.log("   - Balance después del CALL:", balances[msg.sender]);
console.log("   - Balance NO ha cambiado aún!");
```
**¿Qué verás?**
- Si el CALL fue exitoso
- **¡CLAVE!** El balance NO ha cambiado aún
- Esto permite el reentrancy

#### **Línea 47-50: BREAKPOINT 4 - Después de actualizar estado**
```solidity
console.log("🛑 BREAKPOINT 4 - Después de actualizar estado:");
console.log("   - Balance final:", balances[msg.sender]);
console.log("   - Estado actualizado DESPUÉS del CALL!");
```
**¿Qué verás?**
- Balance final después de la actualización
- **¡BUG!** Estado actualizado DESPUÉS del CALL

### 🛑 **Attacker.sol - Líneas Clave:**

#### **Línea 75-82: BREAKPOINT ATTACKER - Receive llamado**
```solidity
console.log("🛑 BREAKPOINT ATTACKER - Receive llamado:");
console.log("   - ETH recibido:", msg.value);
console.log("   - Attack count antes:", attackCount);
console.log("   - Total stolen antes:", totalStolen);
console.log("   - Balance del vault:", address(vault).balance);
console.log("   - Balance del attacker:", address(this).balance);
```
**¿Qué verás?**
- ETH recibido en el receive()
- Contadores antes de actualizar
- Balances actuales

#### **Línea 87-90: BREAKPOINT ATTACKER - Después de actualizar contadores**
```solidity
console.log("🛑 BREAKPOINT ATTACKER - Después de actualizar contadores:");
console.log("   - Attack count después:", attackCount);
console.log("   - Total stolen después:", totalStolen);
```
**¿Qué verás?**
- Contadores actualizados
- Total robado hasta el momento

#### **Línea 96-102: BREAKPOINT ATTACKER - Ejecutando reentrancy**
```solidity
console.log("🛑 BREAKPOINT ATTACKER - Ejecutando reentrancy:");
console.log("   - Attack count:", attackCount);
console.log("   - Vault balance disponible:", address(vault).balance);
console.log("   - Amount a retirar:", msg.value);
console.log("   - ¡LLAMANDO withdraw() NUEVAMENTE!");
```
**¿Qué verás?**
- **¡CLAVE!** Llamada a withdraw() nuevamente
- Balance disponible en el vault
- Cantidad a retirar

## 🎬 Script para el Video

### **Paso 1: Mostrar los Breakpoints**
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

## 🔍 Variables Clave a Monitorear

### **En VulnerableVault:**
- `balances[msg.sender]` - Balance del usuario
- `amount` - Cantidad a retirar
- `success` - Si el CALL fue exitoso

### **En Attacker:**
- `attackCount` - Número de ataques
- `totalStolen` - Total robado
- `address(vault).balance` - Balance del vault
- `address(this).balance` - Balance del attacker

## 🎯 Puntos Clave para el Video

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
