const db = require('../config/db');

const Prestamo = {};

// Solicitar un préstamo
Prestamo.solicitarPrestamo = (clienteId, monto, callback) => {
  // Validar que el monto sea válido
  if (monto <= 0) {
    return callback('El monto del préstamo debe ser mayor a cero', null);
  }

  const query = 'INSERT INTO cuentas_prestamo (cliente_id, monto_prestamo, saldo_pendiente, fecha_aprobacion) VALUES (?, ?, ?, CURDATE())';

  db.query(query, [clienteId, monto, monto], (err, result) => {
    if (err) {
      return callback('Error al solicitar el préstamo', null);
    }
    callback(null, result.insertId);  // Devolver el ID de la nueva cuenta de préstamo
  });
};

// Obtener cuentas de préstamo de un cliente
Prestamo.obtenerCuentasPrestamo = (clienteId, callback) => {
  const query = 'SELECT * FROM cuentas_prestamo WHERE cliente_id = ?';

  db.query(query, [clienteId], (err, result) => {
    if (err) {
      return callback('Error al obtener las cuentas de préstamo', null);
    }
    callback(null, result);  // Devolver las cuentas de préstamo del cliente
  });
};

// Realizar pago de préstamo
Prestamo.pagarPrestamo = (cuentaPrestamoId, montoPago, callback) => {
  // Validar que el monto de pago sea válido
  if (montoPago <= 0) {
    return callback('El monto de pago debe ser mayor a cero', null);
  }

  const query = 'INSERT INTO pagos_prestamos (cuenta_prestamo_id, monto_pago, fecha_pago) VALUES (?, ?, CURDATE())';

  db.query(query, [cuentaPrestamoId, montoPago], (err, result) => {
    if (err) {
      return callback('Error al registrar el pago', null);
    }

    // Actualizar el saldo pendiente en la cuenta de préstamo
    db.query('UPDATE cuentas_prestamo SET saldo_pendiente = saldo_pendiente - ? WHERE id = ?', [montoPago, cuentaPrestamoId], (err) => {
      if (err) {
        return callback('Error al actualizar saldo pendiente', null);
      }

      callback(null, 'Pago realizado con éxito');  // Confirmación del pago exitoso
    });
  });
};

module.exports = Prestamo;
