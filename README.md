# 🚀 Solidity Lab - Debugging Avanzado

## 📋 Descripción

Este proyecto contiene **15 contratos vulnerables** diseñados específicamente para demostrar habilidades avanzadas de debugging en Solidity. Cada contrato incluye bugs intencionales que permiten debugging extraordinario y análisis profundo de la EVM.

## 🎯 Objetivos

- **Demostrar expertise real** en seguridad de smart contracts
- **Enseñar debugging avanzado** con herramientas profesionales
- **Crear contenido educativo** de alta calidad
- **Mejorar habilidades técnicas** en Solidity y EVM

## 📁 Estructura del Proyecto

```
Solidity Lab/
├── lib/                     # Dependencias de Foundry
├── projects/                # Todos los proyectos organizados
│   ├── 01-reentrancy-vault/ # Proyecto completo
│   │   ├── contracts/
│   │   │   ├── vulnerable/  # Contratos con bugs
│   │   │   ├── fixed/       # Contratos corregidos
│   │   │   └── interfaces/  # Interfaces
│   │   ├── test/            # Tests del proyecto
│   │   ├── script/          # Scripts de deployment
│   │   └── docs/            # Documentación
│   ├── 02-integer-overflow/
│   ├── 03-tx-origin-confusion/
│   ├── 04-storage-packing/
│   ├── 05-timestamp-dependence/
│   ├── 06-dex-front-running/
│   ├── 07-proxy-storage-collision/
│   ├── 08-gas-griefing/
│   ├── 09-delegatecall-malicious/
│   ├── 10-short-address-attack/
│   ├── 11-selfdestruct-exploit/
│   ├── 12-memory-vs-storage/
│   ├── 13-loop-dos/
│   ├── 14-external-vs-public/
│   └── 15-event-logging/
├── tools/                   # Herramientas compartidas
│   ├── debug-scripts/       # Scripts de debugging
│   ├── utilities/           # Utilidades comunes
│   └── config/              # Configuraciones
├── videos/                  # Guiones para videos
├── docs/                    # Documentación general
├── foundry.toml             # Configuración de Foundry
└── README.md                # Este archivo
```

## 🚨 Proyectos de Debugging

### 🔴 Seguridad Crítica (5 proyectos)
1. **Vault con Reentrancy** - El bug más famoso
2. **DEX Front-Running** - MEV y sandwich attacks
3. **Proxy Storage Collision** - Delegatecall avanzado
4. **Delegatecall Malicioso** - External calls inseguros
5. **Integer Overflow/Underflow** - Cálculos financieros

### 🟡 Lógica de Negocio (5 proyectos)
6. **Timestamp Dependence** - Manipulación de bloques
7. **Gas Griefing** - DoS por gas insuficiente
8. **tx.origin Confusion** - Phishing attacks
9. **Selfdestruct Exploit** - Destrucción de contratos
10. **Short Address Attack** - Manipulación de calldata

### 🔵 Optimización (5 proyectos)
11. **Storage Packing** - Optimización de gas
12. **Memory vs Storage** - Gestión de memoria
13. **External vs Public** - Visibilidad de funciones
14. **Loop DoS** - Bucles infinitos
15. **Event Logging** - Optimización de logs

## 🛠️ Herramientas de Debugging

### Foundry Suite
```bash
# Debugging paso a paso
forge debug <txHash>

# Trazas detalladas
forge test -vvvv

# Análisis de gas
forge test --gas-report

# Inspección de storage
cast storage <contract> <slot>
```

### Hardhat
```javascript
// Console logging
console.log("Debug:", value);

// Gas tracking
await contract.function({ gasLimit: 5000000 });
```

### Tenderly
- Debugger visual de transacciones
- Simulación de transacciones
- Análisis de gas en tiempo real

## 🚀 Empezando

### Prerrequisitos
```bash
# Instalar Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Instalar dependencias
forge install
```

### Configuración
```bash
# Copiar variables de entorno
cp .env.example .env

# Configurar variables
PRIVATE_KEY=tu_private_key
MAINNET_RPC_URL=tu_rpc_url
ETHERSCAN_API_KEY=tu_api_key
```

### Ejecutar el Primer Proyecto
```bash
# Compilar contratos
forge build

# Ejecutar tests del vault reentrancy
forge test --match-contract VulnerableVaultTest -vvvv

# Debug paso a paso
forge debug --match-test testReentrancyWithdraw

# Ejecutar desde el directorio del proyecto
cd projects/01-reentrancy-vault
forge test -vvvv
```

## 📊 Metodología de Debugging

### Fase 1: Setup y Reproducción
1. Deploy contrato vulnerable
2. Crear test que reproduce el bug
3. Documentar comportamiento esperado vs actual

### Fase 2: Análisis Profundo
1. Usar `forge debug` para stepping
2. Inspeccionar storage y stack
3. Analizar gas consumption
4. Identificar root cause

### Fase 3: Fix y Verificación
1. Implementar solución
2. Crear tests de seguridad
3. Verificar gas optimization
4. Documentar lecciones aprendidas

## 🎬 Formato de Video

### Estructura (5-8 minutos)
1. **Hook (30s):** "Hoy voy a romper este contrato y arreglarlo en vivo"
2. **Setup (1min):** Explicar el contrato y su propósito
3. **Bug Demo (2min):** Mostrar el bug funcionando
4. **Debugging (3min):** Usar herramientas para encontrar el problema
5. **Fix (1min):** Implementar la solución
6. **Verificación (30s):** Confirmar que está arreglado

## 📈 Skills que Demuestras

### EVM Internals
- Opcode analysis
- Storage layout understanding
- Gas mechanics
- Call stack manipulation

### Security Expertise
- Attack vector identification
- Vulnerability assessment
- Security pattern implementation
- Penetration testing

### Optimization Skills
- Gas efficiency analysis
- Storage optimization
- Contract design patterns
- Performance profiling

### Debugging Mastery
- Low-level debugging
- Transaction analysis
- Error root cause analysis
- Tool proficiency

## 🎯 Roadmap de Implementación

### Semana 1-2: Proyectos 1-5 (Seguridad Crítica)
- [x] Vault Reentrancy
- [ ] DEX Front-Running
- [ ] Proxy Storage Collision
- [ ] Delegatecall Malicioso
- [ ] Integer Overflow

### Semana 3-4: Proyectos 6-10 (Lógica de Negocio)
- [ ] Timestamp Dependence
- [ ] Gas Griefing
- [ ] tx.origin Confusion
- [ ] Selfdestruct Exploit
- [ ] Short Address Attack

### Semana 5-6: Proyectos 11-15 (Optimización)
- [ ] Storage Packing
- [ ] Memory vs Storage
- [ ] External vs Public
- [ ] Loop DoS
- [ ] Event Logging

## 🔍 Comandos de Testing - Access Control

### 🚀 Comandos Básicos
```bash
# Compilar todos los contratos
forge build

# Limpiar y recompilar
forge clean && forge build

# Ejecutar todos los tests
forge test

# Tests con output detallado
forge test -vvv

# Tests con máxima verbosidad (muestra todos los logs)
forge test -vvvv

# Tests de un contrato específico
forge test --match-contract AccessControlTest
```

### 🔍 Tests de Vulnerabilidades
```bash
# Test: Cualquiera puede retirar fondos (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

# Test: Cualquiera puede ser admin (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanAddAdmin" -vvvv

# Test: Cualquiera puede pausar contrato (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanPause" -vvvv

# Test: Cualquiera puede asignar roles (VULNERABLE)
forge test --match-test "test_VulnerableVault_AnyoneCanAssignRoles" -vvvv
```

### 🛡️ Tests de Soluciones de Seguridad

#### Seguridad Básica (Patrón Ownable)
```bash
# Test: Solo el owner puede retirar (SEGURO)
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

# Test: No-owners no pueden retirar (SEGURO)
forge test --match-test "test_SecureVault_NonOwnerCannotWithdraw" -vvvv

# Test: Solo el owner puede pausar (SEGURO)
forge test --match-test "test_SecureVault_OnlyOwnerCanPause" -vvvv

# Test: No-owners no pueden pausar (SEGURO)
forge test --match-test "test_SecureVault_NonOwnerCannotPause" -vvvv

# Test: Funcionalidad de retiro de emergencia
forge test --match-test "test_SecureVault_EmergencyWithdraw" -vvvv
```

#### Seguridad Avanzada (Control de Acceso Basado en Roles)
```bash
# Test: Control de acceso basado en roles
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

# Test: Aplicación de límite diario
forge test --match-test "test_AdvancedVault_DailyLimitEnforcement" -vvvv

# Test: Pausa de emergencia del guardian
forge test --match-test "test_AdvancedVault_GuardianEmergencyPause" -vvvv

# Test: Revocación de roles
forge test --match-test "test_AdvancedVault_RoleRevocation" -vvvv

# Test: Prevención de acceso no autorizado
forge test --match-test "test_AdvancedVault_UnauthorizedAccess" -vvvv
```

#### Seguridad Multi-Firma
```bash
# Test: Creación de propuestas
forge test --match-test "test_MultiSigVault_ProposalCreation" -vvvv

# Test: Proceso de aprobación de propuestas
forge test --match-test "test_MultiSigVault_ProposalApproval" -vvvv

# Test: Ejecución de propuestas con timelock
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

# Test: Aplicación de timelock
forge test --match-test "test_MultiSigVault_TimelockEnforcement" -vvvv

# Test: Rechazo por aprobaciones insuficientes
forge test --match-test "test_MultiSigVault_InsufficientApprovals" -vvvv

# Test: Funcionalidad de bypass de emergencia
forge test --match-test "test_MultiSigVault_EmergencyBypass" -vvvv
```

### 🔧 Tests de Casos Edge e Integración

#### Casos Edge
```bash
# Test: Prevención de aprobación duplicada
forge test --match-test "test_EdgeCase_DuplicateApproval" -vvvv

# Test: Prevención de retiro excesivo
forge test --match-test "test_EdgeCase_ExcessiveWithdrawal" -vvvv

# Test: Manejo de expiración de propuestas
forge test --match-test "test_EdgeCase_ProposalExpiry" -vvvv

# Test: Retiro de cantidad cero
forge test --match-test "test_EdgeCase_ZeroAmountWithdrawal" -vvvv
```

#### Tests de Integración
```bash
# Test: Integración de flujo completo
forge test --match-test "test_Integration_FullWorkflow" -vvvv

# Test: Flujo de trabajo multi-firma
forge test --match-test "test_Integration_MultiSigWorkflow" -vvvv
```

### 📊 Análisis y Reportes

#### Análisis de Gas
```bash
# Generar reporte de gas para todos los tests
forge test --gas-report

# Reporte de gas para test específico
forge test --match-test "test_MultiSigVault_ProposalExecution" --gas-report

# Reporte de gas para contrato específico
forge test --match-contract AccessControlTest --gas-report
```

#### Cobertura de Código
```bash
# Generar reporte de cobertura
forge coverage

# Cobertura para contrato específico
forge coverage --match-contract AccessControlTest

# Cobertura con output detallado
forge coverage --report lcov
```

### 🚀 Comandos de Deployment

#### Deployment Local
```bash
# Iniciar blockchain local
anvil

# Deploy contratos localmente
forge script content/access-control/scripts/Deploy.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv
```

#### Deployment en Testnet
```bash
# Deploy en Sepolia testnet
forge script content/access-control/scripts/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### 🎬 Script de Demo para LinkedIn
```bash
#!/bin/bash

echo "=== DEMOSTRACIÓN DE SEGURIDAD SOLIDITY ==="
echo ""

echo "1. MOSTRANDO VULNERABILIDADES:"
echo "Cualquiera puede retirar fondos:"
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

echo ""
echo "2. SOLUCIÓN DE SEGURIDAD BÁSICA:"
echo "Solo el owner puede retirar:"
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

echo ""
echo "3. SOLUCIÓN DE SEGURIDAD AVANZADA:"
echo "Control de acceso basado en roles:"
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

echo ""
echo "4. SOLUCIÓN DE SEGURIDAD EMPRESARIAL:"
echo "Gobernanza multi-firma:"
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

echo ""
echo "5. FLUJO COMPLETO:"
echo "Integración de extremo a extremo:"
forge test --match-test "test_Integration_FullWorkflow" -vvvv
```

### 🎯 Comandos Más Importantes para Demo
```bash
# Mostrar vulnerabilidades
forge test --match-test "test_VulnerableVault_AnyoneCanWithdraw" -vvvv

# Mostrar seguridad básica
forge test --match-test "test_SecureVault_OnlyOwnerCanWithdraw" -vvvv

# Mostrar seguridad avanzada
forge test --match-test "test_AdvancedVault_RoleBasedAccess" -vvvv

# Mostrar multi-firma
forge test --match-test "test_MultiSigVault_ProposalExecution" -vvvv

# Mostrar flujo completo
forge test --match-test "test_Integration_FullWorkflow" -vvvv
```

### 📝 Notas Importantes
- Usa `-vvvv` para máxima verbosidad y ver todos los logs y transacciones
- Usa `--gas-report` para analizar el consumo de gas
- Usa `--match-test` para ejecutar tests específicos
- Usa `--match-contract` para ejecutar todos los tests de un contrato específico
- Usa `forge coverage` para verificar la cobertura de código
- Usa el comando `time` para medir el tiempo de ejecución

## 📚 Recursos Adicionales

### Documentación
- [Solidity Docs](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)

### Herramientas
- [Tenderly](https://tenderly.co/)
- [Etherscan](https://etherscan.io/)
- [Hardhat](https://hardhat.org/)

### Comunidad
- [Ethereum Stack Exchange](https://ethereum.stackexchange.com/)
- [OpenZeppelin Forum](https://forum.openzeppelin.com/)
- [Solidity Discord](https://discord.gg/solidity)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🎯 Próximos Pasos

1. **Ejecutar el primer proyecto:** `forge test --match-contract VulnerableVaultTest`
2. **Crear el contrato seguro:** Implementar fixes
3. **Grabar el primer video:** Documentar el proceso
4. **Continuar con el siguiente proyecto:** Integer Overflow
5. **Construir la serie completa:** Los 15 proyectos

---

**¡Empezemos con el debugging extraordinario! 🚀**
