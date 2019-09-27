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
TARGET = messwerk

#load Ubuntu specific features
load(ubuntu-click)

# specify the manifest file, this file is required for click
# packaging and for the IDE to create runconfigurations
UBUNTU_MANIFEST_FILE=manifest.json.in

# specify translation domain, this must be equal with the
# app name in the manifest file
 UBUNTU_TRANSLATION_DOMAIN="messwerk.mymike00"

QT += sensors positioning gui qml quick quickcontrols2

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
    messwerk.apparmor \
    messwerk.desktop \
    logo.svg

qml_files.path = /app
qml_files.files = $$QML_FILES

INSTALLS += qml_files

# Default rules for deployment.
target.path = /
INSTALLS+=target

# to disable building translations every time, comment out the
# following CONFIG line
TRANSLATIONS += translations/messwerk-de.ts \
    translations/messwerk-pl.ts \
   translations/messwerk-sv.ts

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
