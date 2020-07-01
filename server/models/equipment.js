const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Equipment = sequelize.define('Equipment', {
  // attributes
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: DataTypes.STRING,
  imageURL: DataTypes.STRING,
  status: DataTypes.STRING,
  quantity: DataTypes.INTEGER,
});

module.exports = Equipment;
