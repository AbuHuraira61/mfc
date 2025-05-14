const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Maximum number of retries for sending notifications
const MAX_RETRIES = 3;

exports.sendNotification = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
        const notification = snap.data();
        
        const message = {
            token: notification.token,
            notification: {
                title: notification.title,
                body: notification.body
            },
            data: {
                orderId: notification.orderId,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                timestamp: notification.timestamp ? notification.timestamp.toDate().toISOString() : new Date().toISOString(),
                priority: notification.priority || 'high',
                type: notification.type || 'order_update'
            },
            android: {
                priority: 'high',
                notification: {
                    channelId: 'high_importance_channel',
                    priority: 'high',
                    defaultSound: true,
                    defaultVibrateTimings: true,
                    defaultLightSettings: true,
                    icon: '@mipmap/ic_launcher',
                    color: '#570101'
                }
            },
            apns: {
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                        contentAvailable: true,
                        mutableContent: true
                    }
                },
                headers: {
                    'apns-priority': '10'
                }
            }
        };

        let retryCount = 0;
        let success = false;

        while (retryCount < MAX_RETRIES && !success) {
            try {
                await admin.messaging().send(message);
                console.log('Successfully sent notification:', notification);
                success = true;
                
                // Delete the notification document after successful sending
                await snap.ref.delete();
            } catch (error) {
                retryCount++;
                console.error(`Error sending notification (attempt ${retryCount}/${MAX_RETRIES}):`, error);

                // Check if the error is due to an invalid token
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                    console.log('Invalid token detected, removing notification document');
                    await snap.ref.delete();
                    break;
                }

                // If we've reached max retries, update the document with error info
                if (retryCount === MAX_RETRIES) {
                    await snap.ref.update({
                        error: error.message,
                        errorCode: error.code,
                        lastAttempt: admin.firestore.FieldValue.serverTimestamp()
                    });
                } else {
                    // Wait before retrying (exponential backoff)
                    await new Promise(resolve => setTimeout(resolve, Math.pow(2, retryCount) * 1000));
                }
            }
        }
    }); 