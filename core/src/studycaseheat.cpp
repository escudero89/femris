#include "studycaseheat.h"

#include <QStringList>

#include "fileio.h"

StudyCaseHeat::StudyCaseHeat() {
}

void StudyCaseHeat::setLocalMapOfInformation() {

    m_mapOfInformation["kx"]     = "undefined";
    m_mapOfInformation["ky"]     = "undefined";
    m_mapOfInformation["heat"]   = "undefined";

}

void StudyCaseHeat::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-femCal";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}
