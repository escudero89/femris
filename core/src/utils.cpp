#include "utils.h"

#include <QDebug>

QString Utils::midSeparator = "_-_.-_-";
QString Utils::endSeparator = "_--.-__";

QString Utils::dateFormat = "dd/MM/yyyy hh:mm:ss";

Utils::Utils() {
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

QString Utils::base64_encode(const QString& string) {
    QByteArray ba;
    ba.append(string);
    return ba.toBase64();
}

QString Utils::base64_decode(const QString& string) {
    QByteArray ba;
    ba.append(string);
    return QByteArray::fromBase64(ba);
}
