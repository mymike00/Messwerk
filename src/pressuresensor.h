#ifndef PRESSURESENSOR_H
#define PRESSURESENSOR_H

#include <QPressureSensor>

#include "sensor.h"

class PressureSensor : public Sensor
{
    Q_OBJECT

    Q_PROPERTY(qreal pressure READ pressure NOTIFY pressureChanged)

private:
    qreal m_pressure;

public:
    explicit PressureSensor(bool updateInternally = false, QObject *parent = NULL);
    ~PressureSensor();

    qreal pressure(void) const { return m_pressure; }

public slots:
    void refresh(void);
    void logValues(void);

signals:
    void pressureChanged(void);
};

#endif // PRESSURESENSOR_H
