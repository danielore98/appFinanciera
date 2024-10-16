// models/ahorro.js
const db = require('../config/db'); // Asegúrate de que esta es la conexión a la base de datos

const Ahorro = {};

// Crear una nueva cuenta de ahorro
Ahorro.crearCuenta = (cliente_id, saldo_inicial) => {
  return new Promise((resolve, reject) => {
    const query = 'INSERT INTO cuentas_ahorro (cliente_id, saldo) VALUES (?, ?)';
    
    db.query(query, [cliente_id, saldo_inicial], (err, result) => {
      if (err) {
        return reject(err);
      }
      resolve(result);
    });
  });
};

// Obtener todas las cuentas de ahorro de un cliente
Ahorro.obtenerCuentas = (clienteId, callback) => {
  const query = 'SELECT * FROM cuentas_ahorro WHERE cliente_id = ?';

  db.query(query, [clienteId], (err, result) => {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

// Realizar una transferencia entre cuentas de ahorro
Ahorro.realizarTransferencia = (cuentaOrigen, cuentaDestino, monto, callback) => {
  // Primero, verificar el saldo de la cuenta de origen
  db.query('SELECT saldo FROM cuentas_ahorro WHERE id = ?', [cuentaOrigen], (err, result) => {
    if (err || result.length === 0) {
      callback('Cuenta de origen no encontrada', null);
    } else {
      const saldo = result[0].saldo;
      if (saldo < monto) {
        callback('Saldo insuficiente', null);
      } else {
        // Actualizar saldos de las cuentas
        db.query('UPDATE cuentas_ahorro SET saldo = saldo - ? WHERE id = ?', [monto, cuentaOrigen], (err) => {
          if (err) {
            callback('Error al debitar de la cuenta de origen', null);
          } else {
            db.query('UPDATE cuentas_ahorro SET saldo = saldo + ? WHERE id = ?', [monto, cuentaDestino], (err) => {
              if (err) {
                callback('Error al acreditar en la cuenta de destino', null);
              } else {
                callback(null, 'Transferencia realizada con éxito');
              }
            });
          }
        });
      }
    }
  });
};

module.exports = Ahorro;
