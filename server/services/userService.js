/* eslint-disable class-methods-use-this */
const { Sequelize } = require('sequelize');
const { Scence, Character, Actor, User } = require('../models/index');

const { Op } = Sequelize;

// TODO: ADD WHERE CONDITION THAT FROM USERID

class UserService {
  setUser(user) {
    this.user = user;
  }

  async getScenes(filter) {
    console.log('this.user', this.user);
    console.log('filter', filter);
    console.log(new Date().toISOString());
    const { actorId } = this.user;
    let where = {};
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
    // C1
    // const scences = await Scence.findAll({
    //   where,
    //   include: [
    //     {
    //       required: true,
    //       model: Character,
    //       include: [
    //         {
    //           model: Actor,
    //           where: {
    //             id: actorId,
    //           },
    //         },
    //       ],
    //     },
    //   ],
    //   mapToModel: Scence,
    // });

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

    const { Characters } = await Scence.findAll({
      where: {
        id: scenceId,
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

    return Characters;
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
