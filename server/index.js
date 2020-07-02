const express = require('express');
const dotenv = require('dotenv');
const morgan = require('morgan');
const helmet = require('helmet');

const sequelize = require('./utils/sequilize');
const { configModel } = require('./models');
const bootstraps = require('./models/bootstraps');
const userRoute = require('./routes/user');

dotenv.config();
const { PORT = 5000 } = process.env;

const app = express();

app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

app.use('/me', userRoute);

app.listen(PORT, async () => {
  console.log(`Server Started on ${PORT}`);

  try {
    await sequelize.authenticate();
    // await sequelize.drop();
    configModel();
    // bootstraps();
    // await sequelize.sync({ force: true });
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});
