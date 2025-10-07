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

## 🔍 Comandos Útiles

### Debugging
```bash
# Debug específico
forge test --match-test testReentrancyWithdraw -vvvv

# Análisis de gas
forge test --gas-report

# Storage inspection
cast storage <address> <slot>

# Call stack analysis
forge debug --verbosity 4

# Debug desde directorio del proyecto
cd projects/01-reentrancy-vault
forge test --match-test testReentrancyWithdraw -vvvv
```

### Deployment
```bash
# Deploy en local
forge script projects/01-reentrancy-vault/script/Deploy.s.sol --rpc-url anvil

# Deploy en testnet
forge script projects/01-reentrancy-vault/script/Deploy.s.sol --rpc-url sepolia --broadcast

# Deploy desde directorio del proyecto
cd projects/01-reentrancy-vault
forge script script/Deploy.s.sol --rpc-url anvil
```

### Testing
```bash
# Ejecutar todos los tests
forge test

# Ejecutar tests específicos
forge test --match-contract VulnerableVaultTest

# Tests con gas report
forge test --gas-report --match-contract VulnerableVaultTest

# Tests desde directorio del proyecto
cd projects/01-reentrancy-vault
forge test -vvvv
```

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
