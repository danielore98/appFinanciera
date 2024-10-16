const jwt = require('jsonwebtoken');

// Middleware de autenticación
const auth = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // El token está después de 'Bearer '

  // Agregar un print para ver el token recibido
  console.log("Token recibido en el backend: ", token);

  if (!token) {
    return res.status(401).json({ message: 'Acceso denegado. No se proporcionó un token.' });
  }

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET || 'secretkey');
    req.user = verified;  // Asignar los datos del usuario decodificados a req.user
    next();  // Continuar al siguiente middleware o ruta
  } catch (err) {
    return res.status(403).json({ message: 'Token inválido o expirado.' });
  }
};

module.exports = auth;
