const { execSync } = require('child_process');

console.log('🔍 DEBUGGING ALL TESTS - VIDEO DE LINKEDIN');
console.log('===========================================');
console.log('');

try {
    console.log('🎯 Ejecutando todos los tests con verbosidad máxima...');
    console.log('');
    
    // Ejecutar el comando
    const result = execSync('forge test -vvvv', { 
        encoding: 'utf8',
        stdio: 'inherit'
    });
    
    console.log('');
    console.log('✅ Tests completados. Analiza la salida para tu video.');
    console.log('');
    console.log('📊 Puntos clave para destacar:');
    console.log('1. Tests vulnerables fallan (como esperado)');
    console.log('2. Tests seguros pasan');
    console.log('3. Compara las diferencias en la traza');
    console.log('4. Muestra el patrón Checks-Effects-Interactions');
    
} catch (error) {
    console.error('❌ Error ejecutando los tests:', error.message);
}
