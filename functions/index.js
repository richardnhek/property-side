/* eslint-disable eol-last */
/* eslint-disable no-undef */
/* eslint-disable no-trailing-spaces */
/* eslint-disable max-len */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const functions = require("firebase-functions");
const {StreamChat} = require("stream-chat");

// const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const serverClient = StreamChat.getInstance(functions.config().stream.app_id, functions.config().stream.secret);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.generateStreamChatToken = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("failed-precondition", "The function must be called while authenticated.");
  }
  
  try {
    const uid = data.uid;
    // Ensure the UID is provided
    if (!uid) {
      throw new functions.https.HttpsError("invalid-argument", "The function must be called with one arguments \"uid\".");
    }
    // Generate a token for the user
    const token = serverClient.createToken(uid);
    // Return the token
    return {token};
  } catch (error) {
    logger.error("Error generating Stream Chat token:", error);
    throw new functions.https.HttpsError("unknown", "An error occurred while generating the Stream Chat token.");
  }
});