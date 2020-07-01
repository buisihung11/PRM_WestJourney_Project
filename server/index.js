const express = require('express');
const dotenv = require('dotenv');
const sequelize = require('./utils/sequilize');
const User = require('./models/actor');

dotenv.config();
const app = express();

const { PORT } = process.env;

app.listen(PORT, async () => {
  console.log(`Server Started on ${PORT}`);

  try {
    await sequelize.authenticate();
    await sequelize.sync({ force: false });
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});
