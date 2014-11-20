#ifndef STUDYCASESTRUCTURAL_H
#define STUDYCASESTRUCTURAL_H

#include "studycase.h"

class StudyCaseStructural : public virtual StudyCase
{
public:
    StudyCaseStructural();
    ~StudyCaseStructural() {};

    void setLocalMapOfInformation();
    void saveLocalCurrentConfiguration();
};

#endif // STUDYCASESTRUCTURAL_H
