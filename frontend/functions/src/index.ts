/**
* Import function triggers from their respective submodules:
*
* import {onCall} from "firebase-functions/v2/https";
* import {onDocumentWritten} from "firebase-functions/v2/firestore";
*
* See a full list of supported triggers at https://firebase.google.com/docs/functions
*/
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('locations/{id}')
  .onCreate(async snapshot => {

      const locations = await db.collection("locations")
          .get();
      const location = locations.docs.filter(snap => snap.id == snapshot.id).map(snap => snap.data())[0];

    const queryTeamsSnapshot = await db.collection('teams')
        .get();
    console.log(location.teamId);
    const foundUserIds = queryTeamsSnapshot.docs.filter(snap => snap.id == location.teamId).map((team) => team.data().members.map((x: any) => x['id']));
    const userIds = foundUserIds[0];
    console.log('userIds');
    console.log(userIds);
    const queryUsersSnapshot = await db
        .collection('users')
        .get();
    const usersWithDeviceIds = queryUsersSnapshot.docs.filter((snap) => snap.data()?.deviceId != null).map(snap => snap.data());
    const tokens = usersWithDeviceIds.filter(user => userIds.includes(user.id)).map(snap => snap.deviceId);
    console.log('usersWithDeviceIds');
    console.log(usersWithDeviceIds);
    console.log('tokens');
    console.log(tokens);
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Location Update!',
        body: `We will meet at ${location.name} at ${location.time}.`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice('cQE3KhcWdkPKjQyFLC0Ta_:APA91bFgw5wV8BX8jSVMarGsRmfTpdf9pepCCT9pTwN0kawq5_RJ3bWVAu8Q7Rn6eHJteshJ7LdLuSRXDSLrgOAeEGzN62DtrKuYH81dWv4WQCD6-I-6gwfn9b2LqvXqK6Wj1NBq09CS', payload);
  });

const test = async function() {
    const locations = await db.collection("locations")
        .get();
    const location = locations.docs.filter(snap => snap.id == '00f74afd-5f4b-423d-93e4-94733332fb40').map(snap => snap.data())[0];
    const queryTeamsSnapshot = await db.collection('teams')
        .get();
    console.log(location.teamId);
    const foundUserIds = queryTeamsSnapshot.docs.filter(snap => snap.id == location.teamId).map((team) => team.data().members.map((x: any) => x['id']));
    const userIds = foundUserIds[0];
    console.log('userIds');
    console.log(userIds);
    const queryUsersSnapshot = await db
        .collection('users')
        .get();
    const usersWithDeviceIds = queryUsersSnapshot.docs.filter((snap) => snap.data()?.deviceId != null).map(snap => snap.data());
    const tokens = usersWithDeviceIds.filter(user => userIds.includes(user.id)).map(snap => snap.deviceId);
    console.log('usersWithDeviceIds');
    console.log(usersWithDeviceIds);
    console.log('tokens');
    console.log(tokens);
    const payload: admin.messaging.MessagingPayload = {
        notification: {
            title: 'Location Update!',
            body: `We will meet at ${location.name} at ${location.time}.`,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };

    return fcm.sendToDevice('cQE3KhcWdkPKjQyFLC0Ta_:APA91bFgw5wV8BX8jSVMarGsRmfTpdf9pepCCT9pTwN0kawq5_RJ3bWVAu8Q7Rn6eHJteshJ7LdLuSRXDSLrgOAeEGzN62DtrKuYH81dWv4WQCD6-I-6gwfn9b2LqvXqK6Wj1NBq09CS', payload);
}
test();