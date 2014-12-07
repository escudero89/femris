#include "studycasestructural.h"

#include <QStringList>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural() {
}

void StudyCaseStructural::setLocalMapOfInformation() {

    m_mapOfInformation["youngModulus"]           = "undefined";
    m_mapOfInformation["poissonCoefficient"]     = "undefined";
    m_mapOfInformation["densityOfDomain"]        = "undefined";
    m_mapOfInformation["typeOfProblem"]          = "undefined";
    m_mapOfInformation["thickOfDomain"]          = "undefined";

}

void StudyCaseStructural::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-fem";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}
