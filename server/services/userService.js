/* eslint-disable class-methods-use-this */
const { Sequelize } = require('sequelize');
const { Scence, Character } = require('../models/index');

const { Op } = Sequelize;

// TODO: ADD WHERE CONDITION THAT FROM USERID

class UserService {
  async getScenes(filter) {
    const where = {};
    switch (filter) {
      case 'done':
        where.filmingEndDate = {
          [Op.lt]: new Date().toISOString(),
        };
        break;
      case 'not-yet':
        where.filmingStartDate = {
          [Op.gt]: new Date().toISOString(),
        };
        break;
      default:
        break;
    }

    // get user Id
    const scenes = await Scence.findAll({
      where,
    });
    return scenes;
  }

  async getSceneByID(id) {
    const sceneDetail = await Scence.findByPk(id);
    return sceneDetail;
  }

  async getCharactersInScence(scenceId) {
    const characters = await Character.findAll({
      where: {
        scenceId,
      },
    });
    return characters;
  }
}

module.exports = UserService;
