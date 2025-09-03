#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>
#include <QDir>
#include <QStandardPaths>

class Settings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString loggingPath READ getLoggingPath WRITE setLoggingPath NOTIFY loggingPathChanged)
    Q_PROPERTY(bool preventDisplayBlanking READ getPreventDisplayBlanking WRITE setPreventDisplayBlanking NOTIFY preventDisplayBlankingChanged)

    // The following property allows QML to check wether the Jolla Harbour version is currently running, which has less features due to banned libraries
    Q_PROPERTY(bool isHarbourVersion READ getIsHarbourVersion)
private:
    QSettings *m_settings;

    Settings(); // singleton class, constructor is private

public:
    ~Settings();

    static Settings& instance()
    {
        static Settings theSettings;
        return theSettings;
    }

    QString getLoggingPath(void) { return m_settings->value("LoggingPath", QStandardPaths::writableLocation(QStandardPaths::CacheLocation)).toString(); }
    bool getPreventDisplayBlanking(void) { return m_settings->value("PreventDisplayBlanking", false).toBool(); }

    bool getIsHarbourVersion(void)
    {
#ifdef FOR_HARBOUR
        return true;
#else
        return false;
#endif
    }

public slots:
    void setLoggingPath(const QString &path)
    {
        m_settings->setValue("LoggingPath", path);
        emit loggingPathChanged(path);
    }
    void setLoggingPathUT(const int &path)
    {
        switch (path) {
            case 0: setLoggingPath(QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation)); break;
            case 1: setLoggingPath(QStandardPaths::writableLocation(QStandardPaths::CacheLocation)); break;
            case 2: setLoggingPath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)); break;
        }
        emit loggingPathChanged(getLoggingPath());
    }

    void setPreventDisplayBlanking(bool prevent)
    {
        m_settings->setValue("PreventDisplayBlanking", prevent);
        emit preventDisplayBlankingChanged(prevent);
    }

signals:
    void loggingPathChanged(const QString &newPath);
    void preventDisplayBlankingChanged(bool prevented);
};

#endif // SETTINGS_H
