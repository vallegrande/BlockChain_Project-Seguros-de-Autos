// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Contrato de Seguro para Autos
/// @notice Este contrato permite la gestión de pólizas de seguros para automóviles.
contract PolizaSeguroAuto {
    address public asegurado;
    address public companiaSeguros;
    string public numeroPoliza;
    string public beneficios;
    uint256 public fechaInicio;
    uint256 public fechaVencimiento;
    enum EstadoPoliza { Vigente, Vencida, Cancelada }
    EstadoPoliza public estado;
    uint256 public saldoPendiente;

    /// @dev Constructor del contrato que inicializa las variables de estado.
    /// @param _numeroPoliza El número único de la póliza de seguro.
    /// @param _beneficios Descripción de los beneficios de la póliza.
    /// @param _companiaSeguros La dirección de la compañía de seguros.
    /// @param _fechaInicio La fecha de inicio de la póliza en formato de timestamp en segundos.
    /// @param _fechaVencimiento La fecha de vencimiento de la póliza en formato de timestamp en segundos.
    constructor(
        string memory _numeroPoliza,
        string memory _beneficios,
        address _companiaSeguros,
        uint256 _fechaInicio,
        uint256 _fechaVencimiento
    ) {
        asegurado = msg.sender;
        companiaSeguros = _companiaSeguros;
        numeroPoliza = _numeroPoliza;
        beneficios = _beneficios;
        fechaInicio = _fechaInicio;
        fechaVencimiento = _fechaVencimiento;
        estado = EstadoPoliza.Vigente;
        saldoPendiente = 0;
    }

    /// @notice Permite a los usuarios consultar el estado actual de la póliza.
    /// @return El estado actual de la póliza (Vigente, Vencida o Cancelada).
    function consultarEstadoPoliza() public view returns (EstadoPoliza) {
        return estado;
    }

    /// @notice Permite a la compañía de seguros actualizar los detalles de una póliza existente.
    /// @dev Solo la compañía de seguros puede llamar a esta función y solo para pólizas vigentes.
    /// @param nuevosBeneficios Los nuevos beneficios asociados con la póliza.
    /// @param nuevaFechaVencimiento La nueva fecha de vencimiento de la póliza en formato de timestamp en segundos.
    function actualizarPoliza(string memory nuevosBeneficios, uint256 nuevaFechaVencimiento) public {
        require(msg.sender == companiaSeguros, "Solo la compañía de seguros puede actualizar la póliza");
        require(estado == EstadoPoliza.Vigente, "No se puede actualizar una póliza vencida o cancelada");

        beneficios = nuevosBeneficios;
        fechaVencimiento = nuevaFechaVencimiento;
    }

    /// @notice Permite al asegurado reportar un siniestro a la compañía de seguros.
    /// @dev Solo el asegurado puede llamar a esta función y solo para pólizas vigentes.
    function reportarSiniestro() public {
        require(msg.sender == asegurado, "Solo el asegurado puede reportar un siniestro");
        require(estado == EstadoPoliza.Vigente, "No se pueden reportar siniestros para pólizas vencidas o canceladas");

        // Implementa aquí la lógica para registrar el siniestro.
    }

    /// @notice Permite al asegurado registrar un pago realizado para la póliza.
    /// @dev La función es payable, lo que significa que permite recibir Ether como pago.
    /// @param valorPago El valor del pago en Ether.
    function registrarPago(uint256 valorPago) public payable {
        require(msg.value == valorPago, "El valor enviado no coincide con el valor del pago");

        // Implementa aquí la lógica para registrar el pago y actualizar el saldo pendiente, si aplica.
        saldoPendiente += valorPago;
    }

    /// @notice Función especial que se ejecuta al enviar Ether al contrato sin datos adjuntos.
    receive() external payable {
        // Implementa aquí la lógica adicional si es necesario.
    }

    /// @notice Función especial que se ejecuta cuando se intenta llamar al contrato con una función inexistente o sin datos.
    fallback() external {
        // Implementa un comportamiento personalizado aquí, por ejemplo, revertir la transacción.
        revert("Función no válida");
    }
}
