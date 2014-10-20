#ifndef UTILS_H
#define UTILS_H

#include <QString>

class Utils {
public:
    Utils();

    static void throwErrorAndExit(const QString&, unsigned int = 1);
};

#endif // UTILS_H
