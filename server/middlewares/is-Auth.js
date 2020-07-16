const jwt = require('jsonwebtoken');

const userService = require('../services/userService');
const notificationService = require('../services/notificationService');

const isAuth = async (req, res, next) => {
  const authHeader = req.get('Authorization');
  console.log('CheckAuth', authHeader);
  if (!authHeader) {
    return res.status(401).send();
  }
  const token = authHeader.split(' ')[1]; //the struture is "Bearier yourtoken"
  if (!token || token === '') {
    return res.status(401).send();
  }
  let decodedToken;
  try {
    decodedToken = jwt.verify(token, process.env.KEY_TOKEN);
  } catch (err) {
    return res.status(401).send();
  }
  if (!decodedToken) {
    return res.status(401).send();
  }
  //   if (Date.now() >= decodedToken.exp * 1000) {
  //     return false;
  //   }

  req.isAuth = true;
  req.user = decodedToken;
  // eslint-disable-next-line global-require

  userService.setUser(decodedToken);
  notificationService.setUser(decodedToken);
  next();
};

module.exports = isAuth;
