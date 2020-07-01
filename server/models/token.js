const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Token = sequelize.define('Token', {
  // attributes
  token: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

module.exports = Token;
