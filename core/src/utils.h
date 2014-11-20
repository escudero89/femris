#ifndef UTILS_H
#define UTILS_H

#include <QString>

class Utils {
public:
    Utils();

    static void throwErrorAndExit(const QString&, unsigned int = 1);

    static QString base64_encode(const QString&);
    static QString base64_decode(const QString&);

    static QString midSeparator;
    static QString endSeparator;
};

#endif // UTILS_H
