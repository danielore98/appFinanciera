const express = require('express');
const bcrypt = require('bcryptjs');  // Para el manejo de contraseñas
const jwt = require('jsonwebtoken'); // Para la autenticación
const db = require('../config/db');  // Importa la conexión a la base de datos

const router = express.Router();

// Registrar cliente
router.post('/register', (req, res) => {
  const { nombre, email, password } = req.body;

  // Validar que todos los campos estén presentes
  if (!nombre || !email || !password) {
    return res.status(400).json({ message: 'Todos los campos son obligatorios' });
  }

  // Verificar si el cliente ya existe
  const checkQuery = 'SELECT * FROM clientes WHERE email = ?';
  db.query(checkQuery, [email], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Error al verificar cliente existente' });
    }

    if (result.length > 0) {
      return res.status(400).json({ message: 'El cliente ya está registrado con este email' });
    }

    // Hash de la contraseña
    const hashedPassword = bcrypt.hashSync(password, 10);
    const query = 'INSERT INTO clientes (nombre, email, password) VALUES (?, ?, ?)';

    // Registrar el nuevo cliente
    db.query(query, [nombre, email, hashedPassword], (err, result) => {
      if (err) {
        return res.status(500).json({ message: 'Error al registrar cliente' });
      }
      res.status(201).json({ id: result.insertId, nombre, email });
    });
  });
});

// Login de cliente
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  // Validar que el email y la contraseña estén presentes
  if (!email || !password) {
    return res.status(400).json({ message: 'Email y contraseña son obligatorios' });
  }

  const query = 'SELECT * FROM clientes WHERE email = ?';
  
  // Buscar al cliente por su email
  db.query(query, [email], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Error al buscar el cliente' });
    }

    if (result.length === 0) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }
    
    const cliente = result[0];

    // Comparar la contraseña
    const isPasswordValid = bcrypt.compareSync(password, cliente.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }

    // Generar un token JWT
    const token = jwt.sign(
      { id: cliente.id, email: cliente.email },
      process.env.JWT_SECRET || 'secretkey',  // Usa una variable de entorno para mayor seguridad
      { expiresIn: '2h' }
    );

    res.json({ token, id: cliente.id });
  });
});

module.exports = router;
