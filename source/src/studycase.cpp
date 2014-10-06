#include "studycase.h"

#include "fileio.h"

void StudyCase::createNew() {

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

    setMapOfInformation();
    saveCurrentConfiguration();

}

StudyCase::~StudyCase() {
    delete m_coordinates;
    delete m_elements;
    delete m_fixnodes;
    delete m_pointload;
    delete m_sideload;
}

void StudyCase::saveCurrentConfiguration() {
    FileIO::writeConfigurationFile("base", m_source, m_mapOfInformation);
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
