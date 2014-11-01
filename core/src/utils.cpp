#include "utils.h"

#include <QDebug>

Utils::Utils()
{
}

/**
 * @brief Utils::throwErrorAndExit
 * @param message
 * @param errorCode
 */
void Utils::throwErrorAndExit(const QString& message, unsigned int errorCode) {
    qDebug() << message;
    exit(errorCode);
}
