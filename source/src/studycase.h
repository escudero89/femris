#ifndef STUDYCASE_H
#define STUDYCASE_H

#include <QObject>

#include <armadillo>

class StudyCase : public QObject
{
    Q_OBJECT
public:
    explicit StudyCase(QObject *parent = 0);

signals:

public slots:

private:

    double m_youngModulus;
    double m_poissonCoefficient;
    double m_densityOfDomain;
    double m_thickOfDomain;

    int m_typeOfProblem;

    arma::mat m_coordinates;
    arma::mat m_elements;
    arma::mat m_fixnodes;
    arma::mat m_pointload;
    arma::mat m_sideload;
};

#endif // STUDYCASE_H
