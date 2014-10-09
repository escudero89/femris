#include "studycasestructural.h"

#include <QStringList>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural()
{
}

void StudyCaseStructural::createLocalNew() {
    m_typeOfStudyCase       = "structural" ;

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

void StudyCaseStructural::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-fem";
    FileIO::splitConfigurationFile("current-mat-fem-file.m", m_source, configurationFilter, true);

    configurationFilter.clear();
    configurationFilter << "Octave-domain";
    FileIO::splitConfigurationFile("current-octave-domain.m", m_source, configurationFilter, true);

    configurationFilter.clear();
    configurationFilter << "Octave-ff";
    FileIO::splitConfigurationFile("current-octave-ff.m", m_source, configurationFilter, true);
}
