#include "studycasestructural.h"

#include <QStringList>
#include <QDebug>

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

bool StudyCaseStructural::checkIfReady() {

    QStringList variablesToCheck;
    variablesToCheck << "youngModulus"
                     << "poissonCoefficient"
                     << "densityOfDomain"
                     << "typeOfProblem"
                     << "thickOfDomain";

    bool isReady = true;

    foreach (const QString &str, variablesToCheck) {
        if ( m_mapOfInformation[str] == "false" || m_mapOfInformation[str] == "" ) {
            isReady = false;
            break;
        }
    }

    return isReady;
}
