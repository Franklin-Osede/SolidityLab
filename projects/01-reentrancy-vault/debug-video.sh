#!/bin/bash

echo "🔍 DEBUGGING REENTRANCY ATTACK - VIDEO DE LINKEDIN"
echo "=================================================="
echo ""

echo "📁 Navegando al directorio del proyecto..."
cd "$(dirname "$0")"

echo ""
echo "🎯 Ejecutando test de reentrancy con verbosidad máxima..."
echo ""

# Ejecutar el test
forge test --match-test testReentrancyWithdraw -vvvv

echo ""
echo "✅ Test completado. Analiza la salida para tu video."
echo ""
echo "📊 Puntos clave para destacar:"
echo "1. Las 5 llamadas anidadas de reentrancy"
echo "2. El estado no se actualiza hasta el final"
echo "3. Múltiples retiros exitosos con el mismo balance"
echo "4. El test falla al final por 'Insufficient balance'"
echo ""
echo "🎬 Para el video:"
echo "- Pausa en cada llamada anidada"
echo "- Muestra el balance que no cambia"
echo "- Compara con la solución segura"
