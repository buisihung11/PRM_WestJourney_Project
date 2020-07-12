const express = require('express');
const userService = require('../services/userService');

const router = express.Router();

router.get('', async (req, res) => {
  const { user } = req;
  const userInfo = await userService.getUserInfo(user.userId);
  if (userInfo) {
    return res.status(200).send({
      success: true,
      userInfo,
    });
  }
  return res.status(200).send({
    success: false,
    error: 'Not valid userId',
  });
});

router.get('/scences', async (req, res) => {
  const { filter = 'default' } = req.query;

  // get user Id

  const scenes = await userService.getScenes(filter);
  res.send(scenes);
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
