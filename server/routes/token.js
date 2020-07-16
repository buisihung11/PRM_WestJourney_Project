const express = require('express');
const userService = require('../services/userService');
const notificationService = require('../services/notificationService');

const router = express.Router();

router.post('/tokens', async (req, res) => {
  const { fcmToken } = req.body;
  try {
    const result = await userService.saveTokens(fcmToken);
    return res.send({ success: true, result });
  } catch (e) {
    return res.status(500).send({ error: 'Soemthing wrong' });
  }
});

router.get('/actor-push', async (req, res) => {
  const { actorId } = req.user;
  try {
    const result = await notificationService.sendNotificationToActor({
      actorId,
      title: 'Ban da nhan duoc vai dien moi',
      content: 'Thong bao moi',
    });
    return res.send({ result });
  } catch (err) {
    return res.status(500).send({ error: err });
  }
});

router.get('/testpush', async (req, res) => {
  const { userId } = req.user;
  try {
    const result = await notificationService.sendNotificationToUser({
      userId,
      title: 'Test notification',
      content: 'Thong bao moi',
    });
    return res.send({ result });
  } catch (err) {
    return res.status(500).send({ error: err });
  }
});

module.exports = router;
