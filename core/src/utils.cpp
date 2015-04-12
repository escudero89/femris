#include "utils.h"

#include <QDebug>

#include <QFile>
#include <QBitArray>

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

/**
 * @brief Stringify a QMap
 *
 * @param mapToEncode The QMap we wish to encode
 * @return The QMap stringifyed
 */
QString Utils::qMapToString(const QMap<QString, QString> mapToEncode) {

    QString encodedMap    = "";
    QString encodedReturn = "";

    QMapIterator<QString, QString> i(mapToEncode);

    while (i.hasNext()) {
        i.next();

        if (i.key() == "encoded") {
            continue;
        }

        QString val = i.value().isEmpty() ? "false" : i.value();

        encodedMap += i.key() + Utils::midSeparator + val + Utils::endSeparator;
    }

    encodedReturn = Utils::base64_encode(encodedMap);

    for ( int k = 1 ; k <= encodedReturn.size() ; k++ ) {
        // Every 80 characters we put a breakline
        if (k%80 == 0) {
            encodedReturn.insert(k - 1, "\r\n");
        }
    }

    return encodedReturn;
}

/**
 * @brief Apply the inverse process of qMapToString()
 *
 * @param stringToConvert Stringifyed QMap
 * @return The QMap stringifyed
 */
QMap<QString, QString> Utils::stringToQMap(const QString stringToConvert) {

    QStringList blocksOfInfo = stringToConvert.split(Utils::endSeparator, QString::SkipEmptyParts);
    QMap<QString, QString> mapToReturn;

    for (int i = 0; i < blocksOfInfo.size(); i++) {
        QStringList keyAndValue = blocksOfInfo.at(i).split(Utils::midSeparator);
        mapToReturn[ keyAndValue[0] ] = keyAndValue[1];
    }

    return mapToReturn;

}
