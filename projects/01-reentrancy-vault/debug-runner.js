const { execSync } = require('child_process');

console.log('🔍 DEBUGGING REENTRANCY ATTACK - VIDEO DE LINKEDIN');
console.log('==================================================');
console.log('');

try {
    console.log('🎯 Ejecutando test de reentrancy con verbosidad máxima...');
    console.log('');
    
    // Ejecutar el comando
    const result = execSync('forge test --match-test testReentrancyWithdraw -vvvv', { 
        encoding: 'utf8',
        stdio: 'inherit'
    });
    
    console.log('');
    console.log('✅ Test completado. Analiza la salida para tu video.');
    console.log('');
    console.log('📊 Puntos clave para destacar:');
    console.log('1. Las 5 llamadas anidadas de reentrancy');
    console.log('2. El estado no se actualiza hasta el final');
    console.log('3. Múltiples retiros exitosos con el mismo balance');
    console.log('4. El test falla al final por "Insufficient balance"');
    console.log('');
    console.log('🎬 Para el video:');
    console.log('- Pausa en cada llamada anidada');
    console.log('- Muestra el balance que no cambia');
    console.log('- Compara con la solución segura');
    
} catch (error) {
    console.error('❌ Error ejecutando el test:', error.message);
}
