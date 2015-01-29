#ifndef STUDYCASESTRUCTURAL_H
#define STUDYCASESTRUCTURAL_H

#include "studycase.h"

/**
 * @brief The StudyCaseStructural class that inherits of StudyCase
 *
 * Since there are currently two main types of Study Cases, one for heat
 * transfer and another one for structural analysis, there's a need for a
 * clear separation between those subclasses.
 */
class StudyCaseStructural : public virtual StudyCase
{
public:
    StudyCaseStructural();
    ~StudyCaseStructural() {}

    void setLocalMapOfInformation();
    void saveLocalCurrentConfiguration();

    bool checkIfReady();
};

#endif // STUDYCASESTRUCTURAL_H
