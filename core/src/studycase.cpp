#include "studycase.h"
#include "utils.h"

#include <QApplication>
#include <QDebug>

#include "configure.h"
#include "fileio.h"

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
 * @return Whether is ready or not
 */
bool StudyCase::isReady() {

    bool isReady = checkIfReady();

    if ( (!isReady) ||
         ( (m_mapOfInformation["gridHeight"].toDouble()) == 0.0 ||
           (m_mapOfInformation["gridWidth"].toDouble())  == 0.0 ) ) {

        return false;
    }

    // We need at least some values in the fixnodes
    isReady = !m_mapOfInformation["fixnodes"].contains("fixnodes = [\r\n];");

    return isReady;
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
 * @param newExtraInformation New QMap with extra information about the StudyCase
 */
void StudyCase::setMapOfInformation(
        QMap<QString, QString> newMapOfInformation,
        QMap<QString, QString> newExtraInformation) {

    m_mapOfInformation = newMapOfInformation;
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
