#ifndef STUDYCASESTRUCTURAL_H
#define STUDYCASESTRUCTURAL_H

#include "studycase.h"

class StudyCaseStructural : public virtual StudyCase {
public:
    StudyCaseStructural();
    ~StudyCaseStructural() {};

    void createLocalNew();
    void setLocalMapOfInformation();
};

#endif // STUDYCASESTRUCTURAL_H
