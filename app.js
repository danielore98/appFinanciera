
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const clienteRoutes = require('./routes/clienteRoutes');
const ahorroRoutes = require('./routes/ahorroRoutes');
const prestamoRoutes = require('./routes/prestamoRoutes');
const transferenciaRoutes = require('./routes/transferenciaRoutes');

// Configuración del servidor
const app = express();
app.use(cors());
app.use(bodyParser.json());

// Ruta básica para manejar GET en la raíz '/'
app.get('/', (req, res) => {
  res.send('Bienvenido al servidor de la aplicación financiera.');
});

// Rutas
app.use('/clientes', clienteRoutes);
app.use('/ahorros', ahorroRoutes);
app.use('/prestamos', prestamoRoutes);
app.use('/transferencias', transferenciaRoutes);

// Establece un tiempo de espera más largo para las solicitudes
app.use((req, res, next) => {
  req.setTimeout(720000); // 720 segundos
  next();
});

// Inicializar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
