const { Sequelize } = require('sequelize');

require('dotenv').config();

const { HOST, DATABASE_NAME, USERNAME, PASSWORD } = process.env;

const sequelize = new Sequelize(DATABASE_NAME, 'buisihung11', PASSWORD, {
  host: HOST,
  dialect: 'mssql',
  dialectOptions: {
    options: {
      encrypt: true,
      trustServerCertificate: true,
    },
  },
});

module.exports = sequelize;
