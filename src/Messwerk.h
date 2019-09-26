#ifndef MESSWERK_H
#define MESSWERK_H

#include <QAccelerometer>

#include "sensor.h"

class Messwerk : public QObject
{

public slots:
    int messwerk(int argc, char *argv[]);
};

#endif // MESSWERK_H
