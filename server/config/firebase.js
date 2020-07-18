const admin = require('firebase-admin');

// var serviceAccount = require('path/to/serviceAccountKey.json');

const firebaseApp = admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: 'https://prm-journey-west.firebaseio.com',
});

console.log('Firebase name', firebaseApp.name);

module.exports = firebaseApp;
