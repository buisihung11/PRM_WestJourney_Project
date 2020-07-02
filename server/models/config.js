/* eslint-disable no-await-in-loop */
/* eslint-disable no-prototype-builtins */
/* eslint-disable no-restricted-syntax */
const User = require('./user');
const Actor = require('./actor');
const Token = require('./token');
const Character = require('./character');
const Scence = require('./scence');
const Equipment = require('./equipment');
const models = require('./index.js');

const setUpModel = async () => {
  for (const modelname in models) {
    if (models.hasOwnProperty(modelname)) {
      await models[modelname].sync({ alter: true });
    }
  }
};
const setUpAssociations = async () => {
  User.hasOne(Actor);
  User.hasMany(Token);

  Actor.belongsToMany(Character, { through: 'ActorCharactor' });
  Character.belongsToMany(Actor, { through: 'ActorCharactor' });

  Scence.hasMany(Character);
  Scence.belongsToMany(Equipment, { through: 'ScenceEquipment' });
  Equipment.belongsToMany(Scence, { through: 'ScenceEquipment' });
};

module.exports = {
  setUpModel,
  setUpAssociations,
};
