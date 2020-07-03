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
    const {
      name,
      description,
      filmingAddress,
      filmingStartDate,
      filmingEndDate,
      setQuantity,
    } = req.body;

    try {
      const createdScence = await adminService.createScences({
        name,
        description,
        filmingAddress,
        filmingStartDate,
        filmingEndDate,
        setQuantity,
      });

      return res.status(201).send(createdScence);
    } catch (e) {
      return res.status(400).send({ error: e.message });
    }
  });

router
  .route('/scences/:scenceId')
  .get(async (req, res) => {
    const { scenceId } = req.params;
    const scenceDetail = await adminService.getScenceById(scenceId);

    if (!scenceDetail) return res.status(404).send();
    return res.send(scenceDetail);
  })
  .put(async (req, res) => {
    const { scenceId } = req.params;
    const {
      name,
      description,
      filmingAddress,
      filmingStartDate,
      filmingEndDate,
      setQuantity,
    } = req.body;

    try {
      const updateResult = await adminService.updateScenceById(scenceId, {
        name,
        description,
        filmingAddress,
        filmingStartDate,
        filmingEndDate,
        setQuantity,
      });
      return res.send(updateResult);
    } catch (err) {
      return res.status(404).send({ error: err.message });
    }
  })
  .delete(async (req, res) => {
    const { scenceId } = req.params;
    try {
      const deleteResult = await adminService.deleteScenceById(scenceId);
      console.log('deleteResult', deleteResult);
      return res.send({ success: deleteResult === 1 });
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

module.exports = router;
