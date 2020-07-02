const { DataTypes } = require('sequelize');
const { hashSync } = require('bcryptjs');
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
const Character = sequelize.define(
  'Character',
  {
    // attributes
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    descriptionFileURL: DataTypes.STRING,
  },
  { freezeTableName: true },
);
const Equipment = sequelize.define(
  'Equipment',
  {
    // attributes
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: DataTypes.STRING,
    imageURL: DataTypes.STRING,
    status: DataTypes.STRING,
    quantity: DataTypes.INTEGER,
  },
  { freezeTableName: true },
);
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

const ActorCharactor = sequelize.define(
  'ActorCharactor',
  {},
  { freezeTableName: true },
);
const ScenceEquipment = sequelize.define(
  'ScenceEquipment',
  {},
  { freezeTableName: true },
);

const configModel = async () => {
  Scence.belongsToMany(Equipment, { through: ScenceEquipment });
  Equipment.belongsToMany(Scence, { through: ScenceEquipment });
  User.hasOne(Actor);
  User.hasMany(Token);
  Scence.hasMany(Character);

  Actor.belongsToMany(Character, { through: ActorCharactor });
  Character.belongsToMany(Actor, { through: ActorCharactor });

  await User.sync();
  await Scence.sync();
  await Actor.sync();
  await Character.sync();
  await Equipment.sync();
  await Token.sync();
  await ActorCharactor.sync();
  await ScenceEquipment.sync();
};

module.exports = {
  configModel,
  User,
  Token,
  Scence,
  Equipment,
  Character,
  Actor,
};
