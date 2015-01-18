#include "utils.h"

#include <QDebug>

QString Utils::midSeparator = "_-_.-_-";
QString Utils::endSeparator = "_--.-__";

QString Utils::dateFormat = "dd/MM/yyyy hh:mm:ss";

/**
 * @brief Empty constructor because it's never initialized
 */
Utils::Utils() {
}

/**
 * @brief Throw an error message and exits the app
 *
 * @param message The error message that is going to be shown
 * @param errorCode A custom code for the error
 */
void Utils::throwErrorAndExit(const QString& message, unsigned int errorCode) {
    qDebug() << message;
    exit(errorCode);
}

/**
 * @brief Encodes a QString passed as parameter usign base64
 * @param string String to encode
 *
 * @return Encoded string
 */
QString Utils::base64_encode(const QString& string) {
    QByteArray ba;
    ba.append(string);
    return ba.toBase64();
}

/**
 * @brief Decodes a QString passed as parameter usign base64
 *
 * @param string String to decode
 *
 * @return Decoded string
 */
QString Utils::base64_decode(const QString& string) {
    QByteArray ba;
    ba.append(string);
    return QByteArray::fromBase64(ba);
}
