/* eslint-disable no-unused-vars */
const express = require('express');
const adminService = require('../services/adminService');

const router = express.Router();

router
  .route('/scences')
  .get(async (req, res) => {
    const scences = await adminService.getAllScences();
    return res.send(scences);
  })
  .post(async (req, res) => {
    const { tribulation, characters, equipments } = req.body;
    console.log('tribulation', tribulation);
    console.log('characters', characters);
    console.log('equipments', equipments);
    let charactersEncoded = characters;
    let equipmentsEncoded = equipments;
    try {
      charactersEncoded = JSON.parse(characters);
      equipmentsEncoded = JSON.parse(equipments);
    } catch (err) {
      console.log('parse fail', err);
    }

    try {
      const createdScence = await adminService.createScences({
        tribulation,
        characters: charactersEncoded,
        equipments: equipmentsEncoded,
      });

      return res.status(201).send(createdScence);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

router
  .route('/scences/:scenceId')
  .get(async (req, res) => {
    try {
      const { scenceId } = req.params;
      try {
        // eslint-disable-next-line radix
        parseInt(scenceId);
        if (scenceId == null || scenceId == undefined) throw Error();
      } catch (e) {
        return res.status(400).send({ error: 'Not valid input' });
      }

      const scenceDetail = await adminService.getScenceById(scenceId);

      if (!scenceDetail) return res.status(404).send();
      return res.send(scenceDetail);
    } catch (err) {
      return res.status(400).send({ error: err.message });
    }
  })
  .put(async (req, res) => {
    const { scenceId } = req.params;
    const { tribulation, characters, equipments } = req.body;
    console.log('tribulation', tribulation);
    console.log('characters', characters);
    console.log('equipments', equipments);
    let charactersEncoded = characters;
    let equipmentsEncoded = equipments;
    try {
      charactersEncoded = JSON.parse(characters);
      equipmentsEncoded = JSON.parse(equipments);
    } catch (err) {
      console.log('parse fail', err);
    }
    // charactersEncoded = JSON.parse(charactersEncoded);
    console.log('charactersEncoded', charactersEncoded);
    console.log('equipmentsEncoded', equipmentsEncoded);
    try {
      const updateResult = await adminService.updateScence({
        id: scenceId,
        tribulation,
        characters: charactersEncoded,
        equipments: equipmentsEncoded,
      });

      return res.send(updateResult);
    } catch (err) {
      console.log('Erorr when update scence');
      return res.status(400).send({ error: err.message });
    }
  })
  .delete(async (req, res) => {
    const { scenceId } = req.params;
    try {
      const deleteResult = await adminService.deleteScenceById(scenceId);
      console.log('deleteResult', deleteResult);
      return res.send(deleteResult);
    } catch (err) {
      return res.status(404).send({ error: err.message });
    }
  });

router
  .route('/scences/:scenceId/characters')
  .get(async (req, res) => {
    const { scenceId } = req.params;
    const characters = await adminService.getCharacterOfScences(scenceId);

    return res.send(characters);
  })
  .post(async (req, res) => {
    const { scenceId } = req.params;
    const { name, descriptionFileURL, actorId } = req.body;

    const createdCharacter = await adminService.createCharacterInScence(
      scenceId,
      {
        name,
        descriptionFileURL,
        actorId,
      },
    );

    return res.status(201).send(createdCharacter);
  });

router
  .route('/actors')
  .get(async (req, res) => {
    const actors = await adminService.getActors();
    return res.send(actors);
  })
  .post(async (req, res) => {
    const {
      username,
      password,
      description,
      imageURL,
      gender,
      phone,
      name,
    } = req.body;

    try {
      const createdActor = await adminService.createActor({
        username,
        password,
        description,
        imageURL,
        gender,
        phone,
        name,
      });

      return res.status(201).send(createdActor);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

router
  .route('/actors/:actorId')
  .delete(async (req, res) => {
    const { actorId } = req.params;
    try {
      const deletedActorId = await adminService.deleteActor(actorId);
      return res.status(200).send({ actorId: deletedActorId });
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  })
  .put(async (req, res) => {
    const { actorId } = req.params;
    const { password, description, imageURL, gender, phone, name } = req.body;

    try {
      const updatedActor = await adminService.updateActor({
        id: actorId,
        password,
        description,
        imageURL,
        gender,
        phone,
        name,
      });

      return res.status(204).send(updatedActor);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

router
  .route('/equipments')
  .get(async (req, res) => {
    const {
      status,
      fromDate = new Date().toISOString(),
      toDate = new Date().toISOString(),
    } = req.query;
    const equipments = await adminService.getEquipments({
      status,
      fromDate,
      toDate,
    });
    return res.send(equipments);
  })
  .post(async (req, res) => {
    const { name, description, imageURL, status, quantity } = req.body;

    try {
      const createdEquipment = await adminService.createEquipment({
        name,
        description,
        imageURL,
        status,
        quantity,
      });

      return res.status(201).send(createdEquipment);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

router
  .route('/equipments/:equipmentId')
  .delete(async (req, res) => {
    const { equipmentId } = req.params;
    try {
      const deletedEquipmentId = await adminService.deleteEquipment(
        equipmentId,
      );
      return res.status(200).send({ equipmentId: deletedEquipmentId });
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  })
  .put(async (req, res) => {
    const { equipmentId } = req.params;
    const { name, description, imageURL, status, quantity } = req.body;
    try {
      const updatedEquipment = await adminService.updateEquipment({
        id: equipmentId,
        name,
        description,
        imageURL,
        status,
        quantity,
      });
      return res.status(204).send(updatedEquipment);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

module.exports = router;
