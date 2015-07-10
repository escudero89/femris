#ifndef STUDYCASEHEAT_H
#define STUDYCASEHEAT_H

#include "studycase.h"

/**
 * @brief The StudyCaseStructural subclass that deals with the heat transfer problem
 *
 * Since there are currently two main types of Study Cases, one for heat
 * transfer and another one for structural analysis, there's a need for a
 * clear separation between those subclasses.
 *
 * @see StudyCaseStructural
 *
 */
class StudyCaseHeat : public virtual StudyCase
{
public:
    StudyCaseHeat();
    ~StudyCaseHeat() {}

    void setLocalMapOfInformation();
    void saveLocalCurrentConfiguration();

    bool checkIfReady();

};

#endif // STUDYCASEHEAT_H
