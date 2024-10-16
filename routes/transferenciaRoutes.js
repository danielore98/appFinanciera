const express = require('express');
const db = require('../config/db');
const auth = require('../middleware/auth');

const router = express.Router();

// Realizar una transferencia entre cuentas de ahorro
router.post('/', auth, (req, res) => {
  const { cuentaOrigen, cuentaDestino, monto } = req.body;

  // Validar que los datos estén presentes
  if (!cuentaOrigen || !cuentaDestino || !monto || monto <= 0) {
    return res.status(400).json({ error: 'Los campos cuentaOrigen, cuentaDestino y monto son obligatorios y el monto debe ser mayor a cero' });
  }

  // Verificar que la cuenta de origen tenga suficiente saldo
  const checkSaldoQuery = 'SELECT saldo FROM cuentas_ahorro WHERE id = ?';
  db.query(checkSaldoQuery, [cuentaOrigen], (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Error al verificar el saldo de la cuenta de origen' });
    }

    if (result.length === 0) {
      return res.status(404).json({ error: 'La cuenta de origen no existe' });
    }

    const saldoOrigen = result[0].saldo;
    if (saldoOrigen < monto) {
      return res.status(400).json({ error: 'Saldo insuficiente en la cuenta de origen' });
    }

    // Actualizar el saldo de la cuenta de origen
    const debitarSaldoQuery = 'UPDATE cuentas_ahorro SET saldo = saldo - ? WHERE id = ?';
    db.query(debitarSaldoQuery, [monto, cuentaOrigen], (err) => {
      if (err) {
        return res.status(500).json({ error: 'Error al debitar saldo de la cuenta de origen' });
      }

      // Acreditar saldo en la cuenta de destino
      const acreditarSaldoQuery = 'UPDATE cuentas_ahorro SET saldo = saldo + ? WHERE id = ?';
      db.query(acreditarSaldoQuery, [monto, cuentaDestino], (err) => {
        if (err) {
          return res.status(500).json({ error: 'Error al acreditar saldo en la cuenta de destino' });
        }

        // Registrar la transferencia en la tabla transferencias
        const registrarTransferenciaQuery = 'INSERT INTO transferencias (cuenta_origen, cuenta_destino, monto) VALUES (?, ?, ?)';
        db.query(registrarTransferenciaQuery, [cuentaOrigen, cuentaDestino, monto], (err, result) => {
          if (err) {
            return res.status(500).json({ error: 'Error al registrar la transferencia en la base de datos', details: err });
          }

          // Respuesta exitosa
          res.json({ message: 'Transferencia realizada con éxito', transferenciaId: result.insertId });
        });
      });
    });
  });
});

module.exports = router;
