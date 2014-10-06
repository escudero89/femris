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
    virtual ~StudyCase();

    void createNew();
    void saveCurrentConfiguration();
    void setMapOfInformation();

    virtual void createLocalNew() {};
    virtual void setLocalMapOfInformation() {};
    virtual void saveLocalCurrentConfiguration() {};

    QString matToQString(arma::mat&, const QString &);

    // Getters and setters
    QMap<QString, QString> getMapOfInformation();
    void setMapOfInformation(const QMap<QString, QString> &);

protected:

    QString m_typeOfStudyCase;

    QString m_fileTitle;
    QString m_source;

    unsigned int m_stepOfProcess;

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

    QMap<QString, QString> m_mapOfInformation;
};

#endif // STUDYCASE_H
