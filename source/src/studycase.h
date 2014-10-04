#ifndef STUDYCASE_H
#define STUDYCASE_H

#include <QObject>
#include <QDateTime>
#include <QMap>

#include <armadillo>

class StudyCase
{

public:

    StudyCase() {};

    void createNew();
    void saveCurrentConfiguration();

    QMap<QString, QString> createMapForReplacementInConfiguration();

    QString matToQString(arma::mat&, const QString &);

private:

    QString m_fileTitle;
    QString m_source;

    double m_youngModulus;
    double m_poissonCoefficient;
    double m_densityOfDomain;
    double m_thickOfDomain;

    int m_typeOfProblem;

    arma::mat *m_coordinates;
    arma::mat *m_elements;
    arma::mat *m_fixnodes;
    arma::mat *m_pointload;
    arma::mat *m_sideload;

    QDateTime m_created;
    QDateTime m_modified;
};

#endif // STUDYCASE_H
