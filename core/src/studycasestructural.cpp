#include "studycasestructural.h"

#include <QStringList>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural() {
}

void StudyCaseStructural::setLocalMapOfInformation() {

    m_mapOfInformation["youngModulus"]           = "0";
    m_mapOfInformation["poissonCoefficient"]     = "0";
    m_mapOfInformation["densityOfDomain"]        = "0";
    m_mapOfInformation["typeOfProblem"]          = "0";
    m_mapOfInformation["thickOfDomain"]          = "0";

}

void StudyCaseStructural::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-fem";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}
