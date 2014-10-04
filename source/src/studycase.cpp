#include "studycase.h"

void StudyCase::createNew() {

    m_source = "/temp/";

    // DOUBLES
    m_youngModulus          = 0 ;
    m_poissonCoefficient    = 0 ;
    m_densityOfDomain       = 0 ;
    m_thickOfDomain         = 0 ;

    m_typeOfProblem         = 0 ;

    // ARM::MAT
    // m_coordinates;
    // m_elements;
    // m_fixnodes;
    // m_pointload;
    // m_sideload;
}
