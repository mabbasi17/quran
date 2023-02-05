const functions = require("firebase-functions");
const admin = require("firebase-admin");
const moment = require("moment");
const momentTZ = require("moment-timezone");
// require("moment/locale/de");
// moment.locale("de");

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

const messaging = admin.messaging();
const firestore = admin.firestore();


const prayerKeys = {
    "Fajr": { "ar": "الفجر", "de": "Fajr", "icon": "sun-middle.svg" },
    "iqama": { "ar": "الإقامة", "de": "Iqama", "icon": "taraweeh-prayer.svg" },
    "Sonnenaufgang": { "ar": "الشروق", "de": "Shuruk", "icon": "sunrise.svg" },
    "Dhuhr": { "ar": "الظهر", "de": "Duhur", "icon": "sun.svg" },
    "Asr": { "ar": "العصر", "de": "Asr", "icon": "cloud-sun.svg" },
    "Maghrib": { "ar": "المغرب", "de": "Maghrib", "icon": "sunset.svg" },
    "Isha": { "ar": "العشاء", "de": "Isha", "icon": "night-time.svg" }
};

const daysKeys = {
    "Mon": { "de": "Montag", "ar": "الاثنين" },
    "Tue": { "de": "Dienstag", "ar": "الثلاثاء" },
    "Wed": { "de": "Mittwoch", "ar": "الأربعاء" },
    "Thu": { "de": "Donnerstag", "ar": "الخميس" },
    "Fri": { "de": "Freitag", "ar": "الجمعة" },
    "Sat": { "de": "Samstag", "ar": "السبت" },
    "Sun": { "de": "Sonntag", "ar": "الأحد" },
};


let prayerTimes = [];
let lessons = [];

function getLessons() {
    functions.logger.log("loading lessons");
    return firestore.collection("content").doc("lessons").get().then((doc) => {
        functions.logger.log("Lessons loaded");
        lessons = doc.data()?.lessonsList;
    });
}
function getPrayers() {
    functions.logger.log("loading prayer times");
    return firestore.collection("content").doc("prayerTimes").get().then((doc) => {
        functions.logger.log("Prayer times loaded");
        prayerTimes = doc.data()?.prayerTimesList;
    });
}

function todaysPrayerTimes(date) {
    let todaysPrayers = prayerTimes[date.dayOfYear() - 1];
    delete todaysPrayers.day;
    delete todaysPrayers.month_id;
    delete todaysPrayers.iqama;
    delete todaysPrayers.Sonnenaufgang;
    return todaysPrayers;
}

function checkPrayerTimesAndSendNotification(currentMoment) {
    Object.entries(todaysPrayerTimes(currentMoment)).sort(([, a], [, b]) => a.localeCompare(b)).forEach(([key, value]) => {
        functions.logger.log(value);
        if (currentMoment.hours() === parseInt(value.split(":")[0]) && currentMoment.minutes() === parseInt(value.split(":")[1])) {
            messaging.send(
                {
                    topic: key,
                    notification: {
                        title: `${prayerKeys[key]["ar"]} ${prayerKeys[key]["de"]}`,
                        body: value
                    }
                }
            ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));

        }
    })
}

function checkLessonsAndSendNotification(currentMoment) {
    lessons.filter((l) => l.hidden != true).forEach((lesson) => {
        if (currentMoment.format('ddd') === lesson.day && (currentMoment.hours() + 2) === parseInt(lesson.time.split(":")[0]) && currentMoment.minutes() === parseInt(lesson.time.split(":")[1])) {
            messaging.send(
                {
                    topic: "lessons",
                    notification: {
                        title: `${lesson.titleAR} ${lesson.titleDE}`,
                        body: lesson.time
                    }
                }
            ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));
        }
    })
}

exports.schedule = functions.pubsub.schedule('* * * * *')
    .onRun(async (context) => {
        const now = momentTZ.tz("Europe/Berlin");
        // functions.logger.log(`scheduled ${now.format('ddd, HH:mm')}`);
        if (!prayerTimes || prayerTimes?.length === 0) await getPrayers();
        if (!lessons || lessons?.length === 0) await getLessons();
        checkPrayerTimesAndSendNotification(now);
        checkLessonsAndSendNotification(now);
        return null;
    });

exports.scheduleAzkarAlSabah = functions.pubsub.schedule('0 7 * * *')
    .timeZone('Europe/Berlin')
    .onRun(async (context) => {
        await messaging.send(
            {
                topic: "azkarAlSabah",
                notification: {
                    title: "Ma'thurat",
                    body: "أذكار الصباح",
                }
            }
        ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));
        return null;
    });

exports.scheduleAzkarAlMasaa = functions.pubsub.schedule('0 19 * * *')
    .timeZone('Europe/Berlin')
    .onRun(async (context) => {
        await messaging.send(
            {
                topic: "azkarAlMasaa",
                notification: {
                    title: "Ma'thurat",
                    body: "أذكار المساء",
                }
            }
        ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));
        return null;
    });

exports.onLivestreamChange = functions.firestore.document('/content/livestream').onWrite(async (snap, context) => {
    const urlAfter = snap.after.data()?.url;
    const urlBefore = snap.before.data()?.url;
    const liveInfo = snap.after.data();
    if (urlAfter != urlBefore && urlAfter != null && urlAfter != "") {
        functions.logger.log("Livestream changed");
        return messaging.send(
            {
                topic: "stayUpToDate",
                notification: {
                    title: liveInfo.title ?? "Live",
                    body: liveInfo.body ?? "بث مباشر",
                    image: liveInfo.image
                }
            }
        ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));
    }
})

exports.onPrayerTimesChange = functions.firestore.document('/content/prayerTimes').onWrite(async (snap, context) => {
    prayerTimes = snap.after.data()["prayerTimesList"];
    functions.logger.log("Prayer times changed");
});

exports.onLessonsChange = functions.firestore.document('/content/lessons').onWrite(async (snap, context) => {
    lessons = snap.after.data()["lessonsList"];
    functions.logger.log("Lessons changed");
})


exports.sendDynamicNotification = functions.firestore.document('/notifications/{notificationId}').onCreate(async (snap, context) => {
    const messageData = snap.data();
    return messaging.send(
        {
            topic: "stayUpToDate",
            notification: {
                title: messageData.title,
                body: messageData.body,
                image: messageData.image
            }
        }
    ).then((res) => functions.logger.log("sent")).catch((e) => functions.logger.log(e));
})