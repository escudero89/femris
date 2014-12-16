#include "studycasestructural.h"

#include <QStringList>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural() {
}

void StudyCaseStructural::setLocalMapOfInformation() {

    m_mapOfInformation["youngModulus"]           = "false";
    m_mapOfInformation["poissonCoefficient"]     = "false";
    m_mapOfInformation["densityOfDomain"]        = "false";
    m_mapOfInformation["typeOfProblem"]          = "false";
    m_mapOfInformation["thickOfDomain"]          = "false";

}

void StudyCaseStructural::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-fem";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}
