#ifndef GYROSCOPE_H
#define GYROSCOPE_H

#include <QGyroscope>

#include <QAccelerometer>
#include <QMagnetometer>
#include "sensor.h"

class Gyroscope : public Sensor
{
    Q_OBJECT

    Q_PROPERTY(qreal rx READ rx NOTIFY rxChanged)
    Q_PROPERTY(qreal ry READ ry NOTIFY ryChanged)
    Q_PROPERTY(qreal rz READ rz NOTIFY rzChanged)

    private:
        qreal m_rx;
        qreal m_ry;
        qreal m_rz;
        QAccelerometer* m_accel;
        QMagnetometer* m_magn;

    public:
        explicit Gyroscope(bool updateInternally = false, QObject *parent = NULL);
        ~Gyroscope();
        Q_INVOKABLE virtual void activate(unsigned requestingPart);

        qreal rx(void) const { return m_rx; }
        qreal ry(void) const { return m_ry; }
        qreal rz(void) const { return m_rz; }

    public slots:
        void refresh(void);
        void logValues(void);

    signals:
        void rxChanged(qreal);
        void ryChanged(qreal);
        void rzChanged(qreal);
};

class GyroscopeBridge : public SensorBridge
{
    Q_OBJECT
    public:
    explicit GyroscopeBridge(Sensor *sensor, QObject *parent = nullptr);
signals:
    void rxChanged(qreal);
    void ryChanged(qreal);
    void rzChanged(qreal);
};

#endif // GYROSCOPE_H
