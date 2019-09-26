#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QObject>

#include "src/Messwerk.h"


int main(int argc, char *argv[])
{
    int result = 0;
    Messwerk mw;
    result = mw.messwerk(argc, argv);

    return result;
}
