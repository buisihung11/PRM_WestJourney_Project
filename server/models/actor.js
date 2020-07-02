const { DataTypes } = require('sequelize');
const sequelize = require('../utils/sequilize');

const Actor = sequelize.define(
  'Actor',
  {
    // attributes
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    phone: DataTypes.STRING,
    description: DataTypes.STRING,
    imageURL: DataTypes.STRING,
    gender: {
      type: DataTypes.STRING,
      validate: {
        isIn: {
          args: [['male', 'female', 'others']],
          msg: 'Gender must be one of male, female or others',
        },
      },
    },
  },
  { freezeTableName: true },
);

module.exports = Actor;
