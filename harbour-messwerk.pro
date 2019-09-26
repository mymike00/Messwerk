# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-messwerk

QT += sensors positioning gui qml quick

QMAKE_CXXFLAGS += -std=c++0x
QMAKE_LFLAGS += -std=c++0x

SOURCES += src/Messwerk.cpp \
    src/accelerometer.cpp \
    src/gyroscope.cpp \
    src/magnetometer.cpp \
    src/sensor.cpp \
    src/plotwidget.cpp \
    src/rotation.cpp \
    src/light.cpp \
    src/proximity.cpp \
    src/pressuresensor.cpp \
    src/satelliteposwidget.cpp \
    src/satelliteinfo.cpp \
    src/activateable.cpp \
    src/satellitestrengthwidget.cpp \
    src/settings.cpp \
    src/position.cpp \
    src/wakelock.cpp

QML_FILES = qml/Messwerk.qml \
    qml/pages/FirstPage.qml \
    qml/pages/InfoPage.qml \
    qml/pages/MagnetPage.qml \
    qml/pages/LightPage.qml \
    qml/pages/GyroPage.qml \
    qml/pages/AccelPage.qml \
    qml/pages/PressurePage.qml \
    qml/pages/PlotTestPage.qml \
    qml/pages/RotationPage.qml \
    qml/pages/SettingsDialog.qml \
    qml/pages/SatellitePage.qml \
    qml/pages/PositionPage.qml \
    qml/Theme.js \
    qml/Constants.js \

OTHER_FILES += translations/*.ts $$QML_FILES

qml_files.path = $$[QT_INSTALL_QML]
qml_files.files = $$QML_FILES

INSTALLS += qml_files

# to disable building translations every time, comment out the
# following CONFIG line
TRANSLATIONS += translations/harbour-messwerk-de.ts \
    translations/harbour-messwerk-pl.ts \
    translations/harbour-messwerk-sv.ts

HEADERS += \
    src/accelerometer.h \
    src/gyroscope.h \
    src/magnetometer.h \
    src/sensor.h \
    src/plotwidget.h \
    src/rotation.h \
    src/light.h \
    src/pressuresensor.h \
    src/proximity.h \
    src/satelliteposwidget.h \
    src/satelliteinfo.h \
    src/activateable.h \
    src/satellitestrengthwidget.h \
    src/settings.h \
    src/position.h \
    src/wakelock.h


