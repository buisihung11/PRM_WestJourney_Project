const express = require('express');
const bcrtpy = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { User, Actor } = require('../models');
const isAuth = require('../middlewares/is-Auth');
const userService = require('../services/userService');

const router = express.Router();

router.post('/login', async (req, res, next) => {
  const { username, password } = req.body;
  const user = await User.findOne({
    where: {
      username,
      isDeleted: false,
    },
  });
  if (!user) {
    return res.send({ success: false, error: 'Not signup!' });
  }

  const isEqual = await bcrtpy.compare(password, user.password);
  if (!isEqual) {
    return res.send({ success: false, error: 'Invalid username or password' });
  }

  const actor = await Actor.findOne({
    where: {
      UserId: user.id,
    },
  });

  const token = await jwt.sign(
    {
      username: user.username,
      userId: user.id,
      role: user.role,
      actorId: actor.id,
    },
    process.env.KEY_TOKEN,
    { expiresIn: '2days' },
  );

  // return jwt token
  res.send({
    success: true,
    data: {
      token,
      userId: user.id,
      role: user.role,
      name: user.name,
      imageURL: actor.imageURL,
    },
  });
});

module.exports = router;
