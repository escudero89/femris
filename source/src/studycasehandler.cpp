#include "studycasehandler.h"

#include "processhandler.h"

#include "utils.h"

/**
 * @brief StudyCaseHandler::StudyCaseHandler
 */
StudyCaseHandler::StudyCaseHandler() {

    // We initialize the StudyCaseHandler with some information
    QMap<QString, QString> currentStudyCaseVariables;
    currentStudyCaseVariables["stepOfProcess"] = "1";

    m_currentStudyCaseVariables = currentStudyCaseVariables;
}

StudyCaseHandler::~StudyCaseHandler() {
}

/**
 * @brief StudyCaseHandler::selectNewTypeStudyCase
 * @param studyCaseType
 */
void StudyCaseHandler::selectNewTypeStudyCase(const QString& studyCaseType) {
    m_studyCaseType = studyCaseType;
    emit newStudyCaseChose(studyCaseType);
}

/**
 * @brief StudyCaseHandler::createNewStudyCase
 */
void StudyCaseHandler::createNewStudyCase() {

    if (m_studyCaseType == "heat") {
        //m_studyCase = new StudyCaseHeat();

    } else if (m_studyCaseType == "plain-stress") {
        m_studyCase = new StudyCaseStructural();

    } else if (m_studyCaseType == "plain-strain") {
        m_studyCase = new StudyCaseStructural();

    } else {
        Utils::throwErrorAndExit("StudyCaseHandler::createNewStudyCase(): studyCaseType invalid type " + m_studyCaseType);
    }

    m_studyCase->createNew();
    m_currentStudyCaseVariables = m_studyCase->getMapOfInformation();
}

/**
 * @brief StudyCaseHandler::getSingleStudyCaseInformation
 * @param variable
 * @return
 */
QString StudyCaseHandler::getSingleStudyCaseInformation(const QString& variable) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        Utils::throwErrorAndExit("StudyCaseHandler::getStudyCaseInformationAbout(): unknown variable" + variable);
    }

    return m_currentStudyCaseVariables.value(variable);
}

/**
 * @brief StudyCaseHandler::setSingleStudyCaseInformation
 * @param variable
 * @param newVariable
 */
void StudyCaseHandler::setSingleStudyCaseInformation(const QString& variable,
                                                     const QString& newVariable) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable" + variable);
    }

    m_currentStudyCaseVariables[variable] = newVariable;

    m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
    m_studyCase->saveCurrentConfiguration();
}

/**
 * @brief StudyCaseHandler::saveAndContinue
 * @param parentStage
 * @return
 */
QString StudyCaseHandler::saveAndContinue(const QString &parentStage) {

    unsigned int stepOfProcess = getSingleStudyCaseInformation("stepOfProcess").toUInt();
    unsigned int newStepOfProcess = 0;

    int currentStepOfProcess = 1;

    QStringList stagesList;
    stagesList << "CE_Model"
               << "CE_Domain"
               << "CE_Properties"
               << "CE_ShapeFunction"
               << "CE_Results"
               << "CE_Overall";

    while (newStepOfProcess == 0) {

        if (currentStepOfProcess > stagesList.size() - 1) {
            Utils::throwErrorAndExit("StudyCaseHandler::saveAndContinue(): parentStage doesn't exist - " +
                                     parentStage + " [ step: " + QString::number(currentStepOfProcess) + " ] ");
        }

        if (saveAndContinueHelper(parentStage,
                                  stagesList.at(currentStepOfProcess - 1),
                                  stepOfProcess,
                                  currentStepOfProcess)) {

            newStepOfProcess = currentStepOfProcess + 1;
        }

        currentStepOfProcess++;

    }

    setSingleStudyCaseInformation("stepOfProcess", QString::number(newStepOfProcess));

    return stagesList.at(newStepOfProcess - 1);
}

/**
 * @brief StudyCaseHandler::saveAndContinueHelper
 * @param parentStage
 * @param comparisonStage
 * @param stepOfProcess
 * @param stepOfProcessForComparison
 * @return
 */
bool StudyCaseHandler::saveAndContinueHelper(const QString &parentStage,
                                             const QString &comparisonStage,
                                             const unsigned int &stepOfProcess,
                                             const unsigned int &stepOfProcessForComparison) {

    return (parentStage == comparisonStage && stepOfProcess == stepOfProcessForComparison);
}

/**
 * @brief StudyCaseHandler::createDomainFromScriptFile
 * @param pathfile
 * @return
 */
bool StudyCaseHandler::createDomainFromScriptFile() {

    emit loadingStart();
    emit callProcess();

    emit loadingDone();

    return true;

}
