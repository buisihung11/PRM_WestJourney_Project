/* eslint-disable class-methods-use-this */
const { Sequelize } = require('sequelize');
const { Scence, Character, Actor, User, Token } = require('../models/index');

const { Op } = Sequelize;

// TODO: ADD WHERE CONDITION THAT FROM USERID

class UserService {
  setUser(user) {
    this.user = user;
  }

  async logout() {
    const { userId } = this.user;
    const result = await Token.destroy({
      where: { UserId: userId },
    });
    return result;
  }

  async saveTokens(fcmToken) {
    const { userId } = this.user;
    const result = await Token.findOrCreate({
      where: { token: fcmToken, UserId: userId },
    });
    return result[0];
  }

  async getScenes(filter) {
    const { actorId } = this.user;
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

    // C2
    const scenceIds = await Character.findAll({
      attributes: ['ScenceId'],
      include: [
        {
          required: true,
          model: Actor,
          where: {
            id: actorId,
          },
        },
      ],
    }).map(({ ScenceId }) => ScenceId);

    const scences = await Scence.findAll({
      where: {
        id: scenceIds,
        ...where,
        isDeleted: false,
      },
    });

    return scences;
  }

  async getSceneByID(id) {
    const { actorId } = this.user;
    const sceneDetail = await Scence.findOne({
      where: {
        id,
      },
      include: [
        {
          required: true,
          model: Character,
          include: [
            {
              model: Actor,
              require: true,
              where: {
                id: actorId,
              },
            },
          ],
        },
      ],
    });

    return sceneDetail;
  }

  async getCharactersInScence(scenceId) {
    const { actorId } = this.user;

    const scenceDetail = await Scence.findOne({
      where: {
        id: scenceId,
      },
      include: [
        {
          required: true,
          model: Character,
          where: {
            isDeleted: false,
          },
          include: [
            {
              model: Actor,
              require: true,
              through: {
                attributes: [],
              },
              where: {
                id: actorId,
              },
            },
          ],
        },
      ],
    });
    if (!scenceDetail) throw Error('Not found that tribulation');
    const result = scenceDetail.get({ plain: true }).Characters;
    return result;
  }

  async getUserInfo(userId) {
    const user = await User.findOne({
      where: {
        id: userId,
      },
    });
    if (!user) {
      return null;
    }

    const actor = await Actor.findOne({
      where: {
        UserId: user.id,
      },
    });

    if (!actor) return null;
    return {
      userId: user.id,
      role: user.role,
      name: user.name,
      imageURL: actor.imageURL,
    };
  }
}
const userService = new UserService();

module.exports = userService;
