#include "studycasestructural.h"

StudyCaseStructural::StudyCaseStructural()
{
}

void StudyCaseStructural::createLocalNew() {
    m_youngModulus          = 0 ;
    m_poissonCoefficient    = 0 ;
    m_densityOfDomain       = 0 ;
    m_thickOfDomain         = 0 ;

    m_typeOfProblem         = 0 ;
}

void StudyCaseStructural::setLocalMapOfInformation() {

    m_mapOfInformation["youngModulus"]           = QString::number(m_youngModulus);
    m_mapOfInformation["poissonCoefficient"]     = QString::number(m_poissonCoefficient);
    m_mapOfInformation["densityOfDomain"]        = QString::number(m_densityOfDomain);
    m_mapOfInformation["typeOfProblem"]          = QString::number(m_typeOfProblem);
    m_mapOfInformation["thickOfDomain"]          = QString::number(m_thickOfDomain);

}
