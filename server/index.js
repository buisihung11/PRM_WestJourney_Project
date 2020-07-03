const express = require('express');
const dotenv = require('dotenv');
const morgan = require('morgan');
const helmet = require('helmet');

const sequelize = require('./utils/sequilize');
const { configModel } = require('./models');
const bootstraps = require('./models/bootstraps');
const userRoute = require('./routes/user');
const authRoute = require('./routes/authen');
const isAuth = require('./middlewares/is-Auth');
const isAuthor = require('./middlewares/is-Author');

dotenv.config();
const { PORT = 5000 } = process.env;

const app = express();

app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

app.use(authRoute);

// Private routes
app.use(isAuth);
app.use('/me', isAuthor('actor'), userRoute);

// Err handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

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
