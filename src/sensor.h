#ifndef SENSOR_H
#define SENSOR_H

#include <QObject>
#include <QSensor>
#include <QFile>

#include "activateable.h"

class Sensor : public QObject, public Activateable
{
    Q_OBJECT

    Q_PROPERTY(bool isLogging READ isLogging NOTIFY isLoggingChanged)

public:
    enum Type {
        Accelerometer,
        Gyroscope,
        Magnetometer,
        PressureSensor,
        Rotation,
        Light,
        Proximity
    };

private:
    unsigned sensorTypeToWakeLockPart(Type type);

protected:
    QSensor *m_sensor;
    QFile    m_logFile;
    QString  m_logBaseName;
    Type     m_type;

public:
    explicit Sensor(Type type, QObject *parent = 0);

    Q_INVOKABLE virtual void activate(unsigned requestingPart);
    Q_INVOKABLE virtual void deactivate(unsigned requestingPart);

    Q_INVOKABLE virtual void startLogging(void);
    Q_INVOKABLE virtual void stopLogging(void);
    Q_INVOKABLE virtual bool isLogging(void);
    Q_INVOKABLE virtual void toggleLogging();

signals:
    void isLoggingChanged(bool);

public slots:
    virtual void refresh(void) = 0;

};

class SensorBridge : public QObject
{
    Q_OBJECT
public:
    explicit SensorBridge(Sensor *sensor, QObject* parent = nullptr);

    Q_INVOKABLE void activate(unsigned requestingPart);
    Q_INVOKABLE void deactivate(unsigned requestingPart);

    Q_INVOKABLE void startLogging(void);
    Q_INVOKABLE void stopLogging(void);
//    Q_INVOKABLE bool isLogging(void);
    Q_INVOKABLE void toggleLogging();

signals:
    void activateSignal(unsigned requestingPart);
    void deactivateSignal(unsigned requestingPart);

    void startLoggingSignal(void);
    void stopLoggingSignal(void);
//    void askIsLogging();
    void toggleLoggingSignal();

private:
    Sensor *m_sensor;
};

#endif // SENSOR_H
