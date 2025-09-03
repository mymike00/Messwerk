#include <QDebug>
#include <QDateTime>

#include "settings.h"
#include "wakelock.h"

#include "sensor.h"


unsigned Sensor::sensorTypeToWakeLockPart(Sensor::Type type)
{
    switch(type) {
        case Accelerometer: return WakeLock::PART_ACCELEROMETER;
        case Gyroscope:     return WakeLock::PART_GYROSCOPE;
        case Magnetometer:  return WakeLock::PART_MAGNETOMETER;
        case PressureSensor:return WakeLock::PART_PRESSURESENSOR;
        case Rotation:      return WakeLock::PART_ROTATION;
        case Light:         return WakeLock::PART_LIGHT;
        case Proximity:     return WakeLock::PART_PROXIMITY;
        default:            return 0;
    }
}

Sensor::Sensor(Sensor::Type type, QObject *parent) :
    QObject(parent), m_sensor(NULL), m_type(type)
{
}


void Sensor::activate(unsigned requestingPart)
{
    Activateable::activate(requestingPart);

    Q_ASSERT(m_sensor);

    if(!m_sensor->isActive()) {
        qDebug() << "Sensor started";
        m_sensor->setAlwaysOn(true);
        m_sensor->setDataRate(200);
        m_sensor->start();
        qDebug() << "Sensor rates" << m_sensor->availableDataRates();
        qDebug() << "Sensor current rate" << m_sensor->dataRate();
    }

    if(requestingPart == PART_PAGE) {
        WakeLock::instance().activateScreenLock(sensorTypeToWakeLockPart(m_type));
    }

    if(requestingPart == PART_LOGGING) {
        WakeLock::instance().activateBackground(sensorTypeToWakeLockPart(m_type));
    }
}

void Sensor::deactivate(unsigned requestingPart)
{
    Q_ASSERT(m_sensor);

    Activateable::deactivate(requestingPart);

    // stop the sensor if all parts are deactivated
    if(!(this->isActive()) && m_sensor->isActive()) {
        qDebug() << "Sensor stopped";
        m_sensor->stop();
    }

    if(requestingPart == PART_PAGE) {
        WakeLock::instance().deactivateScreenLock(sensorTypeToWakeLockPart(m_type));
    }

    if(requestingPart == PART_LOGGING) {
        WakeLock::instance().deactivateBackground(sensorTypeToWakeLockPart(m_type));
    }
}

void Sensor::startLogging()
{
    QDateTime now = QDateTime::currentDateTime();

    auto extension = m_type == Sensor::Gyroscope ? ".gcsv" : ".csv";
    QString fileName = m_logBaseName + "_" + now.toString("yyyyMMdd-hhmmss") + extension;
    QString absPath = QDir(Settings::instance().getLoggingPath()).filePath(fileName);

    qDebug() << "Starting to log at" << absPath;

    m_logFile.setFileName(absPath);
    m_logFile.open(QFile::WriteOnly);
    if (m_type == Sensor::Gyroscope) {
        QTextStream out(&m_logFile);
        out << "GYROFLOW IMU LOG" << "\n";
        out << "version,1.3" << "\n";
        out << "id,messwerk" << "\n";
        out << "orientation,XYZ" << "\n";
        out << "timestamp," << now.toSecsSinceEpoch() << "\n";
        out << "vendor,Vollaphone" << "\n";
        out << "tscale,0.000001" << "\n";
        out << "gscale,0.00001745329" << "\n";
        out << "ascale,0.00981" << "\n";
        out << "t,gx,gy,gz,ax,ay,az,mx,my,mz" << "\n";
    }

    activate(Activateable::PART_LOGGING);

    emit isLoggingChanged(true);
}

void Sensor::stopLogging()
{
    deactivate(Activateable::PART_LOGGING);

    m_logFile.close();

    emit isLoggingChanged(false);
}

bool Sensor::isLogging()
{
    return isPartActive(Activateable::PART_LOGGING);
}

void Sensor::toggleLogging()
{
    if (isLogging())
        stopLogging();
    else
        startLogging();
}

SensorBridge::SensorBridge(Sensor *sensor, QObject* parent) :
    QObject(parent), m_sensor(sensor)
{
    QObject::connect(this, SIGNAL(activateSignal(uint)), m_sensor, SLOT(activate(uint)));
    QObject::connect(this, SIGNAL(deactivateSignal(uint)), m_sensor, SLOT(deactivate(uint)));

    QObject::connect(this, SIGNAL(startLoggingSignal()), m_sensor, SLOT(startLogging()));
    QObject::connect(this, SIGNAL(stopLoggingSignal()), m_sensor, SLOT(stopLogging()));
//    QObject::connect(this, SIGNAL(askIsLogging()), m_sensor, SLOT(stopLogging()));
    QObject::connect(this, SIGNAL(toggleLoggingSignal()), m_sensor, SLOT(toggleLogging()));
}

void SensorBridge::activate(unsigned int requestingPart)
{
    emit activateSignal(requestingPart);
}

void SensorBridge::deactivate(unsigned int requestingPart)
{
    emit deactivateSignal(requestingPart);
}

void SensorBridge::startLogging()
{
    emit startLoggingSignal();
}

void SensorBridge::stopLogging()
{
    emit stopLoggingSignal();
}

//bool SensorBridge::isLogging()
//{
//    emit askIsLogging();
//}

void SensorBridge::toggleLogging()
{
    emit toggleLoggingSignal();
}
