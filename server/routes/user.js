const express = require('express');
const userService = require('../services/userService');

const router = express.Router();

router.get('/scences', async (req, res) => {
  const { filter = 'default' } = req.query;

  // get user Id

  const scenes = await userService.getScenes(filter);
  res.send(scenes);
});

router.post('/tokens', async (req, res) => {
  const { fcmToken } = req.body;
  try {
    const result = userService.saveTokens(fcmToken);
    return res.send({ success: true, result });
  } catch (e) {
    return res.status(500).send({ error: 'Soemthing wrong' });
  }
});

router.get('/scences/:sceneId', async (req, res, next) => {
  const { sceneId } = req.params;
  if (!sceneId) {
    return res.status(400).send();
  }

  const scenceDetail = await userService.getSceneByID(sceneId);
  if (!scenceDetail) return res.status(404).send();
  res.send(scenceDetail);
});

// router.get('/scences/:sceneId/characters', async (req, res, next) => {
//   const { sceneId } = req.params;
//   if (!sceneId) {
//     return res.status(400).send();
//   }
//   const characters = await userService.getCharactersInScence(sceneId);
//   res.send(characters);
// });

module.exports = router;
