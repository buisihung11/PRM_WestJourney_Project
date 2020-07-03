const { DataTypes } = require('sequelize');
const { hashSync } = require('bcryptjs');
const sequelize = require('../utils/sequilize');

const Actor = sequelize.define(
  'Actor',
  {
    // attributes

    description: DataTypes.STRING,
    imageURL: DataTypes.STRING,
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
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    gender: {
      type: DataTypes.STRING,
      validate: {
        isIn: {
          args: [['male', 'female', 'others']],
          msg: 'Gender must be one of male, female or others',
        },
      },
    },
    phone: DataTypes.STRING,
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
  {
    freezeTableName: true,
    indexes: [{ unique: true, fields: ['username'] }],
  },
);

const ActorCharactor = sequelize.define(
  'ActorCharactor',
  {},
  {
    freezeTableName: true,
    hooks: {
      afterCreate: (actorCharactor, options) => {
        console.log('After Create actorCharactor', actorCharactor, options);
      },
      afterUpdate: (actorCharactor, options) => {
        console.log('After Update actorCharactor', actorCharactor, options);
      },
    },
  },
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
  Actor.belongsTo(User);

  User.hasMany(Token);
  Token.belongsTo(User);

  Scence.hasMany(Character);
  Character.belongsTo(Scence);

  Actor.belongsToMany(Character, { through: ActorCharactor });
  Character.belongsToMany(Actor, { through: ActorCharactor });

  await sequelize.sync();

  // await User.sync({ force: true });
  // await Scence.sync({ force: true });
  // await Actor.sync({ force: true });
  // await Character.sync({ force: true });
  // await Equipment.sync({ force: true });
  // await Token.sync({ force: true });
  // await ActorCharactor.sync({ force: true });
  // await ScenceEquipment.sync({ force: true });
};

module.exports = {
  configModel,
  User,
  Token,
  Scence,
  Equipment,
  Character,
  Actor,
  ActorCharactor,
};
