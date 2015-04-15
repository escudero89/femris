#include "studycasehandler.h"

#include "configure.h"
#include "processhandler.h"
#include "utils.h"

#include <QDesktopServices>
#include <QJsonArray>
#include <QUrl>

/**
 * @brief When the StudyCaseHandler is created, it sets the Study Case as null,
 * it marks it as saved, and calls start()
 */
StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = NULL;
    m_lastSavedPath = "";

    markAsSaved();
    start();
}

/**
 * @brief Starts the current Study Case, and deletes the previous stats
 *
 * It also sets the `stepOfProcess` to `1`.
 *
 * @see markAsSaved()
 */
void StudyCaseHandler::start() {
    // Delete the previous (if there is one) study case
    if (exists()) {
        delete m_studyCase;
        m_studyCase = NULL;

        m_lastSavedPath = "";
    }

    // We initialize the StudyCaseHandler with some information
    QMap<QString, QString> currentStudyCaseVariables;
    currentStudyCaseVariables["stepOfProcess"] = "1";

    m_currentStudyCaseVariables = currentStudyCaseVariables;
    m_temporalStudyCaseVariables = QMap<QString, QString> ();

    markAsSaved();
}

/**
 * @brief Checks if there are a Study Case that is being currently handled
 * @return Whether the Study Case exists or not
 */
bool StudyCaseHandler::exists() {
    return (m_studyCase != NULL);
}

/**
 * @brief Sets the Study Case's type.
 *
 * @param studyCaseType The new type (`heat`, `plane-stress`, `plane-strain`).
 * @see newStudyCaseChose()
 */
void StudyCaseHandler::selectNewTypeStudyCase(const QString& studyCaseType) {
    m_studyCaseType = studyCaseType;

    emit newStudyCaseChose(studyCaseType);
}

/**
 * @brief This function is mainly used to check the internal structure of the Study Case
 *
 * It's call in the QML one the user change the type of the Study Case. If the
 * type is of the different nature (e.g., heat transfer instead of structural),
 * we create a new study case.
 *
 * @see createNewStudyCase()
 */
void StudyCaseHandler::adoptNewTypeStudyCaseIfNecessary() {

    // If there is already a study case created, we check if the type is the same
    // as the one we know. If not, we remove the previous one.
    if (!exists()) {
        return;
    }

    QString previousStudyCaseType = getSingleStudyCaseInformation("typeOfStudyCase");

    if (previousStudyCaseType == m_studyCaseType) {
        return;
    }

    // Note: only if there is a change between heat and plane-stress/strain
    if ( ( ( previousStudyCaseType == "heat" ) &&
           ( m_studyCaseType == "plane-stress" || m_studyCaseType == "plane-strain" ) ) ||
         ( ( m_studyCaseType == "heat" ) &&
           ( previousStudyCaseType == "plane-stress" || previousStudyCaseType == "plane-strain" ) ) ) {

         createNewStudyCase();
    }

}

/**
 * @brief Creates a new Study Case
 *
 * It needs already stored in the StudyCaseHandler the information of the type
 * of the Study Case to create. Otherwise, will throw an error.
 *
 * @see StudyCase::createNew()
 * @see StudyCase::getMapOfInformation()
 * @see newStudyCaseCreated()
 *
 * @throw Utils::throwErrorAndExit()
 */
void StudyCaseHandler::createNewStudyCase() {

    // Delete the previous (if there is one) study case
    if (exists()) {
        delete m_studyCase;
        m_studyCase = NULL;
    }

    if (m_studyCaseType == "heat") {
        m_studyCase = new StudyCaseHeat();

    } else if (m_studyCaseType == "plane-stress") {
        m_studyCase = new StudyCaseStructural();

    } else if (m_studyCaseType == "plane-strain") {
        m_studyCase = new StudyCaseStructural();

    } else {
        Utils::throwErrorAndExit("StudyCaseHandler::createNewStudyCase(): studyCaseType invalid type " + m_studyCaseType);
    }

    m_studyCase->createNew();
    m_currentStudyCaseVariables = m_studyCase->getMapOfInformation();
    m_temporalStudyCaseVariables = QMap<QString, QString> ();

    // Extra parameter for structural (1 for plane stress, 0 for plane strain)
    if (m_studyCaseType == "plane-stress" || m_studyCaseType == "plane-strain") {
        setSingleStudyCaseInformation("typeOfProblem", (m_studyCaseType == "plane-stress") ? "1" : "0");
    }

    setSingleStudyCaseInformation("typeOfStudyCase", m_studyCaseType);

    emit newStudyCaseCreated();
}

/**
 * @brief Saves the current Study Case
 *
 * The information is stored in a file with the extension `.femris` in a certain
 * location given by the user.
 *
 * @param whereToSave The path and the name of the file to be saved. If it doesn't
 * have the extension `.femris`, this one is added automatically.
 *
 * @see StudyCase::saveCurrentConfiguration()
 *
 * @see savingCurrentStudyCase()
 * @see markAsSaved()
 */
void StudyCaseHandler::saveCurrentStudyCase(QString whereToSave) {
    if (!exists()) {
        return;
    }

    emit savingCurrentStudyCase();

    if (whereToSave != m_lastSavedPath && !whereToSave.toLower().contains(".femris")) {
        whereToSave += ".femris";
    }

    m_studyCase->saveCurrentConfiguration(whereToSave);
    markAsSaved();

    m_lastSavedPath = whereToSave;

}

/**
 * @brief Checks if a rule is being passed or not in the study case
 * @param rule The rule to be check
 * @param currentValue The value for comparison
 * @return True if passed, false otherwise
 */
bool StudyCaseHandler::checkRule(const QString rule, const QString currentValue) {
    return m_studyCase->checkRule(rule, currentValue, QString());
}

/**
 * @brief Returns the message associated with a certain rule of the study case
 * @param rule The rule we are looking for
 * @param currentValue The value for comparison
 * @return The related message
 */
QString StudyCaseHandler::getRuleMessage(const QString rule, const QString currentValue) {
    QString failedRule;
    m_studyCase->checkRule(rule, currentValue, failedRule);
    return m_studyCase->getRuleMessage(rule, failedRule);
}
/**
 * @brief Exports the current Study Case to be used in the post-process of gid_t
 *
 * This function actually saves three files. Two of them are for its direct use
 * in the post-process of GiD (with the extensions `*.flavia.*`), and the main
 * (with the extension `*.m`) can be used to execute MATfem over.
 *
 * @param whereToSave The path in which the main file is going to be saved
 * @return Whether it was successful in exporting the files
 */
bool StudyCaseHandler::exportCurrentStudyCase(QString whereToSave) {
    if (!exists()) {
        return false;
    }

    emit savingCurrentStudyCase();

    if (!whereToSave.toLower().contains(".m")) {
        whereToSave += ".m";
    }

    return m_studyCase->exportToGid(whereToSave);
}

/**
 * @brief Loads a Study Case from a file.
 *
 * @param whereToLoad
 * @return bool
 *
 * @see start()
 * @see createNewStudyCase()
 *
 * @see StudyCase::setMapOfInformation()
 * @see StudyCase::saveCurrentConfiguration()
 *
 * @see loadingNewStudyCase()
 * @see markAsSaved()
 * @see isReady()
 */
bool StudyCaseHandler::loadStudyCase(const QString& whereToLoad) {
    QMap<QString,QString> results = m_studyCase->loadConfiguration(whereToLoad);

    if (results.empty()) {
        return false;
    }

    emit loadingNewStudyCase();

    start();

    m_studyCaseType = results["typeOfStudyCase"];
    createNewStudyCase();

    m_currentStudyCaseVariables = results;

    // Extra information
    if (results.contains("extraInformation")) {
        QString decodedExtraInfo = Utils::base64_decode(results["extraInformation"]);
        m_temporalStudyCaseVariables = Utils::stringToQMap(decodedExtraInfo);
    }

    m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
    m_studyCase->setExtraInformation(m_temporalStudyCaseVariables);

    m_studyCase->saveCurrentConfiguration();
    m_lastSavedPath = whereToLoad;

    markAsSaved();
    isReady();

    return true;
}

/**
 * @brief Checks if a certain variable exists in the QMap of the Study Case
 *
 * @param variable The name of the variable that we are looking for
 * @return Whether exists (true) or not (false)
 */
bool StudyCaseHandler::checkSingleStudyCaseInformation(const QString& variable) {
    return m_currentStudyCaseVariables.contains(variable);
}

/**
 * @brief Checks the existence and the content of a variable in the QMap of the Study Case
 *
 * @param variable The name of the variable that we are checking
 * @param comparison The value we are going to compare with the currently stored in the variable
 * @return True if the variable exists and if its value is the same as the @p comparison.
 */
bool StudyCaseHandler::checkSingleStudyCaseInformation(const QString& variable, const QString &comparison) {
    return checkSingleStudyCaseInformation(variable) && m_currentStudyCaseVariables[variable] == comparison;
}

/**
 * @brief Gets the currently stored value in a certain variable
 *
 * @param variable The variable that we are trying to get its value
 * @param isTemporal Is the variable actually is in the temporary QMap?
 * @return The value of the variable
 *
 * @throw Utils::throwErrorAndExit If the variable isn't in the QMap and @p isTemporal is false
 */
QString StudyCaseHandler::getSingleStudyCaseInformation(const QString& variable, bool isTemporal) {

    if (!m_currentStudyCaseVariables.contains(variable) && !isTemporal) {
        Utils::throwErrorAndExit("StudyCaseHandler::getSingleStudyCaseInformation(): unknown variable " + variable);
    }

    if (isTemporal && !m_temporalStudyCaseVariables.contains(variable)) {
        m_temporalStudyCaseVariables.insert(variable, "");
    }

    return (isTemporal) ?
                m_temporalStudyCaseVariables.value(variable) :
                m_currentStudyCaseVariables.value(variable);
}

/**
 * @brief Sets a value into a variable of the QMap stored in the Study Case
 *
 * @param variable The name of the variable that will contain the new value
 * @param newValue The new value
 * @param isTemporal Should we save the variable in the temporary QMap?
 *
 * @see markAsNotSaved() Which is only called if the new variable stored is not temporal.
 */
void StudyCaseHandler::setSingleStudyCaseInformation(const QString& variable,
                                                     const QString& newValue,
                                                     bool isTemporal) {

    if (isTemporal) {

        bool saveCurrentConfiguration = false;

        if (!m_temporalStudyCaseVariables.contains(variable)) {
            m_temporalStudyCaseVariables.insert(variable, newValue);
            saveCurrentConfiguration = true;
        }

        if (m_temporalStudyCaseVariables[variable] != newValue) {
            m_temporalStudyCaseVariables[variable] = newValue;
            saveCurrentConfiguration = true;
        }

        if (saveCurrentConfiguration && exists()) {
            m_studyCase->setExtraInformation(m_temporalStudyCaseVariables);
            m_studyCase->saveCurrentConfiguration();
        }

        return;
    }

    if (!m_currentStudyCaseVariables.contains(variable)) {
        Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable " + variable);
    }

    // We only update the data if differs from the previous one recorded
    if (m_currentStudyCaseVariables[variable] != newValue) {
        m_currentStudyCaseVariables[variable] = newValue;
        m_currentStudyCaseVariables["modified"] = (QDateTime::currentDateTime()).toString();

        markAsNotSaved();
        isReady();

        m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
        m_studyCase->saveCurrentConfiguration();
    }

}

/**
 * @brief Converts a QJsonArray into a QString and then saves its value in the variable
 *
 * @param variable The variable of the QMap which is going to store the JSON stringified
 * @param jsonValue The JSON that we are trying to save
 *
 * @see setSingleStudyCaseJsonHelper()
 *
 * @see StudyCase::setMapOfInformation()
 * @see StudyCase::saveCurrentConfiguration()
 *
 * @see markAsNotSaved()
 *
 * @throw Utils::throwErrorAndExit()
 */
void StudyCaseHandler::setSingleStudyCaseJson(const QString& variable,
                                              const QJsonArray& jsonValue) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        Utils::throwErrorAndExit("StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable " + variable);
    }

    QString newJsonfyVariable = setSingleStudyCaseJsonHelper(variable, jsonValue);

    // We only update the data if differs from the previous one recorded
    if (m_currentStudyCaseVariables[variable] != newJsonfyVariable) {
        m_currentStudyCaseVariables[variable] = newJsonfyVariable;

        m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
        m_studyCase->saveCurrentConfiguration();

        markAsNotSaved();
    }
}

/**
 * @brief Converts a QJsonArray (e.g., from the Javascript in QML) into a QString
 *
 * @param nameVariable The name of the variable (since a JSON doesn't have a name)
 * @param jsonVariable The QJsonArray to stringify
 *
 * @return The JSON stringified like "nameVariable = [ ... jsonVariable ... ]"
 */
QString StudyCaseHandler::setSingleStudyCaseJsonHelper(const QString& nameVariable,
                                                       const QJsonArray& jsonVariable) {

    QString jsonQString = nameVariable.trimmed();

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
 * @brief Advances the Study Case one step further in the FEM process.
 *
 * This function is used in the QML, to set the current step in which the Study
 * Case is located, and then determinate in what `ChoiceBlock` currently is.
 *
 * @param parentStage The name of the stage in which the Study Case was
 * @return The number of the next step of the process
 */
QString StudyCaseHandler::saveAndContinue(const QString &parentStage) {

    QStringList stagesList;
    stagesList << "________"
               << "CE_Model"
               << "CE_Domain"
               << "CE_ShapeFunction"
               << "CE_Results"
               << "CE_Overall";

    unsigned int nextStepOfProcess = stagesList.indexOf(parentStage) + 1;

    setSingleStudyCaseInformation("stepOfProcess", QString::number(nextStepOfProcess));

    return stagesList.at(nextStepOfProcess);
}

/**
 * @brief Loads a link into the default web browser of the user.
 *
 * @param link The path to load (it could an url or a file).
 * @param withoutFullPath Whether it needs to add the current App path.
 */
void StudyCaseHandler::loadUrlInBrowser(QString link, bool withoutFullPath) {
    if (!withoutFullPath) {
        link = Configure::read("fileApplicationDirPath") + link;
    }

    QDesktopServices::openUrl(QUrl(link));
}

/**
 * @brief Checks if the StudyCase is ready for MATfem
 *
 * @return Whether is ready or not
 *
 * @see ready()
 * @see StudyCase::isReady()
 */
bool StudyCaseHandler::isReady() {

    QString failedField;
    QString failedRule;

    bool check = m_studyCase->isReady(failedField, failedRule);

    if (!check) {
        emit fail(m_studyCase->getRuleMessage(failedField, failedRule));
    }

    return check;
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

/**
 * @brief Get the current save status of the Study Case
 * @return True if it's marked as saved, or false otherwise
 */
bool StudyCaseHandler::getSavedStatus() {
    return m_isSaved;
}

/**
 * @brief Set the current Study Case as saved.
 * @see StudyCaseHandler::markedAsSaved()
 */
void StudyCaseHandler::markAsSaved() {
    m_isSaved = true;

    emit StudyCaseHandler::markedAsSaved();
}

/**
 * @brief Set the current Study Case as with changes that are not saved yet
 * @see StudyCaseHandler::markedAsNotSaved()
 */
void StudyCaseHandler::markAsNotSaved() {
    m_isSaved = false;

    emit StudyCaseHandler::markedAsNotSaved();
}

/**
 * @brief Returns the last saved path
 * @return Last saved path (if exists, otherwise it returns empty)
 */
QString StudyCaseHandler::getLastSavedPath() {
    return m_lastSavedPath;
}

/**
 * @brief Whether if the study type passed as argument is the same as the current one
 * @param typeOfStudyCase Type of Study Case: `heat`, `plane-stress`, `plane-strain`
 *
 * @return Whether is the same type (true) or not (false)
 */
bool StudyCaseHandler::isStudyType(const QString& typeOfStudyCase) {
    return checkSingleStudyCaseInformation("typeOfStudyCase", typeOfStudyCase);
}

//----------------------------------------------------------------------------//
//--                                SIGNALS                                 --//
//----------------------------------------------------------------------------//

//! @fn void StudyCaseHandler::newStudyCaseChose(const QString& studyCaseType)
//! @brief A new Study Case's type has been chose

//! @fn void StudyCaseHandler::newStudyCaseCreated()
//! @brief A new Study Case has been created

//! @fn void StudyCaseHandler::loadingNewStudyCase()
//! @brief A Study Case has been loaded from a file

//! @fn void StudyCaseHandler::savingCurrentStudyCase()
//! @brief The Study Case has been stored in a file with a `.femris` extension

//! @fn void StudyCaseHandler::markedAsSaved()
//! @brief The Study Case is marked as saved (no changes are without saving)

//! @fn void StudyCaseHandler::markedAsNotSaved()
//! @brief There are some modifications in the Study Case that are not saved

//! @fn void StudyCaseHandler::fail(const QString& failedRuleMessage)
//! @brief The Study Case failed to be ready for MATfem
