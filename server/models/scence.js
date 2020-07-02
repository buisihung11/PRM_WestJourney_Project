const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Scence = sequelize.define(
  'Scence',
  {
    // attributes
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: DataTypes.STRING,
    filmingAddress: DataTypes.STRING,
    filmingStartDate: DataTypes.DATE,
    filmingEndDate: DataTypes.DATE,
    setQuantity: DataTypes.INTEGER,
  },
  { freezeTableName: true },
);

module.exports = Scence;
