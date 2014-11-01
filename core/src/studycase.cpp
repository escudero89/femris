#include "studycase.h"

#include <QApplication>
#include <QDebug>

#include "fileio.h"
//@TODO repensar el caso de estudio, ya que realmente no manejamos nada de matrices al final aca
// Todo se hace en MATFem
void StudyCase::createNew() {

    clear();
    setMapOfInformation();
    saveCurrentConfiguration();

}

StudyCase::clear() {

    m_fileTitle             = "";

    m_stepOfProcess         = 1 ;

    createLocalNew();

    m_coordinates           = new arma::mat();
    m_elements              = new arma::mat();
    m_fixnodes              = new arma::mat();
    m_pointload             = new arma::mat();
    m_sideload              = new arma::mat();

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

    m_mapOfInformation.clear();

}

StudyCase::~StudyCase() {
    delete m_coordinates;
    delete m_elements;
    delete m_fixnodes;
    delete m_pointload;
    delete m_sideload;
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

    m_mapOfInformation["coordinates"]           = matToQString(*m_coordinates, "coordinates");
    m_mapOfInformation["elements"]              = matToQString(*m_elements, "elements");
    m_mapOfInformation["fixnodes"]              = matToQString(*m_fixnodes, "fixnodes");
    m_mapOfInformation["pointload"]             = matToQString(*m_pointload, "pointload");
    m_mapOfInformation["sideload"]              = matToQString(*m_sideload, "sideload");

}

QString StudyCase::matToQString(arma::mat &matBase, const QString &name) {

    QString matQString = name;

    matQString += " = [\r\n";

    if (matBase.n_rows > 0 && matBase.n_cols > 0) {

        arma::mat::row_iterator firstRow = matBase.begin_row(1);
        arma::mat::row_iterator lastRow = matBase.end_row(matBase.n_rows);

        arma::mat::col_iterator firstColumn = matBase.begin_col(1);
        arma::mat::col_iterator lastColumn = matBase.end_col(matBase.n_cols);

        for (arma::mat::row_iterator i = firstRow ; i != lastRow ; i++ ) {
            for (arma::mat::col_iterator j = firstColumn ; j != lastColumn ; j++ ) {

                matQString += QString::number(*j);

                if (j + 1 != lastColumn) {
                     matQString += ", ";
                }

            }

            matQString += " ;\r\n";
        }

    }

    matQString += "];";

    return matQString;
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
