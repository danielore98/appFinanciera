const express = require('express');
const Ahorro = require('../models/ahorro');  // Modelo de cuentas de ahorro
const auth = require('../middleware/auth');  // Middleware de autenticación JWT

const router = express.Router();

// Obtener cuentas de ahorro de un cliente autenticado
router.get('/', auth, (req, res) => {
  const clienteId = req.user.id;  // ID del cliente autenticado

  Ahorro.obtenerCuentas(clienteId, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Error al obtener las cuentas de ahorro' });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'No se encontraron cuentas de ahorro para este cliente' });
    }
    res.json(result);  // Devolver las cuentas de ahorro en formato JSON
  });
});

// Registrar una cuenta de ahorro para un cliente autenticado
router.post('/', auth, async (req, res) => {
  const { saldo_inicial } = req.body;
  const cliente_id = req.user.id;  // Se obtiene el cliente autenticado desde el token JWT

  // Validación: El saldo inicial debe ser un número mayor a 0
  if (!saldo_inicial || saldo_inicial <= 0) {
    return res.status(400).json({ error: 'El saldo inicial debe ser mayor a cero' });
  }

  try {
    const nuevaCuenta = await Ahorro.crearCuenta(cliente_id, saldo_inicial);
    res.status(201).json({
      message: 'Cuenta de ahorro creada exitosamente',
      cuenta_id: nuevaCuenta.insertId,
      cliente_id,
      saldo_inicial,
    });
  } catch (err) {
    res.status(500).json({ message: 'Error al registrar la cuenta de ahorro', error: err.message });
  }
});

module.exports = router;
