const { Sequelize } = require('sequelize');

require('dotenv').config();

const { HOST, DATABASE_NAME, USERNAME, PASSWORD } = process.env;

console.log('DATABASE_NAME, HOST, ', DATABASE_NAME, HOST);

const sequelize = new Sequelize(DATABASE_NAME, 'buisihung11', PASSWORD, {
  host: HOST,
  dialect: 'mssql',
  dialectOptions: {
    options: {
      encrypt: true,
      trustServerCertificate: true,
    },
  },
  logging: false,
});

module.exports = sequelize;
