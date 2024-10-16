const express = require('express');
const Prestamo = require('../models/prestamo');
const auth = require('../middleware/auth');

const router = express.Router();

// Solicitar préstamo
router.post('/', auth, (req, res) => {
  const clienteId = req.user.id;
  const { monto } = req.body;

  // Validar que el monto sea mayor a 0
  if (!monto || monto <= 0) {
    return res.status(400).json({ error: 'El monto del préstamo debe ser mayor a cero' });
  }

  Prestamo.solicitarPrestamo(clienteId, monto, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Error al solicitar préstamo', details: err });
    }
    res.status(201).json({ message: 'Préstamo solicitado con éxito', prestamoId: result });
  });
});

// Obtener cuentas de préstamo de un cliente
router.get('/', auth, (req, res) => {
  const clienteId = req.user.id;

  Prestamo.obtenerCuentasPrestamo(clienteId, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Error al obtener cuentas de préstamo', details: err });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'No se encontraron cuentas de préstamo para este cliente' });
    }
    res.json(result);
  });
});

// Pagar préstamo
router.post('/pago', auth, (req, res) => {
  const { cuentaPrestamoId, montoPago } = req.body;

  // Validar que los datos estén presentes
  if (!cuentaPrestamoId || !montoPago || montoPago <= 0) {
    return res.status(400).json({ error: 'Los campos cuentaPrestamoId y montoPago son obligatorios y el monto debe ser mayor a cero' });
  }

  Prestamo.pagarPrestamo(cuentaPrestamoId, montoPago, (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Error al realizar el pago del préstamo', details: err });
    }
    res.json({ message: 'Pago realizado con éxito', result });
  });
});

module.exports = router;
