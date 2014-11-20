#include "studycase.h"
#include "utils.h"

#include <QApplication>
#include <QDebug>

#include "fileio.h"
//@TODO repensar el caso de estudio, ya que realmente no manejamos nada de matrices al final aca
// Todo se hace en MATFem
void StudyCase::createNew() {

    m_fileTitle             = "";

    m_stepOfProcess         = 1 ;

    m_grid_height           = 1 ;
    m_grid_width            = 1 ;

    createLocalNew();

    m_coordinates           = "coordinates = [\r\n];" ;
    m_elements              = "elements    = [\r\n];" ;
    m_fixnodes              = "fixnodes    = [\r\n];" ;
    m_pointload             = "pointload   = [\r\n];" ;
    m_sideload              = "sideload    = [\r\n];" ;

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

    m_encoded               = "";

    setMapOfInformation();
    saveCurrentConfiguration();

}

StudyCase::~StudyCase() {
}

bool StudyCase::loadConfiguration(const QString& whereToLoad) {
    QStringList configurationFilter;
    configurationFilter << "Base64-encode";
    if (!FileIO::splitConfigurationFile("currentEnconding.base64", whereToLoad, configurationFilter, true)) {
        return false;
    }

    FileIO encodedFileStudyCase("temp/currentEnconding.base64");
    QString encodedInfo = encodedFileStudyCase.read();

    // We remove all the breaklines, and then we decode
    encodedInfo.replace("\r\n", "");
    encodedInfo.replace("\n", "");

    qDebug() << Utils::base64_decode(encodedInfo);
//@TODO obtener con regex los {{key}}:{{value}} y cargarlos en el studycase
    return true;
}

void StudyCase::saveCurrentConfiguration(const QString& whereToSave) {

    QString pathDir = qApp->applicationDirPath();

    QString pathConfigurationToLoad = pathDir + "/scripts/base.femris";
    QString pathFileToSave = pathDir + m_source;

    if (whereToSave != "") {
        pathFileToSave = whereToSave;
    }

    FileIO::writeConfigurationFile(pathConfigurationToLoad, pathFileToSave, m_mapOfInformation);
    saveLocalCurrentConfiguration();
}

void StudyCase::setMapOfInformation() {

    m_mapOfInformation.clear();

    m_mapOfInformation["typeOfStudyCase"]        = m_typeOfStudyCase;
    m_mapOfInformation["fileTitle"]              = m_fileTitle;
    m_mapOfInformation["stepOfProcess"]          = QString::number(m_stepOfProcess);

    m_mapOfInformation["gridHeight"]             = QString::number(m_grid_height);
    m_mapOfInformation["gridWidth"]              = QString::number(m_grid_width);

    m_mapOfInformation["created"]                = m_created.toString();
    m_mapOfInformation["modified"]               = m_modified.toString();

    setLocalMapOfInformation();

    m_mapOfInformation["coordinates"]           = m_coordinates;
    m_mapOfInformation["elements"]              = m_elements;
    m_mapOfInformation["fixnodes"]              = m_fixnodes;
    m_mapOfInformation["pointload"]             = m_pointload;
    m_mapOfInformation["sideload"]              = m_sideload;

    compressMapOfInformation();
    m_mapOfInformation["encoded"]               = m_encoded;
}

void StudyCase::compressMapOfInformation() {
    QString encodedMap = "";

    QMapIterator<QString, QString> i(m_mapOfInformation);
    while (i.hasNext()) {
        i.next();
        encodedMap += "{{" + i.key() + "}}:" + "{{" + i.value() + "}}\n";
    }

    m_encoded = Utils::base64_encode(encodedMap);

    for ( int k = 1 ; k <= m_encoded.size() ; k++ ) {
        // Every 80 characters we put a breakline
        if (k%80 == 0) {
            m_encoded.insert(k - 1, "\r\n");
        }
    }
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

QMap<QString, QString> StudyCase::getMapOfInformation() {
    return m_mapOfInformation;
}

void StudyCase::setMapOfInformation(const QMap<QString, QString> &newMapOfInformation) {
    m_mapOfInformation = newMapOfInformation;
}
