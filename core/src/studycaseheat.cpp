#include "studycaseheat.h"

#include <QStringList>

#include "fileio.h"

StudyCaseHeat::StudyCaseHeat() {
}

void StudyCaseHeat::setLocalMapOfInformation() {

    m_mapOfInformation["kx"]     = "false";
    m_mapOfInformation["ky"]     = "false";
    m_mapOfInformation["heat"]   = "false";

}

void StudyCaseHeat::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-femCal";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}

bool StudyCaseHeat::checkIfReady() {

    QStringList variablesToCheck;
    variablesToCheck << "kx"
                     << "ky"
                     << "heat";

    bool isReady = true;

    foreach (const QString &str, variablesToCheck) {
        if ( m_mapOfInformation[str] == "false" || m_mapOfInformation[str] == "" ) {
            isReady = false;
            break;
        }
    }

    return isReady;
}

