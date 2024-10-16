const db = require('../config/db');
const bcrypt = require('bcryptjs');

const Cliente = {};

// Registrar un nuevo cliente
Cliente.registrar = (nombre, email, password, callback) => {
  // Validar que todos los campos estén presentes
  if (!nombre || !email || !password) {
    return callback('Todos los campos son obligatorios', null);
  }

  // Comprobar si el cliente ya está registrado
  const checkQuery = 'SELECT * FROM clientes WHERE email = ?';
  db.query(checkQuery, [email], (err, result) => {
    if (err) {
      return callback('Error al verificar si el cliente ya existe', null);
    }

    if (result.length > 0) {
      return callback('El cliente ya está registrado con este email', null);
    }

    // Hash de la contraseña solo si el cliente no existe
    const hashedPassword = bcrypt.hashSync(password, 10);

    // Registrar el nuevo cliente
    const insertQuery = 'INSERT INTO clientes (nombre, email, password) VALUES (?, ?, ?)';
    db.query(insertQuery, [nombre, email, hashedPassword], (err, result) => {
      if (err) {
        return callback('Error al registrar el cliente', null);
      }
      // Devolver el ID del cliente recién creado
      callback(null, result.insertId);
    });
  });
};

// Iniciar sesión de un cliente
Cliente.login = (email, password, callback) => {
  // Validar que los campos email y password estén presentes
  if (!email || !password) {
    return callback('Email y contraseña son obligatorios', null);
  }

  const query = 'SELECT * FROM clientes WHERE email = ?';

  // Buscar al cliente en la base de datos
  db.query(query, [email], (err, result) => {
    if (err) {
      return callback('Error al buscar el cliente en la base de datos', null);
    }

    if (result.length === 0) {
      return callback('Email no encontrado', null);
    }

    const cliente = result[0];

    // Comparar la contraseña
    const isPasswordValid = bcrypt.compareSync(password, cliente.password);
    if (!isPasswordValid) {
      return callback('Contraseña incorrecta', null);
    }

    // Si la contraseña es válida, devolver el objeto cliente (sin la contraseña)
    const clienteInfo = {
      id: cliente.id,
      nombre: cliente.nombre,
      email: cliente.email
    };

    callback(null, clienteInfo);
  });
};

module.exports = Cliente;
