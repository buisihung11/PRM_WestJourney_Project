const { DataTypes } = require('sequelize');
const { hashSync } = require('bcryptjs');
const sequelize = require('../utils/sequilize');

const User = sequelize.define(
  'User',
  {
    // attributes
    username: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
      set(value) {
        // Storing passwords in plaintext in the database is terrible.
        // Hashing the value with an appropriate cryptographic hash function is better.
        this.setDataValue('password', hashSync(value));
      },
    },
    role: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isIn: [['admin', 'actor']],
      },
    },
  },
  { freezeTableName: true },
);

module.exports = User;
