#ifndef UTILS_H
#define UTILS_H

#include <QString>

/**
 * @brief The Utils class.
 *
 * This is an utility class. Its purpose is to serve as a class that is never
 * initialize but which has some static methods and static variables, that are
 * used by other classes.
 *
 */
class Utils {
public:
    Utils();

    static void throwErrorAndExit(const QString&, unsigned int = 1);

    static QString base64_encode(const QString&);
    static QString base64_decode(const QString&);

    static QString midSeparator; ///< Used to decode/encode @see StudyCase::loadConfiguration
    static QString endSeparator; ///< Used to decode/encode @see StudyCase::loadConfiguration

    static QString dateFormat;
};

#endif // UTILS_H
