#include "studycase.h"

#include <QApplication>
#include <QDebug>

#include "fileio.h"
//@TODO repensar el caso de estudio, ya que realmente no manejamos nada de matrices al final aca
// Todo se hace en MATFem
void StudyCase::createNew() {

    m_fileTitle             = "";

    m_stepOfProcess         = 1 ;

    createLocalNew();

    m_coordinates           = "coordinates = [\r\n];" ;
    m_elements              = "elements    = [\r\n];" ;
    m_fixnodes              = "fixnodes    = [\r\n];" ;
    m_pointload             = "pointload   = [\r\n];" ;
    m_sideload              = "sideload    = [\r\n];" ;

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

    setMapOfInformation();
    saveCurrentConfiguration();

}

StudyCase::~StudyCase() {
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

    m_mapOfInformation["created"]                = m_created.toString();
    m_mapOfInformation["modified"]               = m_modified.toString();

    setLocalMapOfInformation();

    m_mapOfInformation["coordinates"]           = m_coordinates;
    m_mapOfInformation["elements"]              = m_elements;
    m_mapOfInformation["fixnodes"]              = m_fixnodes;
    m_mapOfInformation["pointload"]             = m_pointload;
    m_mapOfInformation["sideload"]              = m_sideload;

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
