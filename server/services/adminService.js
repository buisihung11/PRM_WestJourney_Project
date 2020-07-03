/* eslint-disable class-methods-use-this */
const { Scence, Character, Actor, ActorCharactor } = require('../models/index');

class AdminService {
  setUser(user) {
    this.user = user;
  }

  async getAllScences() {
    const scences = await Scence.findAll();

    return scences;
  }

  async getScenceById(id) {
    const scenceDetail = await Scence.findByPk(id);
    return scenceDetail;
  }

  // #region CRUD Scence

  async createScences({
    name,
    description,
    filmingAddress,
    filmingStartDate,
    filmingEndDate,
    setQuantity,
  }) {
    if (
      !(
        name ||
        description ||
        filmingAddress ||
        filmingStartDate ||
        filmingEndDate ||
        setQuantity
      )
    ) {
      throw new Error('Not valid input');
    }

    const createdScence = await Scence.create(
      {
        name,
        description,
        filmingAddress,
        filmingStartDate,
        filmingEndDate,
        setQuantity,
      },
      {},
    );

    return createdScence;
  }

  async updateScenceById(
    scenceId,
    {
      name,
      description,
      filmingAddress,
      filmingStartDate,
      filmingEndDate,
      setQuantity,
    },
  ) {
    const scence = await Scence.findByPk(scenceId);
    if (!scence) throw new Error('Not founded that scence');

    const updateResult = await Scence.update(
      {
        name,
        description,
        filmingAddress,
        filmingStartDate,
        filmingEndDate,
        setQuantity,
      },
      {
        where: {
          id: scenceId,
        },
        returning: true,
      },
    );

    return updateResult[1][0];
  }

  async deleteScenceById(scenceId) {
    const scence = await Scence.findByPk(scenceId);
    if (!scence) throw new Error('Not founded that scence');

    const updateResult = await Scence.destroy({
      where: {
        id: scenceId,
      },
    });

    return updateResult;
  }

  // #endregion

  // #region CRUD Scence's Equipment

  // #endregion

  // #region CRUD Scence's Character
  async getCharacterOfScences(scenceId) {
    const { Characters } = await Scence.findByPk(scenceId, {
      include: Character,
    });
    return Characters;
  }

  async createCharacterInScence(
    scenceId,
    { name, descriptionFileURL, actorId },
  ) {
    const createdCharacter = await Character.create({
      name,
      descriptionFileURL,
      ScenceId: scenceId,
    });

    const result = await ActorCharactor.create({
      CharacterId: createdCharacter.id,
      ActorId: actorId,
    });

    return createdCharacter;
  }
  // #endregion
}

const adminService = new AdminService();

module.exports = adminService;
