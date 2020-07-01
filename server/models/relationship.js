const User = require('./user');
const Actor = require('./actor');
const Token = require('./token');
const Character = require('./character');
const Scence = require('./scence');
const Equipment = require('./equipment');

User.hasOne(Actor);
User.hasMany(Token);

Actor.belongsToMany(Character, { through: 'ActorCharactor' });

Scence.hasMany(Character);
Scence.belongsToMany(Equipment, { through: 'ScenceEquipment' });
