#include "studycasehandler.h"

#include "processhandler.h"

#include <QDebug>

/**
 * @brief StudyCaseHandler::StudyCaseHandler
 */
StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = new StudyCaseStructural();
}

StudyCaseHandler::~StudyCaseHandler() {
    delete m_studyCase;
}

/**
 * @brief StudyCaseHandler::createNewStudyCase
 * @return
 */
bool StudyCaseHandler::createNewStudyCase() {

    m_studyCase->createNew();
    m_currentStudyCaseVariables = m_studyCase->getMapOfInformation();

    return true;
}

/**
 * @brief StudyCaseHandler::getSingleStudyCaseInformation
 * @param variable
 * @return
 */
QString StudyCaseHandler::getSingleStudyCaseInformation(const QString& variable) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        qDebug() << "StudyCaseHandler::getStudyCaseInformationAbout(): unknown variable" << variable;
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
        qDebug() << "StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable" << variable;
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
            qDebug() << "StudyCaseHandler::saveAndContinue(): parentStage doesn't exist - " << parentStage;
            exit(1);
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
 * @brief StudyCaseHandler::createDomainFromOctaveFile
 * @param pathfile
 * @return
 */
bool StudyCaseHandler::createDomainFromOctaveFile(const QString &fileContent) {

    emit loadingStart();

    emit callProcess();

    emit loadingDone();

    return true;

}
