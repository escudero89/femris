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
