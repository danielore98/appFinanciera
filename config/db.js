const mysql = require('mysql2');

// Crear una conexión a la base de datos
const db = mysql.createConnection({
  host: 'localhost',      // Asegúrate de cambiarlo si usas otro host (por ejemplo, una IP remota)
  user: 'root',           // Asegúrate de cambiarlo según tu configuración
  password: 'root',     // Asegúrate de cambiar la contraseña a la correcta
  database: 'dbfinan',    // Nombre de la base de datos
  port: 3306,             // El puerto predeterminado de MySQL es 3306
});

// Intentar conectar a la base de datos
db.connect((err) => {
  if (err) {
    console.error('Error al conectar a la base de datos:', err.message);
    return;
  }
  console.log('Conectado a la base de datos MySQL.');
});

// Manejo de cierre de conexión
db.on('error', (err) => {
  console.error('Error en la conexión de la base de datos:', err.message);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.log('Intentando reconectar a la base de datos...');
    db.connect((err) => {
      if (err) {
        console.error('Error al reconectar a la base de datos:', err.message);
      } else {
        console.log('Reconectado a la base de datos MySQL.');
      }
    });
  } else {
    throw err;
  }
});

module.exports = db;

