#include "studycase.h"

#include "fileio.h"

void StudyCase::createNew() {

    m_fileTitle             = "";

    m_youngModulus          = 0 ;
    m_poissonCoefficient    = 0 ;
    m_densityOfDomain       = 0 ;
    m_thickOfDomain         = 0 ;

    m_typeOfProblem         = 0 ;

    m_coordinates           =   new arma::mat();
    m_elements              =   new arma::mat();
    m_fixnodes              =   new arma::mat();
    m_pointload             =   new arma::mat();
    m_sideload              =   new arma::mat();

    m_created = QDateTime::currentDateTime();
    m_modified = m_created;

    m_source = "/temp/" + m_created.toString("yyyyMMdd-hhmmss") + ".femris.old";

    saveCurrentConfiguration();

}

void StudyCase::saveCurrentConfiguration() {
    FileIO::writeConfigurationFile("base", m_source, createMapForReplacementInConfiguration());
}

QMap<QString, QString> StudyCase::createMapForReplacementInConfiguration() {

    QMap<QString, QString> mapReplacement;

    mapReplacement["FILE_TITLE"]            = m_fileTitle;

    mapReplacement["CREATED"]               = m_created.toString();
    mapReplacement["MODIFIED"]              = m_modified.toString();

    mapReplacement["YOUNG_MODULUS"]         = QString::number(m_youngModulus);
    mapReplacement["POISSON_COEFFICIENT"]   = QString::number(m_poissonCoefficient);
    mapReplacement["DENSITY_OF_DOMAIN"]     = QString::number(m_densityOfDomain);
    mapReplacement["TYPE_OF_PROBLEM"]       = QString::number(m_typeOfProblem);
    mapReplacement["THICK_OF_DOMAIN"]       = QString::number(m_thickOfDomain);

    mapReplacement["COORDINATES"]           = matToQString(*m_coordinates, "coordinates");
    mapReplacement["ELEMENTS"]              = matToQString(*m_elements, "elements");
    mapReplacement["FIXNODES"]              = matToQString(*m_fixnodes, "fixnodes");
    mapReplacement["POINTLOAD"]             = matToQString(*m_pointload, "pointload");
    mapReplacement["SIDELOAD"]              = matToQString(*m_sideload, "sideload");

    return mapReplacement;
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
