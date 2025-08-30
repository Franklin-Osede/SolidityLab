// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title SecureVaultOwnable
 * @dev Contrato seguro usando OpenZeppelin Ownable pattern
 * 
 * NIVEL 1: Basic Access Control
 * - Usa Ownable para funciones críticas
 * - Implementa Pausable para emergencias
 * - Usa ReentrancyGuard para prevenir reentrancy
 * 
 * MEJORAS IMPLEMENTADAS:
 * ✅ Access modifiers en todas las funciones críticas
 * ✅ Pausable para emergencias
 * ✅ ReentrancyGuard para seguridad adicional
 * ✅ Events para auditoría
 * ✅ Validaciones de entrada
 */
contract SecureVaultOwnable is Ownable, ReentrancyGuard, Pausable {
    // State variables
    mapping(address => uint256) public balances;
    uint256 public totalFunds;
    uint256 public maxWithdrawal;
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event MaxWithdrawalUpdated(uint256 oldValue, uint256 newValue);
    event EmergencyWithdraw(address indexed owner, uint256 amount);
    
    /**
     * @dev Constructor con configuración inicial
     */
    constructor(uint256 _maxWithdrawal) {
        maxWithdrawal = _maxWithdrawal;
    }
    
    /**
     * @dev Función de depósito - pública pero pausable
     */
    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "Amount must be greater than 0");
        
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @dev Función de retiro - solo owner
     * @notice Solo el owner puede retirar fondos
     */
    function withdraw(uint256 amount) external onlyOwner nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount <= maxWithdrawal, "Exceeds max withdrawal limit");
        
        totalFunds -= amount;
        
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
    
    /**
     * @dev Función para pausar el contrato - solo owner
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Función para despausar el contrato - solo owner
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Función para actualizar límite de retiro - solo owner
     */
    function updateMaxWithdrawal(uint256 newMaxWithdrawal) external onlyOwner {
        require(newMaxWithdrawal > 0, "Max withdrawal must be greater than 0");
        
        uint256 oldValue = maxWithdrawal;
        maxWithdrawal = newMaxWithdrawal;
        
        emit MaxWithdrawalUpdated(oldValue, newMaxWithdrawal);
    }
    
    /**
     * @dev Función de emergencia - solo owner
     * @notice Permite retirar todo en caso de emergencia
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        totalFunds = 0;
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Transfer failed");
        
        emit EmergencyWithdraw(msg.sender, balance);
    }
    
    /**
     * @dev Función para obtener balance de un usuario
     */
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
    
    /**
     * @dev Función para obtener balance del contrato
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Función para recibir ETH
     */
    receive() external payable {}
    
    /**
     * @dev Función para transferir ownership - override de Ownable
     * @notice Agrega validación adicional
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        super.transferOwnership(newOwner);
    }
}
