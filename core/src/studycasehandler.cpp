#include "studycasehandler.h"

#include "configure.h"
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
    markAsSaved();
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

    markAsSaved();
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

    } else if (m_studyCaseType == "plane-stress") {
        m_studyCase = new StudyCaseStructural();

    } else if (m_studyCaseType == "plane-strain") {
        m_studyCase = new StudyCaseStructural();

    } else {
        Utils::throwErrorAndExit("StudyCaseHandler::createNewStudyCase(): studyCaseType invalid type " + m_studyCaseType);
    }

    m_studyCase->createNew();
    m_currentStudyCaseVariables = m_studyCase->getMapOfInformation();

    // Extra parameter for structural (1 for plane stress, 0 for plane strain)
    if (m_studyCaseType == "plane-stress" || m_studyCaseType == "plane-strain") {
        setSingleStudyCaseInformation("typeOfProblem", (m_studyCaseType == "plane-stress") ? "1" : "0");
    }

    setSingleStudyCaseInformation("typeOfStudyCase", m_studyCaseType);

    emit newStudyCaseCreated();
}

void StudyCaseHandler::saveCurrentStudyCase(const QString& whereToSave) {
    if (exists()) {
        m_studyCase->saveCurrentConfiguration(whereToSave);
        markAsSaved();
    }
}

/**
 * @brief StudyCaseHandler::loadStudyCase
 * @param whereToLoad
 * @return bool
 */
bool StudyCaseHandler::loadStudyCase(const QString& whereToLoad) {
    QMap<QString,QString> results = m_studyCase->loadConfiguration(whereToLoad);

    if (results.empty()) {
        return false;
    }

    start();

    m_studyCaseType = results["typeOfStudyCase"];
    createNewStudyCase();

    m_currentStudyCaseVariables = results;
    m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);

    markAsSaved();
    return true;
}

/**
 * @brief StudyCaseHandler::checkSingleStudyCaseInformation
 * @param variable
 * @return
 */
bool StudyCaseHandler::checkSingleStudyCaseInformation(const QString& variable) {
    return m_currentStudyCaseVariables.contains(variable);
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

    } else {

        if (!m_currentStudyCaseVariables.contains(variable)) {
            Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable " + variable);
        }

        m_currentStudyCaseVariables[variable] = newVariable;
        m_currentStudyCaseVariables["modified"] = (QDateTime::currentDateTime()).toString();

        m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
        m_studyCase->saveCurrentConfiguration();

        markAsNotSaved();
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

        markAsNotSaved();
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

    QStringList stagesList;
    stagesList << "CE_Model"
               << "CE_Domain"
               << "CE_ShapeFunction"
               << "CE_Results"
               << "CE_Overall";

    unsigned int nextStepOfProcess = stagesList.indexOf(parentStage) + 1;

    setSingleStudyCaseInformation("stepOfProcess", QString::number(nextStepOfProcess));

    return stagesList.at(nextStepOfProcess);
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

void StudyCaseHandler::loadUrlInBrowser(QString link, bool withoutFullPath) {
    if (withoutFullPath) {
        QDesktopServices::openUrl(QUrl(link));
    } else {
        QDesktopServices::openUrl(QUrl(Configure::read("fileApplicationDirPath") + link));
    }
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

bool StudyCaseHandler::savedStatus() {
    return m_isSaved;
}

void StudyCaseHandler::markAsSaved() {
    m_isSaved = true;
}

void StudyCaseHandler::markAsNotSaved() {
    m_isSaved = false;
}
