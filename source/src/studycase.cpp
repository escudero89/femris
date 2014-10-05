#include "studycase.h"

#include "fileio.h"

void StudyCase::createNew() {

    m_fileTitle             = "";

    m_stepOfProcess         = 0 ;

    m_youngModulus          = 0 ;
    m_poissonCoefficient    = 0 ;
    m_densityOfDomain       = 0 ;
    m_thickOfDomain         = 0 ;

    m_typeOfProblem         = 0 ;

    m_coordinates           = new arma::mat();
    m_elements              = new arma::mat();
    m_fixnodes              = new arma::mat();
    m_pointload             = new arma::mat();
    m_sideload              = new arma::mat();

    m_created               = QDateTime::currentDateTime();
    m_modified              = m_created;

    m_source                = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

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
    setMapOfInformation();
    QMap<QString, QString> empty = m_mapOfInformation;
    FileIO::writeConfigurationFile("base", m_source, empty);
}

void StudyCase::setMapOfInformation() {

    m_mapOfInformation.clear();

    m_mapOfInformation["stepOfProcess"]            = m_fileTitle;
    m_mapOfInformation["created"]       = QString::number(m_stepOfProcess);

    m_mapOfInformation["modified"]               = m_created.toString();
    m_mapOfInformation["fileTitle"]              = m_modified.toString();

    m_mapOfInformation["youngModulus"]         = QString::number(m_youngModulus);
    m_mapOfInformation["poissonCoefficient"]   = QString::number(m_poissonCoefficient);
    m_mapOfInformation["densityOfDomain"]     = QString::number(m_densityOfDomain);
    m_mapOfInformation["typeOfProblem"]       = QString::number(m_typeOfProblem);
    m_mapOfInformation["thickOfDomain"]       = QString::number(m_thickOfDomain);

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

