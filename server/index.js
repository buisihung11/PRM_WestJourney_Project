const express = require('express');
const dotenv = require('dotenv');
const sequelize = require('./utils/sequilize');
const { configModel } = require('./models');

dotenv.config();
const app = express();

const { PORT = 5000 } = process.env;

app.listen(PORT, async () => {
  console.log(`Server Started on ${PORT}`);

  try {
    await sequelize.authenticate();
    // await sequelize.drop();
    configModel();
    // await sequelize.sync({ force: true });
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});
