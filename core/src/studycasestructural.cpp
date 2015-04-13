#include "studycasestructural.h"

#include <QStringList>
#include <QDebug>

#include "fileio.h"

StudyCaseStructural::StudyCaseStructural() {

    Validator youngModulus("E");
    Validator poissonCoefficient("&nu;");
    Validator densityOfDomain("&rho;");
    Validator thickOfDomain("t");
    Validator fixnodes("al menos un nodo fijo");

    youngModulus.addRule("greaterThan", 0.0);
    youngModulus.addRule("notEmpty");

    poissonCoefficient.addRule("greaterThanOrEqualTo", 0.0);
    poissonCoefficient.addRule("lessThan", 0.5);
    poissonCoefficient.addRule("notEmpty");

    densityOfDomain.addRule("greaterThan", 0.0);
    densityOfDomain.addRule("notEmpty");

    thickOfDomain.addRule("greaterThan", 0.0);
    thickOfDomain.addRule("notEmpty");

    fixnodes.addRuleMustNotContain("fixnodes = [\r\n];");

    m_validates.insert("youngModulus", youngModulus);
    m_validates.insert("poissonCoefficient", poissonCoefficient);
    m_validates.insert("densityOfDomain", densityOfDomain);
    m_validates.insert("thickOfDomain", thickOfDomain);
    m_validates.insert("fixnodes", fixnodes);

}

/**
 * @brief Sets some properties related to the structural problem.
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
 * Here we are using `MAT-fem`.
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
 * such as having a Poisson's coefficient between 0 and 0.5, we check if these
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
