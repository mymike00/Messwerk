#include <QStringList>
#include <QDateTime>

#include <qmath.h>

#include "pressuresensor.h"


PressureSensor::PressureSensor(bool updateInternally, QObject *parent)
    : Sensor(Sensor::PressureSensor, parent)
{
    m_sensor = new QPressureSensor(this);
    m_logBaseName = "pressuresensor";

    if(updateInternally) {
        QObject::connect(m_sensor, SIGNAL(readingChanged()), this, SLOT(refresh()));
    }

    QObject::connect(m_sensor, SIGNAL(readingChanged()), this, SLOT(logValues()));
}

PressureSensor::~PressureSensor()
{
}

void PressureSensor::logValues(void)
{
    if(isLogging()) {
        QPressureSensor *pressure = dynamic_cast<QPressureSensor*>(m_sensor);
        QPressureReading *reading = pressure->reading();

        QString line = QString("%1\t%2\n")
                               .arg(QDateTime::currentMSecsSinceEpoch()/1000.0, 0, 'f', 3)
                               .arg(reading->pressure());

        m_logFile.write(line.toUtf8());
    }
}

void PressureSensor::refresh(void)
{
    if(!m_sensor->isActive()) {
        return;
    }

    QPressureSensor *pressure = dynamic_cast<QPressureSensor*>(m_sensor);
    QPressureReading *reading = pressure->reading();

    m_pressure = reading->pressure();

    emit pressureChanged();
}
