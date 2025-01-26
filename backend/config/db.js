require('dotenv').config();
const { Sequelize } = require('sequelize');

// Crea una nueva instancia de Sequelize utilizando las variables de entorno
const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: process.env.DB_DIALECT,
        port: process.env.DB_PORT || 3306,
        logging: false,
    }
);

// Autentica la conexión (y exporta la promesa)
const authenticateDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('Conectado a la base de datos MySQL');
  } catch (err) {
    console.error('Error al conectar a la base de datos:', err);
    process.exit(1); // Termina el proceso si hay un error en la conexión
  }
};

module.exports = { sequelize, authenticateDB };