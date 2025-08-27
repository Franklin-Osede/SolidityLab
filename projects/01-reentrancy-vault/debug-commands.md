# 🔍 Comandos de Debugging para Video de LinkedIn

## 🎯 Comando Principal
```bash
forge test --match-test testReentrancyWithdraw -vvvv
```

## 🛠️ Comandos de Debugging Avanzado

### 1. Debug con Traza Completa
```bash
forge test --match-test testReentrancyWithdraw -vvvv --gas-report
```

### 2. Debug con Storage Layout
```bash
forge test --match-test testReentrancyWithdraw -vvvv --storage-layout
```

### 3. Debug con Opcodes
```bash
forge test --match-test testReentrancyWithdraw -vvvv --show-opcodes
```

### 4. Debug Interactivo
```bash
forge test --match-test testReentrancyWithdraw -vvvv --debug
```

## 📍 Breakpoints Estratégicos

### VulnerableVault.sol
- **Línea 20**: Verificar balance antes del CALL
- **Línea 23**: Punto de la llamada externa (CALL)
- **Línea 26**: Actualización del estado (DESPUÉS del CALL) ← CLAVE

### Attacker.sol
- **Línea 75**: Inicio de receive() function
- **Línea 85**: Condición de reentrancy
- **Línea 87**: Segunda llamada a withdraw() ← CLAVE

## 🎬 Variables a Monitorear

### Estado del Vault
- `balances[attacker]` - Balance del atacante
- `address(vault).balance` - Balance del contrato

### Estado del Attacker
- `attackCount` - Número de ataques ejecutados
- `totalStolen` - Total robado
- `address(this).balance` - Balance del atacante

## 🔍 Puntos Clave para el Video

1. **Antes del CALL**: `balances[attacker] = 1 ETH`
2. **Durante receive()**: `attackCount = 1, totalStolen = 1 ETH`
3. **Segunda llamada**: `balances[attacker] = 1 ETH` (¡NO CAMBIÓ!)
4. **Resultado final**: `totalStolen = 5 ETH`

## 🛡️ Comparación con FixedVault

```bash
# Test del vault seguro
forge test --match-test testFixedVault -vvvv
```

## 📊 Análisis de Gas

```bash
# Ver gas usado en cada operación
forge test --match-test testReentrancyWithdraw -vvvv --gas-report
```
