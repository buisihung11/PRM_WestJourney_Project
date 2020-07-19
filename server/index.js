const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const morgan = require('morgan');
const helmet = require('helmet');
const redis = require('redis');

// const swaggerUi = require('swagger-ui-express');
// const swaggerDocument = require('./swagger.json');
require('./models');
require('./config/firebase');
const sequelize = require('./utils/sequilize');
const { configModel } = require('./models');
const bootstraps = require('./models/bootstraps');

const userRoute = require('./routes/user');
const authRoute = require('./routes/authen');
const adminRoute = require('./routes/admin');
const userInfoRoute = require('./routes/user-info');
const tokenRoute = require('./routes/token');

const isAuth = require('./middlewares/is-Auth');
const isAuthor = require('./middlewares/is-Author');

dotenv.config();
const { PORT = 5000 } = process.env;

const app = express();

// const redisClient = redis.createClient(REDIS_URL);

// redisClient.set('name', 'Hung Bui', redis.print);
// app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

// app.get('/redis-name', (req, res) => {
//   redisClient.get('name', (err, name) => {
//     return res.send({ name });
//   });
// });
app.get('/ping', (req, res) => res.send('Hello World'));
app.use(authRoute);
// Private routes
app.use(isAuth);
app.use('/me', tokenRoute);
app.use('/me', userInfoRoute);
app.use('/me', isAuthor('actor'), userRoute);

// Admin
app.use(isAuthor('admin'), adminRoute);

// Err handler
app.use((err, req, res, next) => {
  res.status(500).send('Something broke!');
});

app.listen(PORT, async () => {
  console.log(`Server Started on ${PORT}`);

  try {
    await sequelize.authenticate();
    // await sequelize.drop();
    await configModel();
    // await bootstraps();
    // await sequelize.sync({ force: true });
    console.log('Connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
});

module.exports = app;
