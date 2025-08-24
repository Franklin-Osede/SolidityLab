#!/bin/bash

# 🎥 Script de Demostración - Reentrancy Attack
# Para usar en el video de debugging

set -e

echo "🎬 INICIANDO DEMOSTRACIÓN DE REENTRANCY ATTACK"
echo "=============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_step() {
    echo -e "${BLUE}[PASO $1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "foundry.toml" ]; then
    print_error "No se encontró foundry.toml. Ejecuta este script desde la raíz del proyecto."
    exit 1
fi

print_step "1" "Compilando contratos..."
forge build --silent
print_success "Contratos compilados exitosamente"

print_step "2" "Ejecutando tests de vulnerabilidad..."
echo ""
forge test --match-test testVulnerabilityDemo -vvv
echo ""

print_step "3" "Ejecutando tests de seguridad..."
echo ""
forge test --match-test testSecurityDemo -vvv
echo ""

print_step "4" "Comparando resultados..."
echo ""
forge test --match-test testComparison -vvv
echo ""

print_step "5" "Demostrando protección ReentrancyGuard..."
echo ""
forge test --match-test testReentrancyGuardProtection -vvv
echo ""

print_step "6" "Demostrando patrón Checks-Effects-Interactions..."
echo ""
forge test --match-test testChecksEffectsInteractions -vvv
echo ""

print_success "🎉 Demostración completada exitosamente!"
echo ""
echo "📊 RESUMEN DE LA DEMOSTRACIÓN:"
echo "=============================="
echo "• Vulnerable Vault: Drenado por reentrancy"
echo "• Fixed Vault: Protegido con ReentrancyGuard"
echo "• Patrón CEI: Implementado correctamente"
echo "• Tests: Todos pasaron exitosamente"
echo ""
echo "🎬 ¡Listo para el video!"
