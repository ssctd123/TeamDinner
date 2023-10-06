/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('locations/{locationId}')
  .onCreate(async snapshot => {


    const location = snapshot.data();

    const querySnapshot = await db
      .collection('teams')
      .doc(location.team)
      .collection('members')
      .get();

    const userIds = querySnapshot.docs.map(snap => snap.id);

    const querySnapshot = await db
          .collection('users')
          .get();

    const tokens = querySnapshot.docs.map(snap => userIds.includes(snap.deviceId) );

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Location and Time Update!',
        body: `We will meet at ${location.name} at ${location.time}`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });
