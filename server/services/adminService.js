/* eslint-disable nonblock-statement-body-position */
/* eslint-disable no-lonely-if */
/* eslint-disable no-restricted-syntax */
/* eslint-disable no-useless-catch */
/* eslint-disable class-methods-use-this */
const { Op } = require('sequelize');
const {
  Scence,
  Character,
  Actor,
  ActorCharactor,
  Equipment,
  User,
  ScenceEquipment,
} = require('../models/index');
const sequelize = require('../utils/sequilize');

class AdminService {
  setUser(user) {
    this.user = user;
  }

  async getAllScences() {
    const scences = await Scence.findAll({
      where: {
        isDeleted: false,
      },
    });

    return scences;
  }

  async getScenceById(id) {
    try {
      const scenceDetail = await Scence.findOne({
        where: {
          id,
          isDeleted: false,
        },
        include: [
          {
            required: false,
            model: Character,
            where: {
              isDeleted: false,
            },
            include: [
              {
                model: Actor,
                include: [
                  {
                    model: User,
                    // through: {
                    //   attributes: ['name', 'username', 'role', 'gender'],
                    // },
                  },
                ],
                through: {
                  attributes: [],
                },
              },
            ],
          },
          {
            required: false,
            model: Equipment,
            where: {
              status: 'available',
              isDeleted: false,
            },
            through: {
              attributes: ['quantity'],
            },
          },
        ],
      });
      if (!scenceDetail) throw Error('Not found that tribulation');
      const equipment = scenceDetail.get({ plain: true }).Equipment;

      const normalizedEquipmets = equipment.map((equipmentItem) => ({
        ...equipmentItem,
        quantity: equipmentItem.ScenceEquipment.quantity,
      }));

      const normalizeScenceDetail = {
        ...scenceDetail.get({ plain: true }),
        Equipment: normalizedEquipmets,
      };
      return normalizeScenceDetail;
    } catch (e) {
      console.log(e);
      throw e;
    }
  }

  async updateScence({
    id: scenceId,
    tribulation,
    characters = [],
    equipments = [],
  }) {
    // check required input
    if (!scenceId || !tribulation) {
      throw new Error('Invalid Input');
    }

    const scence = await Scence.findOne({
      where: {
        id: scenceId,
        isDeleted: false,
      },
      include: [
        {
          model: Equipment,
        },
        {
          model: Character,
        },
      ],
    });

    if (!scence) throw new Error('Not found that actor!');

    try {
      const result = await sequelize.transaction(async (t) => {
        // S1. update equipments
        const updatedScence = await scence.update({
          name: tribulation.name,
          description: tribulation.description,
          filmingAddress: tribulation.filmingAddress,
          filmingStartDate: tribulation.filmingStartDate,
          filmingEndDate: tribulation.filmingEndDate,
          setQuantity: tribulation.setQuantity,
        });

        // check has Error
        let hasError = false;
        if (equipments && Array.isArray(equipments)) {
          for await (const equipmentItem of equipments) {
            const { id: equipmentId, quantity: updateQuantity } = equipmentItem;
            const equipment = await Equipment.findOne({
              where: {
                id: equipmentId,
              },
            });
            if (!equipment) {
              hasError = true;
              throw Error(`Not found equipment ${equipmentId}`);
            }
            // check if that equipment is was added before
            const addedEquipment = await ScenceEquipment.findOne({
              where: { EquipmentId: equipmentId, ScenceId: scence.id },
            });
            const isNew = addedEquipment === null;
            let enoughQuantity = false;
            if (isNew) {
              enoughQuantity = equipment.quantity >= updateQuantity;
            } else {
              enoughQuantity =
                equipment.quantity + addedEquipment.quantity >= updateQuantity;
            }
            if (!enoughQuantity) {
              hasError = true;
              throw Error("Don't have enough quantity");
            }
            if (isNew) {
              await equipment.decrement({
                quantity: updateQuantity,
              });
              await ScenceEquipment.create({
                ScenceId: scence.id,
                EquipmentId: equipmentId,
                quantity: updateQuantity,
              });
            } else {
              // await equipment.increment({
              //   quantity: addedEquipment.quantity,
              // });
              await equipment.decrement({
                quantity: updateQuantity - addedEquipment.quantity,
              });
              await addedEquipment.destroy();
              await ScenceEquipment.create({
                ScenceId: scence.id,
                EquipmentId: equipmentId,
                quantity: updateQuantity,
              });
            }
          }
        }
        if (hasError) throw Error('Error when update equipment');
        // delete all equipment that not in update request
        const deleteEquipments = await ScenceEquipment.findAll({
          where: {
            EquipmentId: {
              [Op.notIn]: equipments.map((e) => e.id),
            },
          },
        });

        deleteEquipments.forEach(async (deleteEquipment) => {
          const equipment = await Equipment.findOne({
            where: {
              id: deleteEquipment.EquipmentId,
            },
          });

          await equipment.increment({
            quantity: deleteEquipment.quantity,
          });

          await deleteEquipment.destroy();
        });

        // update characters
        // neu khong co id => them moi

        // tim nhung character cua scence Id nay ma khong nam trong character
        const deleteCharacters = await Character.findAll({
          where: {
            isDeleted: false,
            id: {
              [Op.notIn]: characters.map(({ id }) => id).filter((e) => !!e),
            },
          },
          include: [
            {
              model: Scence,
              where: {
                id: scenceId,
              },
            },
          ],
        });

        for await (const deleteCharacter of deleteCharacters) {
          await ActorCharactor.destroy({
            where: {
              CharacterId: deleteCharacter.id,
            },
            individualHooks: true,
          });
          await deleteCharacter.update({
            isDeleted: true,
          });
        }

        if (characters && Array.isArray(characters)) {
          for await (const characterItem of characters) {
            const {
              id: characterId,
              name,
              descriptionFileURL,
              actors,
            } = characterItem;
            const isNewCharacter = characterId == null;
            if (isNewCharacter) {
              const actorArr =
                actors && Array.isArray(actors) ? actors : JSON.parse(actors);
              if (actorArr && Array.isArray(actorArr)) {
                // check if has that actor
                for await (const actorId of actorArr) {
                  const actor = await Actor.findByPk(actorId);
                  if (!actor) throw Error(`Not found actor ${actorId}`);
                }
              }
              const addedCharacter = await Character.create({
                name,
                descriptionFileURL,
                ScenceId: scenceId,
              });
              if (actorArr && Array.isArray(actorArr)) {
                await ActorCharactor.bulkCreate(
                  actorArr.map((actorId) => ({
                    ActorId: actorId,
                    CharacterId: addedCharacter.id,
                  })),
                  {
                    individualHooks: true,
                  },
                );
              }
            } else {
              let actorArr =
                actors && Array.isArray(actors) ? actors : JSON.parse(actors);
              const updatedCharacter = await Character.findByPk(characterId);
              if (!updatedCharacter) {
                throw Error(`Cannot find character ${characterId}`);
              }

              await updatedCharacter.update({
                name,
                descriptionFileURL,
              });

              if (actorArr && Array.isArray(actorArr)) {
                for await (const actorId of actorArr) {
                  const actor = await ActorCharactor.findOne({
                    where: {
                      ActorId: actorId,
                      CharacterId: characterId,
                    },
                  });
                  if (!actor) {
                    await ActorCharactor.create({
                      ActorId: actorId,
                      CharacterId: characterId,
                    });
                  }
                }
              }
              // destroy actor not in updated Actor
              const destroysResult = await ActorCharactor.destroy({
                where: {
                  CharacterId: characterId,
                  ActorId: {
                    [Op.notIn]: actorArr || [],
                  },
                },
                individualHooks: true,
              });
              console.log('destroysResult', destroysResult);
            }
          }
        }

        return updatedScence;
      });
      return result;
    } catch (error) {
      console.log('error', error);
      console.log(error.message);
      throw error;
    }
  }

  // #region Actor
  async getActors() {
    const actors = await Actor.findAll({
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
    const nomarlizeActorList = actors.map((actor) => {
      // console.log('actor', actor);
      // console.log('actor.User', actor.User);
      return {
        id: actor.id,
        description: actor.description,
        imageURL: actor.imageURL,
        username: actor.User.username,
        gender: actor.User.gender,
        phone: actor.User.phone,
        name: actor.User.name,
        createdAt: actor.createdAt,
        updatedAt: actor.updatedAt,
      };
    });

    return nomarlizeActorList;
  }

  async createActor({
    username,
    password,
    description,
    imageURL,
    gender,
    phone,
    name,
  }) {
    // check required input
    if (!username || !password || !name || !gender)
      throw new Error('Invalid Input');

    // check whether has user with that email
    const user = await User.findOne({
      where: { username },
    });

    if (user) throw new Error('That email is already taken!');

    try {
      const result = await sequelize.transaction(async (t) => {
        const createdUser = await User.create({
          role: 'actor',
          username,
          password,
          gender,
          phone,
          name,
        });
        if (!createdUser) {
          throw new Error('Error when creating user');
        }

        const createdActor = await Actor.create({
          description,
          imageURL,
          UserId: createdUser.id,
        });

        return {
          id: createdActor.id,
          username: createdUser.username,
          description: createdActor.description,
          imageURL: createdActor.imageURL,
          gender: createdUser.gender,
          phone: createdUser.phone,
          name: createdUser.name,
        };
      });

      // If the execution reaches this line, the transaction has been committed successfully
      // `result` is whatever was returned from the transaction callback (the `user`, in this case)
      return result;
    } catch (error) {
      // If the execution reaches this line, an error occurred.
      // The transaction has already been rolled back automatically by Sequelize!
      throw error;
    }
  }

  async updateActor({
    id,
    password,
    description,
    imageURL,
    gender,
    phone,
    name,
  }) {
    // check required input
    if (!id || !password || !name || !gender) {
      throw new Error('Invalid Input');
    }

    // check whether has user with that email
    const actor = await Actor.findOne({
      where: {
        id,
      },
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

    if (!actor) throw new Error('Not found that actor!');

    try {
      const result = await sequelize.transaction(async (t) => {
        const user = await User.findOne({
          where: {
            id: actor.User.id,
          },
        });
        if (!actor) {
          throw new Error('Not found that actor!');
        }
        const updatedUser = await user.update({
          password,
          gender,
          phone,
          name,
        });
        if (!updatedUser) {
          throw new Error('Error when update user');
        }

        const updatedActor = await actor.update({
          description,
          imageURL,
        });

        return {
          id: updatedActor.id,
          username: updatedUser.username,
          description: updatedActor.description,
          imageURL: updatedActor.imageURL,
          gender: updatedUser.gender,
          phone: updatedUser.phone,
          name: updatedUser.name,
        };
      });

      // If the execution reaches this line, the transaction has been committed successfully
      // `result` is whatever was returned from the transaction callback (the `user`, in this case)
      return result;
    } catch (error) {
      // If the execution reaches this line, an error occurred.
      // The transaction has already been rolled back automatically by Sequelize!
      throw error;
    }
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

  async createEquipment({ name, description, imageURL, status, quantity }) {
    // check required input
    if (!quantity || !status || !name) throw new Error('Invalid Input');

    try {
      const createdEquipemnt = await Equipment.create({
        name,
        description,
        imageURL,
        status,
        quantity,
      });
      return createdEquipemnt;
    } catch (error) {
      // If the execution reaches this line, an error occurred.
      // The transaction has already been rolled back automatically by Sequelize!
      throw error;
    }
  }

  async updateEquipment({ id, name, description, imageURL, status, quantity }) {
    // check required input
    if (!quantity || !status || !name || !id) throw new Error('Invalid Input');

    try {
      const equipment = await Equipment.findOne({
        where: {
          id,
          isDeleted: false,
        },
      });
      if (!equipment) throw new Error('Cannot found that equipment');

      const updatedEquipemnt = await equipment.update({
        name,
        description,
        imageURL,
        status,
        quantity,
      });

      return updatedEquipemnt;
    } catch (error) {
      // If the execution reaches this line, an error occurred.
      // The transaction has already been rolled back automatically by Sequelize!
      throw error;
    }
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

  async createScences({ tribulation, characters = [], equipments = [] }) {
    if (
      !(
        tribulation ||
        tribulation.name ||
        tribulation.filmingStartDate ||
        tribulation.filmingEndDate ||
        tribulation.setQuantity
      )
    ) {
      throw new Error('Not valid input');
    }

    const {
      name,
      description,
      filmingAddress,
      filmingStartDate,
      filmingEndDate,
      setQuantity,
    } = tribulation;
    try {
      const result = sequelize.transaction(async (t) => {
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

        // create equipmets with that scence
        if (equipments && Array.isArray(equipments)) {
          for await (const equipmentItem of equipments) {
            const { id: equipmentId, quantity: createQuantity } = equipmentItem;
            const equipment = await Equipment.findOne({
              where: {
                id: equipmentId,
              },
            });
            if (!equipment) {
              throw Error(`Not found equipment ${equipmentId}`);
            }

            let enoughQuantity = false;
            enoughQuantity = equipment.quantity >= createQuantity;

            if (!enoughQuantity) {
              throw Error("Don't have enough quantity");
            }
            await equipment.decrement({
              quantity: createQuantity,
            });
            await ScenceEquipment.create({
              ScenceId: createdScence.id,
              EquipmentId: equipmentId,
              quantity: createQuantity,
            });
          }
        }

        // create characters
        if (characters && Array.isArray(characters)) {
          for await (const characterItem of characters) {
            const {
              name: characterName,
              descriptionFileURL,
              actors,
            } = characterItem;

            console.log(
              'actors && Array.isArray(actors)',
              actors && Array.isArray(actors),
            );
            console.log('actors && Array.isArray(actors)', JSON.parse(actors));
            const actorArr =
              actors && Array.isArray(actors) ? actors : JSON.parse(actors);
            if (actorArr && Array.isArray(actorArr)) {
              // check if has that actor
              for await (const actorId of actorArr) {
                const actor = await Actor.findByPk(actorId);
                if (!actor) throw Error(`Not found actor ${actorId}`);
              }
            }
            const addedCharacter = await Character.create({
              name: characterName,
              descriptionFileURL,
              ScenceId: createdScence.id,
            });
            if (actorArr && Array.isArray(actorArr)) {
              await ActorCharactor.bulkCreate(
                actorArr.map((actorId) => ({
                  ActorId: actorId,
                  CharacterId: addedCharacter.id,
                })),
                {
                  individualHooks: true,
                },
              );
            }
          }
        }

        return createdScence;
      });
      return result;
    } catch (error) {
      throw error;
    }
  }

  async deleteScenceById(scenceId) {
    const scence = await Scence.findOne({
      where: {
        id: scenceId,
        isDeleted: false,
      },
    });
    if (!scence) throw new Error('Not founded that scence');
    try {
      const result = await sequelize.transaction(async (t) => {
        // delete all equipment

        const deleteEquipments = await ScenceEquipment.findAll({
          where: {
            ScenceId: scence.id,
          },
        });

        deleteEquipments.forEach(async (deleteEquipment) => {
          const equipment = await Equipment.findOne({
            where: {
              id: deleteEquipment.EquipmentId,
            },
          });

          await equipment.increment({
            quantity: deleteEquipment.quantity,
          });

          await deleteEquipment.destroy();
        });

        // destroy ActorCharactor
        const deleteCharacters = await Character.findAll({
          where: {
            isDeleted: false,
          },
          include: [
            {
              model: Scence,
              where: {
                id: scenceId,
              },
            },
          ],
        });

        console.log('deleteCharacters', deleteCharacters);

        for await (const deleteCharacter of deleteCharacters) {
          await ActorCharactor.destroy({
            where: {
              CharacterId: deleteCharacter.id,
            },
            individualHooks: true,
          });
          await deleteCharacter.update({
            isDeleted: true,
          });
        }

        const updateResult = await scence.update({
          isDeleted: true,
        });
        return updateResult;
      });

      return result;
    } catch (e) {
      throw e;
    }
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
