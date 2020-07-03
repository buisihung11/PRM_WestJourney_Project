const express = require('express');
const UserService = require('../services/userService');

const router = express.Router();
const service = new UserService();

router.get('/scences', async (req, res) => {
  console.log(req.user);
  const { filter = 'default' } = req.query;

  // get user Id

  const scenes = await service.getScenes(filter);
  res.send(scenes);
});

router.get('/scences/:sceneId', async (req, res, next) => {
  const { sceneId } = req.params;
  if (!sceneId) {
    return res.status(400).send();
  }

  const scenceDetail = await service.getSceneByID(sceneId);
  if (!scenceDetail) return res.status(404).send();
  res.send(scenceDetail);
});

router.get('/scences/:sceneId/characters', async (req, res, next) => {
  const { sceneId } = req.params;
  if (!sceneId) {
    return res.status(400).send();
  }
  const characters = await service.getCharactersInScence(sceneId);
  res.send(characters);
});

module.exports = router;
