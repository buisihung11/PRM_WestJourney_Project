const isAuthor = (requiredRole) => async (req, res, next) => {
  const {
    user: { role },
  } = req;
  if (!role || requiredRole.toLowerCase() !== role.toLowerCase()) {
    return res.status(403).send();
  }
  next();
};

module.exports = isAuthor;
