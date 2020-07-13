/* eslint-disable class-methods-use-this */
const {
  Scence,
  Character,
  Actor,
  ActorCharactor,
  Equipment,
  User,
} = require('../models/index');

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

  // #region Actor
  async getActors() {
    const actor = await Actor.findAll({
      include: [
        {
          required: true,
          model: User,
          where: {
            isDeleted: false,
          },
        },
      ],
    });

    return actor;
  }

  async deleteActor(actorId) {
    const actor = await Actor.findByPk(actorId);
    if (!actor) throw new Error('Not found that actor');
    const user = await User.findOne({
      where: {
        id: actor.UserId,
      },
    });
    console.log('Deleted: ', user.id);

    const deletedUser = await user.update({
      isDeleted: true,
    });
    return actor.id;
  }

  // #endregion

  // #region Equipment

  async getEquipments({ status, fromDate, toDate }) {
    const where = {
      isDeleted: false,
    };
    if (status) {
      if (status.toLowerCase() !== 'all') where.status = status;
      // where.
    }
    return Equipment.findAll({ where });
  }

  async deleteEquipment(equipmentId) {
    const equipment = await Equipment.findByPk(equipmentId);
    if (!equipment) throw new Error('Not found that equipment');

    const deletedEquipment = await equipment.update({
      isDeleted: true,
    });
    return deletedEquipment.id;
  }

  // #endregion

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
