#include "studycase.h"

#include <QApplication>
#include <QDebug>

#include "configure.h"
#include "fileio.h"
#include "utils.h"

StudyCase::StudyCase() {

    Validator gridHeight("altura del dominio");
    Validator gridWidth("ancho del dominio");

    gridHeight.addRule("greaterThan", 0.0);
    gridHeight.addRule("notEmpty");

    gridWidth.addRule("greaterThan", 0.0);
    gridWidth.addRule("notEmpty");

    m_validates.insert("gridHeight", gridHeight);
    m_validates.insert("gridWidth", gridWidth);

}

/**
 * @brief Creates a new Study Case, and sets its initial configuration
 *
 * Sets its created and modified date, which and where its temporary source is,
 * and the initial map of information. Finally, saves everything.
 *
 * @see setInitialMapOfInformation()
 * @see saveCurrentConfiguration()
 *
 */
void StudyCase::createNew() {

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

    setInitialMapOfInformation();
    saveCurrentConfiguration();
}

StudyCase::~StudyCase() {}

/**
 * @brief Loads configuration from a file into a QMap
 * @param whereToLoad The of the file where to load the configuration
 * @return The QMap
 */
QMap<QString, QString> StudyCase::loadConfiguration(const QString& whereToLoad) {

    QStringList configurationFilter;
    configurationFilter << "Base64-encode";
    if (!FileIO::splitConfigurationFile("currentEnconding.base64", whereToLoad, configurationFilter, true)) {
        return QMap<QString,QString>();
    }

    FileIO encodedFileStudyCase(Configure::formatWithAbsPath("temp/currentEnconding.base64"));
    QString encodedInfo = encodedFileStudyCase.read();

    // We remove all the breaklines, and then we decode
    encodedInfo.replace("\r\n", "");
    encodedInfo.replace("\n", "");

    QMap<QString, QString> newMapOfInformation = Utils::stringToQMap(Utils::base64_decode(encodedInfo));

    return newMapOfInformation;
}

/**
 * @brief Saves the current QMap with all the info of the StudyCase into a file
 * @param whereToSave Path where to save the QMap
 */
void StudyCase::saveCurrentConfiguration(const QString& whereToSave) {

    QString pathDir = qApp->applicationDirPath();

    QString pathConfigurationToLoad = pathDir + "/scripts/base.femris";
    QString pathFileToSave = pathDir + m_source;

    if (whereToSave != "") {
        pathFileToSave = whereToSave;
    }

    compressMapOfInformation();
    FileIO::writeConfigurationFile(pathConfigurationToLoad, pathFileToSave, m_mapOfInformation);
    saveLocalCurrentConfiguration();
}

/**
 * @brief "Exports" in GiD format the current Study Case into a certain location.
 *
 * What it really does is it copies the temporary files already created by
 * MATfem into the location given.
 *
 * @param whereToSave Path in where to export the files in GiD format
 * @return Whether the exportation succeed or not
 */
bool StudyCase::exportToGid(const QString& whereToSave) {

    QString dir(Configure::read("fileApplicationDirPath"));

    FileIO baseFile(dir + "temp/currentMatFemFile.m");
    FileIO exportedFile(whereToSave);

    bool success = exportedFile.write(baseFile.read());

    if (!success) {
        return false;
    }

    // Exports also the files .rsh y .msh
    baseFile.setSource(dir + "temp/currentMatFemFile.flavia.res");
    exportedFile.setSource(whereToSave.left(whereToSave.length() - 2) + ".flavia.res");

    success = exportedFile.write(baseFile.read());

    if (!success) {
        return false;
    }

    baseFile.setSource(dir + "temp/currentMatFemFile.flavia.msh");
    exportedFile.setSource(whereToSave.left(whereToSave.length() - 2) + ".flavia.msh");

    return exportedFile.write(baseFile.read());
}

/**
 * @brief Sets the initial values of the Study Case.
 *
 * Clears the previous stored values, and set the "default" ones. It uses
 * the default values granted by the subclasses StudyCaseHeat and StudyCaseStructural.
 * At the end, saves all the compressed values into a file.
 *
 * @see setLocalMapOfInformation()
 * @see compressMapOfInformation()
 *
 */
void StudyCase::setInitialMapOfInformation() {

    m_mapOfInformation.clear();
    m_extraInformation.clear();

    m_mapOfInformation["typeOfStudyCase"]        = "false";
    m_mapOfInformation["exampleName"]            = "false";
    m_mapOfInformation["stepOfProcess"]          = "1";

    m_mapOfInformation["gridHeight"]             = "1";
    m_mapOfInformation["gridWidth"]              = "1";

    m_mapOfInformation["created"]                = m_created.toString();
    m_mapOfInformation["modified"]               = m_modified.toString();

    setLocalMapOfInformation();

    m_mapOfInformation["coordinates"]           = "coordinates = [\r\n];" ;
    m_mapOfInformation["elements"]              = "elements = [\r\n];" ;
    m_mapOfInformation["fixnodes"]              = "fixnodes = [\r\n];" ;
    m_mapOfInformation["pointload"]             = "pointload = [\r\n];" ;
    m_mapOfInformation["sideload"]              = "sideload = [\r\n];" ;

    m_mapOfInformation["extraInformation"]      = "";

    compressMapOfInformation();
}

/**
 * @brief Compress the stored values in the QMap of the StudyCase and saves them.
 *
 * Using the `BASE64` encoding, saves all the stored values into a separated file,
 * and also in the `.femris` file.
 */
void StudyCase::compressMapOfInformation() {

    // First we encode the extraInformation (so it can be saved later in the file)
    m_mapOfInformation["extraInformation"] = Utils::qMapToString(m_extraInformation);

    // Then we encode the map of information
    m_mapOfInformation["encoded"] = Utils::qMapToString(m_mapOfInformation);
}

/**
 * @brief Checks if the Study Case is ready to be processed by MATfem
 * @param failedRule Which field failed first
 * @param failedRule Which rule failed first
 * @return Whether is ready or not
 */
bool StudyCase::isReady(QString &failedField, QString &failedRule) {

    bool isReady = false;

    QMapIterator<QString, Validator> i(m_validates);

    while (i.hasNext()) {
        i.next();

        isReady = i.value().validate(m_mapOfInformation[i.key()], failedRule);

        if (isReady == false) {
            failedField = i.key();
            break;
        }
    }

    return isReady;
}

/**
 * @brief Checks if a rule is being passed or not
 * @param rule The rule to be check
 * @param currentValue The value for comparison
 * @return True if passed, false otherwise
 */
bool StudyCase::checkRule(const QString rule, const QString currentValue, QString &failedRule) {
    return m_validates[rule].validate(currentValue, failedRule);
}

/**
 * @brief Returns the message associated with a certain rule
 * @param rule The rule we are looking for
 * @return The related message
 */
QString StudyCase::getRuleMessage(const QString rule, const QString failedRule) {
    return m_validates[rule].getRuleMessage(failedRule);
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

/**
 * @brief Gets the current QMap which stores all the information of the Study Case
 * @return The QMap
 */
QMap<QString, QString> StudyCase::getMapOfInformation() {
    return m_mapOfInformation;
}

/**
 * @brief Sets the new QMap which will store all the information of the Study Case
 * @param newMapOfInformation New QMap for the Study Case
 */
void StudyCase::setMapOfInformation(QMap<QString, QString> newMapOfInformation) {
    m_mapOfInformation = newMapOfInformation;
}

/**
 * @brief Sets the QMap which will store all the extra information of the Study Case
 * @param newMapOfInformation QMap with the new extra information about the SC
 */
void StudyCase::setExtraInformation(QMap<QString, QString> newExtraInformation) {
    m_extraInformation = newExtraInformation;
}

//----------------------------------------------------------------------------//
//--                                VIRTUAL                                 --//
//----------------------------------------------------------------------------//

//! @fn bool StudyCase::checkIfReady()
//! @brief Check if it's ready to be processed in MATfem

//! @fn void StudyCase::setLocalMapOfInformation()
//! @brief Complement of StudyCase::setInitialMapOfInformation()

//! @fn void StudyCase::saveLocalCurrentConfiguration()
//! @brief Complement of StudyCase::saveCurrentConfiguration()
