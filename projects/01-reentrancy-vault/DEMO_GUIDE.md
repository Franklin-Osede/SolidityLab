# 🎥 Guía de Demostración - Reentrancy Attack

## 📋 Pasos para el Video de Debugging

### **Paso 1: Configuración Inicial**
```bash
# 1. Navegar al proyecto
cd projects/01-reentrancy-vault

# 2. Instalar dependencias (si no están instaladas)
forge install OpenZeppelin/openzeppelin-contracts

# 3. Compilar contratos
forge build
```

### **Paso 2: Desplegar Contratos**
```bash
# 1. Configurar variable de entorno
export PRIVATE_KEY="tu_clave_privada_aqui"

# 2. Desplegar todos los contratos
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast

# 3. Verificar despliegue
cat deployment.json
```

### **Paso 3: Demostración de la Vulnerabilidad**

#### **3.1 Mostrar el Código Vulnerable**
```solidity
// En VulnerableVault.sol - Líneas 25-35
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // ❌ BUG: State updated AFTER the CALL
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
    
    // ❌ BUG: State updated after the CALL
    balances[msg.sender] -= amount;
}
```

#### **3.2 Explicar el Problema**
- **Problema:** El estado se actualiza DESPUÉS de la llamada externa
- **Vulnerabilidad:** Permite múltiples retiros antes de actualizar el balance
- **Impacto:** Drenado completo del contrato

#### **3.3 Ejecutar el Ataque**
```bash
# 1. Fondear el vault vulnerable
forge script script/Deploy.s.sol:DeployScript --sig "fundVaults()" --rpc-url http://localhost:8545 --broadcast

# 2. Ejecutar el ataque
forge script script/Deploy.s.sol:DeployScript --sig "demonstrateVulnerability()" --rpc-url http://localhost:8545 --broadcast
```

### **Paso 4: Análisis del Ataque**

#### **4.1 Mostrar el Código del Atacante**
```solidity
// En Attacker.sol - Líneas 85-105
receive() external payable {
    totalStolen += msg.value;
    attackCount++;
    
    // ❌ ATTACK: Reentrancy in withdraw
    if (attackCount < 5 && address(vault).balance >= msg.value) {
        vault.withdraw(msg.value); // Llamada recursiva
    }
}
```

#### **4.2 Explicar el Mecanismo**
- **Trigger:** Función `receive()` se ejecuta cuando recibe ETH
- **Recursión:** Llama `withdraw()` nuevamente antes de que se actualice el estado
- **Resultado:** Múltiples retiros con el mismo balance

### **Paso 5: Demostración de la Solución**

#### **5.1 Mostrar el Código Seguro**
```solidity
// En FixedVault.sol - Líneas 25-35
function withdraw(uint256 amount) external override nonReentrant {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // ✅ EFFECTS: Update state BEFORE external call
    balances[msg.sender] -= amount;
    
    // ✅ INTERACTIONS: External call after state update
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

#### **5.2 Explicar las Protecciones**
- **ReentrancyGuard:** Modificador `nonReentrant`
- **Checks-Effects-Interactions:** Patrón de seguridad
- **Estado Actualizado:** Antes de llamadas externas

#### **5.3 Probar la Protección**
```bash
# Ejecutar ataque contra vault seguro
forge script script/Deploy.s.sol:DeployScript --sig "demonstrateSecurity()" --rpc-url http://localhost:8545 --broadcast
```

### **Paso 6: Comparación de Resultados**

#### **6.1 Resultados del Ataque Vulnerable**
```bash
# Verificar balances después del ataque
forge script script/Deploy.s.sol:DeployScript --sig "checkVulnerableResults()" --rpc-url http://localhost:8545
```

#### **6.2 Resultados del Ataque Seguro**
```bash
# Verificar que las protecciones funcionan
forge script script/Deploy.s.sol:DeployScript --sig "checkSecureResults()" --rpc-url http://localhost:8545
```

## 🎬 **Script del Video**

### **Introducción (30 segundos)**
"En este video vamos a demostrar una de las vulnerabilidades más peligrosas en Solidity: el ataque de reentrancy. Veremos cómo un contrato vulnerable puede ser drenado completamente y cómo solucionarlo."

### **Explicación del Problema (2 minutos)**
1. Mostrar el código vulnerable
2. Explicar el patrón incorrecto
3. Mostrar el flujo de ejecución problemático

### **Demostración del Ataque (3 minutos)**
1. Desplegar contratos
2. Ejecutar el ataque
3. Mostrar los resultados en tiempo real
4. Explicar el mecanismo de recursión

### **Solución y Protecciones (2 minutos)**
1. Mostrar el código corregido
2. Explicar las medidas de seguridad
3. Demostrar que el ataque falla

### **Comparación Final (1 minuto)**
1. Mostrar diferencias en balances
2. Resumir las lecciones aprendidas
3. Recomendaciones de seguridad

## 🔧 **Comandos Útiles para el Video**

### **Verificar Estado de Contratos**
```bash
# Ver balance del vault vulnerable
cast balance <VAULT_ADDRESS> --rpc-url http://localhost:8545

# Ver balance del atacante
cast balance <ATTACKER_ADDRESS> --rpc-url http://localhost:8545

# Ver logs de eventos
cast logs --from-block latest --rpc-url http://localhost:8545
```

### **Ejecutar Tests**
```bash
# Ejecutar tests de vulnerabilidad
forge test --match-test testVulnerability -vvv

# Ejecutar tests de seguridad
forge test --match-test testSecurity -vvv
```

### **Debugging con Traces**
```bash
# Ver trace detallado de transacción
forge script script/Deploy.s.sol:DeployScript --sig "demonstrateVulnerability()" --rpc-url http://localhost:8545 --broadcast -vvvv
```

## 📊 **Métricas para Mostrar**

### **Antes del Ataque**
- Vault balance: 10 ETH
- Attacker balance: 0 ETH
- User balance en vault: 1 ETH

### **Después del Ataque (Vulnerable)**
- Vault balance: ~0 ETH
- Attacker balance: ~10 ETH
- User balance en vault: 1 ETH (no actualizado)

### **Después del Ataque (Seguro)**
- Vault balance: ~9 ETH
- Attacker balance: 1 ETH
- User balance en vault: 0 ETH (correctamente actualizado)

## 🎯 **Puntos Clave para el Video**

1. **Mostrar el código en tiempo real**
2. **Explicar cada línea problemática**
3. **Ejecutar comandos en vivo**
4. **Mostrar resultados inmediatos**
5. **Comparar antes y después**
6. **Explicar las soluciones paso a paso**

¡Con esta guía tienes todo lo necesario para crear un video completo y educativo sobre reentrancy attacks!
