#include "studycasehandler.h"

#include "processhandler.h"

#include "utils.h"

#include <QDesktopServices>
#include <QJsonArray>
#include <QUrl>

/**
 * @brief StudyCaseHandler::StudyCaseHandler
 */
StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = NULL;
    start();
}

/**
 * @brief StudyCaseHandler::~StudyCaseHandler
 */
StudyCaseHandler::~StudyCaseHandler() {
}

/**
 * @brief StudyCaseHandler::start
 */
void StudyCaseHandler::start() {
    // Delete the previous (if there is one) study case
    if (exists()) {
        delete m_studyCase;
        m_studyCase = NULL;
    }

    // We initialize the StudyCaseHandler with some information
    QMap<QString, QString> currentStudyCaseVariables;
    currentStudyCaseVariables["stepOfProcess"] = "1";

    m_currentStudyCaseVariables = currentStudyCaseVariables;
}

/**
 * @brief StudyCaseHandler::exists
 */
bool StudyCaseHandler::exists() {
    return (m_studyCase != NULL);
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

    emit newStudyCaseCreated();
}

void StudyCaseHandler::saveCurrentStudyCase(const QString& whereToSave) {
    if (exists()) {
        m_studyCase->saveCurrentConfiguration(whereToSave);
    }
}

/**
 * @brief StudyCaseHandler::getSingleStudyCaseInformation
 * @param variable
 * @return
 */
QString StudyCaseHandler::getSingleStudyCaseInformation(const QString& variable, bool isTemporal) {

    if (!m_currentStudyCaseVariables.contains(variable) && !isTemporal) {
        Utils::throwErrorAndExit("StudyCaseHandler::getStudyCaseInformationAbout(): unknown variable " + variable);
    }

    if (isTemporal) {
        if (!m_temporalStudyCaseVariables.contains(variable)) {
            m_temporalStudyCaseVariables.insert(variable, "");
        }
    }

    return (isTemporal) ?
                m_temporalStudyCaseVariables.value(variable) :
                m_currentStudyCaseVariables.value(variable);
}

/**
 * @brief StudyCaseHandler::setSingleStudyCaseInformation
 * @param variable
 * @param newVariable
 */
void StudyCaseHandler::setSingleStudyCaseInformation(const QString& variable,
                                                     const QString& newVariable,
                                                     bool isTemporal) {

    if (isTemporal) {
        m_temporalStudyCaseVariables.insert(variable, newVariable);
qDebug() << m_temporalStudyCaseVariables.value(variable);
    } else {

        if (!m_currentStudyCaseVariables.contains(variable)) {
            Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable " + variable);
        }

        m_currentStudyCaseVariables[variable] = newVariable;

        m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
        m_studyCase->saveCurrentConfiguration();

    }
}

/**
 * @brief StudyCaseHandler::setSingleStudyCaseInformation
 * @param variable
 * @param newVariable
 */
void StudyCaseHandler::setSingleStudyCaseJson(const QString& variable,
                                              const QJsonArray& newVariable,
                                              bool isTemporal) {

    if (isTemporal) {
        //m_temporalStudyCaseVariables.insert(variable, newVariable.toString());

    } else {

        if (!m_currentStudyCaseVariables.contains(variable)) {
            Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable " + variable);
        }

        m_currentStudyCaseVariables[variable] = setSingleStudyCaseJsonHelper(variable, newVariable);

        m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
        m_studyCase->saveCurrentConfiguration();

    }
}

/**
 * @brief StudyCaseHandler::setSingleStudyCaseJsonHelper
 * @param nameVariable
 * @param jsonVariable
 * @return
 */
QString StudyCaseHandler::setSingleStudyCaseJsonHelper(const QString& nameVariable,
                                                       const QJsonArray& jsonVariable) {

    QString jsonQString = nameVariable;

    jsonQString += " = [\r\n";


    if (!jsonVariable.isEmpty()) {

        for ( int l = 0 ; l < jsonVariable.size() ; l++ ) {

            jsonQString += "    ";

            QJsonArray jsonVariableInside = jsonVariable[l].toArray();

            for ( int m = 0 ; m < jsonVariableInside.size() ; m++ ) {

                jsonQString += QString::number(jsonVariableInside[m].toDouble());

                if (m + 1 < jsonVariableInside.size()) {
                     jsonQString += ",    ";
                }

            }

            jsonQString += " ;\r\n";

        }
    }

    jsonQString += "];\r\n";

    return jsonQString;

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
void StudyCaseHandler::createDomainFromScriptFile() {
    emit loadingStart();
    emit callProcess();
    emit loadingDone();
}

void StudyCaseHandler::loadUrlInBrowser(QString link) {
    QDesktopServices::openUrl(QUrl(link));
}
