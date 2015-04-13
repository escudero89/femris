#include "studycaseheat.h"

#include <QStringList>

#include "fileio.h"

StudyCaseHeat::StudyCaseHeat() {

    Validator kx;
    Validator ky;

    kx.addRule("greaterThan", 0.0);
    kx.addRule("notEmpty");

    ky.addRule("greaterThan", 0.0);
    ky.addRule("notEmpty");

    m_validates.insert("kx", kx);
    m_validates.insert("ky", ky);

}

/**
 * @brief Sets some properties related to the heat transfer problem.
 */
void StudyCaseHeat::setLocalMapOfInformation() {

    m_mapOfInformation["kx"]     = "false";
    m_mapOfInformation["ky"]     = "false";
    m_mapOfInformation["heat"]   = "false";

}

/**
 * @brief Saves and splits the configuration file
 *
 * The difference between this and StudyCaseStructural::saveLocalCurrentConfiguration()
 * is the filter used when selecting the blocks from the configuration file.
 * Here we are using `MAT-femCal`.
 *
 */
void StudyCaseHeat::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-femCal";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}

/**
 * @brief Check if the StudyCase is ready for MATfemCal
 *
 * Since there are certain conditions that allows MATfemCal to solve the problem,
 * such as having at least one Dirichlets' condition set, we check if these
 * conditions are met before calling the interpreter.
 *
 * @return Whether the conditions are met or not
 */
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

