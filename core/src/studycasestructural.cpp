#include "studycasestructural.h"

#include <QStringList>
#include <QDebug>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural() {
}

/**
 * @brief Sets some properties related to the heat transfer problem.
 */
void StudyCaseStructural::setLocalMapOfInformation() {

    m_mapOfInformation["youngModulus"]           = "false";
    m_mapOfInformation["poissonCoefficient"]     = "false";
    m_mapOfInformation["densityOfDomain"]        = "false";
    m_mapOfInformation["typeOfProblem"]          = "false";
    m_mapOfInformation["thickOfDomain"]          = "false";

}

/**
 * @brief Saves and splits the configuration file
 *
 * The difference between this and StudyCaseHeat::saveLocalCurrentConfiguration()
 * is the filter used when selecting the blocks from the configuration file.
 * Here we are using `MAT-fem`
 *
 */
void StudyCaseStructural::saveLocalCurrentConfiguration() {
    QStringList configurationFilter;
    configurationFilter << "MAT-variables" << "MAT-fem";
    FileIO::splitConfigurationFile("currentMatFemFile.m", m_source, configurationFilter, true);
}

/**
 * @brief Check if the StudyCase is ready for MATfem
 *
 * Since there are certain conditions that allows MATfem to solve the problem,
 * such as having a Poisson's coefficient between 0 and 0.5, we check if this
 * conditions are met before calling the interpreter.
 *
 * @return Whether the conditions are met or not
 */
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
