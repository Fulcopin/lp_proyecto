const express = require('express');
const { sequelize, authenticateDB } = require('./config/db'); // Importa sequelize y authenticateDB
const app = express();
const path = require('path');
const fs = require('fs');

// Crear la carpeta 'uploads' si no existe
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)){
    fs.mkdirSync(uploadsDir);
}

// Configurar middlewares
app.use(express.json());

// Permitir CORS para todas las rutas
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-auth-token');
    next();
});

// Conectar a la base de datos y sincronizar modelos
authenticateDB().then(() => {
    // Sincronizar los modelos con la base de datos solo después de autenticar
    sequelize.sync().then(() => {
      console.log('All models were synchronized successfully.');
  
      // Definir rutas (después de la sincronización para asegurar que las tablas existan)
      app.use('/api/users', require('./routes/user.routes'));
      app.use('/api/search', require('./routes/search.routes'));
      app.use('/api/friends', require('./routes/friend.routes'));
      app.use('/api/messages', require('./routes/message.routes'));
  
      // Ruta de bienvenida (opcional)
      app.get('/', (req, res) => res.send('API Running'));
  
      const PORT = process.env.PORT || 5000;
      app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
    });
});