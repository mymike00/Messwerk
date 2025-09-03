#include <QDateTime>

#include <qmath.h>

#include "gyroscope.h"
#include <QElapsedTimer>
#include <QTextStream>
#include <QDebug>
#include <QSensor>

Gyroscope::Gyroscope(bool updateInternally, QObject *parent)
    : Sensor(Sensor::Gyroscope, parent)
{
    m_sensor = new QGyroscope(this);
    m_logBaseName = "gyroscope";
    m_accel = new QAccelerometer(this);
    m_magn = new QMagnetometer(this);

    if(updateInternally) {
        QObject::connect(m_sensor, SIGNAL(readingChanged()), this, SLOT(refresh()));
    }

    QObject::connect(m_sensor, SIGNAL(readingChanged()), this, SLOT(logValues()));
}

Gyroscope::~Gyroscope()
{
}

void Gyroscope::logValues(void)
{
    if(isLogging()) {
//        QElapsedTimer et;
//        et.start();
        QGyroscope *gyroscope = dynamic_cast<QGyroscope*>(m_sensor);
//        auto cast = et.nsecsElapsed();
        QGyroscopeReading *reading = gyroscope->reading();
        auto accReading = m_accel->reading();
        auto magReading = m_magn->reading();

        QTextStream stream(&m_logFile);
        stream << reading->timestamp() << "," << reading->x()*1000.0 << "," << reading->y()*1000.0 << "," << reading->z()*1000.0 << ",";
        stream << accReading->x()*1000.0 << "," << accReading->y()*1000.0 << "," << accReading->z()*1000.0;
        stream << magReading->x()*1000.0 << "," << magReading->y()*1000.0 << "," << magReading->z()*1000.0;
        stream << "\n";
    }
}

void Gyroscope::refresh(void)
{
    if(!m_sensor->isActive()) {
        return;
    }

    QGyroscope *gyroscope = dynamic_cast<QGyroscope*>(m_sensor);
    QGyroscopeReading *reading = gyroscope->reading();

    m_rx = reading->x();
    m_ry = reading->y();
    m_rz = reading->z();

    emit rxChanged(m_rx);
    emit ryChanged(m_ry);
    emit rzChanged(m_rz);
}

void Gyroscope::activate(unsigned requestingPart)
{
    qDebug() << "Gyroscope::activate";
    Sensor::activate(requestingPart);

//    QSensor[] extraSensors = {dynamic_cast<QSensor*>(m_accel), dynamic_cast<QSensor*>(m_magn)};
    for (QSensor* extraSensor : {dynamic_cast<QSensor*>(m_accel), dynamic_cast<QSensor*>(m_magn)}) {

        Q_ASSERT(extraSensor);

        if(!extraSensor->isActive()) {
            qDebug() << "extra sensor started";
            extraSensor->setAlwaysOn(true);
            extraSensor->start();
            extraSensor->stop();
            qDebug() << "extra sensor rates" << extraSensor->availableDataRates();
            extraSensor->setDataRate(extraSensor->availableDataRates().at(0).second);
            qDebug() << "extra sensor current rate" << extraSensor->dataRate();
            extraSensor->start();
        }
    }
}


GyroscopeBridge::GyroscopeBridge(Sensor *sensor, QObject *parent) : SensorBridge(sensor, parent)
{
    Gyroscope* gyro = dynamic_cast<Gyroscope*>(sensor);
    QObject::connect(gyro, SIGNAL(rxChanged(qreal)), this, SIGNAL(rxChanged(qreal)));
    QObject::connect(gyro, SIGNAL(ryChanged(qreal)), this, SIGNAL(ryChanged(qreal)));
    QObject::connect(gyro, SIGNAL(rzChanged(qreal)), this, SIGNAL(rzChanged(qreal)));
}
