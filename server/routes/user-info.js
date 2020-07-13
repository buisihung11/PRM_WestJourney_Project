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

module.exports = router;
