#ifndef STUDYCASEHEAT_H
#define STUDYCASEHEAT_H

#include "studycase.h"

class StudyCaseHeat : public virtual StudyCase
{
public:
    StudyCaseHeat();
    ~StudyCaseHeat() {};

    void setLocalMapOfInformation();
    void saveLocalCurrentConfiguration();

    bool checkIfReady();
};

#endif // STUDYCASEHEAT_H
