const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Token = sequelize.define(
  'Token',
  {
    // attributes
    token: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  { freezeTableName: true },
);

module.exports = Token;
