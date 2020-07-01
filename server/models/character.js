const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Character = sequelize.define('Character', {
  // attributes
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  descriptionFileURL: DataTypes.STRING,
});

module.exports = Character;
