#include "studycase.h"

void StudyCase::createNew() {

    m_fileTitle             = "";

    m_youngModulus          = 0 ;
    m_poissonCoefficient    = 0 ;
    m_densityOfDomain       = 0 ;
    m_thickOfDomain         = 0 ;

    m_typeOfProblem         = 0 ;

    m_created = QDateTime::currentDateTime();
    m_modified = m_created;

    m_source = "/temp/" + QString(m_created.toTime_t()) + ".femris.old";

    m_coordinates           =   new arma::mat();
    m_elements              =   new arma::mat();
    m_fixnodes              =   new arma::mat();
    m_pointload             =   new arma::mat();
    m_sideload              =   new arma::mat();
}

QMap<QString, QString> StudyCase::createMapForReplacementInConfiguration() {

    QMap<QString, QString> mapReplacement;

    mapReplacement["FILE_TITLE"]            = m_fileTitle;

    mapReplacement["CREATED"]               = m_created.toString();
    mapReplacement["MODIFIED"]              = m_modified.toString();

    mapReplacement["YOUNG_MODULUS"]         = m_youngModulus;
    mapReplacement["POISSON_COEFFICIENT"]   = m_poissonCoefficient;
    mapReplacement["DENSITY_OF_DOMAIN"]     = m_densityOfDomain;
    mapReplacement["TYPE_OF_PROBLEM"]       = m_typeOfProblem;
    mapReplacement["THICK_OF_DOMAIN"]       = m_thickOfDomain;

    mapReplacement["COORDINATES"]           = matToQString(*m_coordinates, "coordinates");
    mapReplacement["ELEMENTS"]              = matToQString(*m_elements, "elements");
    mapReplacement["FIXNODES"]              = matToQString(*m_fixnodes, "fixnodes");
    mapReplacement["POINTLOAD"]             = matToQString(*m_pointload, "pointload");
    mapReplacement["SIDELOAD"]              = matToQString(*m_sideload, "sideload");

    return mapReplacement;
}

QString StudyCase::matToQString(arma::mat &matBase, const QString &name) {

    QString matQString = name;

    matQString += " = [\n\r";

    arma::mat::row_iterator firstRow = matBase.begin_row(1);
    arma::mat::row_iterator lastRow = matBase.end_row(matBase.n_rows);

    arma::mat::col_iterator firstColumn = matBase.begin_col(1);
    arma::mat::col_iterator lastColumn = matBase.end_col(matBase.n_cols);

    for (arma::mat::row_iterator i = firstRow ; i != lastRow ; i++ ) {
        for (arma::mat::col_iterator j = firstColumn ; j != lastColumn ; j++ ) {
            if (j + 1 != lastColumn) {
                matQString += QString::number(*j) + ", ";
            } else {
                matQString += QString::number(*j);
            }
        }
        matQString += " ;\n\r";
    }

    matQString += "];";

    return matQString;
}
