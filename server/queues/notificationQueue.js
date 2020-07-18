const Queue = require('bull');
const notificationService = require('../services/notificationService');

const { REDIS_URL = 'redis://127.0.0.1:6379' } = process.env;

const notificationQueue = new Queue('notification', REDIS_URL);
console.log('REDIS_URL', REDIS_URL);
notificationQueue.process(async (job) => {
  const { data } = job;
  console.log('get new job', data);
  const result = await notificationService.sendNotificationToActor(data);
  return result;
});

notificationQueue.on('completed', (job, result) => {
  console.log(`Job completed with result ${result}`);
});

module.exports = notificationQueue;
