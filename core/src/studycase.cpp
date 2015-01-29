#include "studycase.h"
#include "utils.h"

#include <QApplication>
#include <QDebug>

#include "configure.h"
#include "fileio.h"

void StudyCase::createNew() {

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";
    m_encoded               = "";

    setInitialMapOfInformation();
    saveCurrentConfiguration();
}

StudyCase::~StudyCase() {
}
/**
 * @brief Loads configuration from a file into a QMap
 * @param whereToLoad
 * @return
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

    QString decodedInfo = Utils::base64_decode(encodedInfo);
    QStringList blocksOfInfo = decodedInfo.split(Utils::endSeparator, QString::SkipEmptyParts);
    QMap<QString, QString> newMapOfInformation;

    for (int i = 0; i < blocksOfInfo.size(); i++) {
        QStringList keyAndValue = blocksOfInfo.at(i).split(Utils::midSeparator);
        newMapOfInformation[ keyAndValue[0] ] = keyAndValue[1];
    }

    return newMapOfInformation;
}

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
 * @brief StudyCase::exportToGid
 * @param whereToSave
 * @return
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

void StudyCase::setInitialMapOfInformation() {

    m_mapOfInformation.clear();

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

    compressMapOfInformation();
}

void StudyCase::compressMapOfInformation() {
    QString encodedMap = "";

    QMapIterator<QString, QString> i(m_mapOfInformation);
    while (i.hasNext()) {
        i.next();

        if (i.key() == "encoded") {
            continue;
        }

        QString val = i.value().isEmpty() ? "false" : i.value();

        encodedMap += i.key() + Utils::midSeparator + val + Utils::endSeparator;
    }

    m_encoded = Utils::base64_encode(encodedMap);

    for ( int k = 1 ; k <= m_encoded.size() ; k++ ) {
        // Every 80 characters we put a breakline
        if (k%80 == 0) {
            m_encoded.insert(k - 1, "\r\n");
        }
    }

    m_mapOfInformation["encoded"] = m_encoded;
}

/**
 * @brief StudyCase::isReady
 * @return
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

QMap<QString, QString> StudyCase::getMapOfInformation() {
    return m_mapOfInformation;
}

void StudyCase::setMapOfInformation(QMap<QString, QString> newMapOfInformation) {
    m_mapOfInformation = newMapOfInformation;
}
