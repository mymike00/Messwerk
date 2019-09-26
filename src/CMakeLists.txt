set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
set(PLUGIN "Messwerk")

set(
    SRC
    Messwerk.cpp
    accelerometer.cpp
    activateable.cpp
    gyroscope.cpp
    light.cpp
    magnetometer.cpp
    plotwidget.cpp
    position.cpp
    pressuresensor.cpp
    proximity.cpp
    rotation.cpp
    satelliteinfo.cpp
    satelliteposwidget.cpp
    satellitestrengthwidget.cpp
    sensor.cpp
    settings.cpp
    wakelock.cpp
)

set(CMAKE_AUTOMOC ON)

add_library(${PLUGIN} MODULE ${SRC})
set_target_properties(${PLUGIN} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PLUGIN})
qt5_use_modules(${PLUGIN} Qml Quick DBus Sensors Positioning)

execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(QT_IMPORTS_DIR "/lib/${ARCH_TRIPLET}")

install(TARGETS ${PLUGIN} DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)
install(FILES qmldir DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)
