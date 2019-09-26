#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QObject>
#include <QString>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QTimer>
#include <QGeoSatelliteInfoSource>
#include <QQmlApplicationEngine>

#include "src/accelerometer.h"
#include "src/gyroscope.h"
#include "src/magnetometer.h"
#include "src/rotation.h"
#include "src/light.h"
#include "src/pressuresensor.h"
#include "src/proximity.h"
#include "src/satelliteinfo.h"
#include "src/position.h"

#include "src/settings.h"

#include "src/plotwidget.h"
#include "src/satelliteposwidget.h"
#include "src/satellitestrengthwidget.h"


int main(int argc, char *argv[])
{
    int result = 0;

    QString qml = QString("qml/%1.qml").arg("Messwerk");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<PlotWidget>("harbour.messwerk.MesswerkWidgets", 1, 0, "PlotWidget");
    qmlRegisterType<SatellitePosWidget>("harbour.messwerk.MesswerkWidgets", 1, 0, "SatellitePosWidget");
    qmlRegisterType<SatelliteStrengthWidget>("harbour.messwerk.MesswerkWidgets", 1, 0, "SatelliteStrengthWidget");

    QTimer refreshTimer;

    Accelerometer accelerometer(false);
    Gyroscope gyroscope(false);
    Magnetometer magnetometer(false);
    Rotation rotation(false);
    Light light(false);
    PressureSensor pressuresensor(false);
    Proximity proximity(true);
    SatelliteInfo satelliteinfo;
    Position position;

    // connect not self-refreshing sensors to the global timer
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &accelerometer, SLOT(refresh()));
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &pressuresensor, SLOT(refresh()));
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &gyroscope, SLOT(refresh()));
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &magnetometer, SLOT(refresh()));
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &rotation, SLOT(refresh()));
    QObject::connect(&refreshTimer, SIGNAL(timeout()), &light, SLOT(refresh()));

    engine.rootContext()->setContextProperty("accelerometer", &accelerometer);
    engine.rootContext()->setContextProperty("gyroscope", &gyroscope);
    engine.rootContext()->setContextProperty("magnetometer", &magnetometer);
    engine.rootContext()->setContextProperty("rotationsensor", &rotation);
    engine.rootContext()->setContextProperty("lightsensor", &light);
    engine.rootContext()->setContextProperty("pressuresensor", &pressuresensor);
    engine.rootContext()->setContextProperty("proximitysensor", &proximity);
    engine.rootContext()->setContextProperty("satelliteinfo", &satelliteinfo);
    engine.rootContext()->setContextProperty("positionsensor", &position);
    engine.rootContext()->setContextProperty("settings", &(Settings::instance()));
    engine.load(QUrl::fromLocalFile(qml));

    refreshTimer.start(100);

    result = app.exec();

    return result;
}
