#ifndef STUDYCASE_H
#define STUDYCASE_H

#include <QObject>
#include <QDateTime>
#include <QMap>

class StudyCase
{

public:

    StudyCase() {};
    virtual ~StudyCase();

    void createNew();

    bool loadConfiguration(const QString&);
    void saveCurrentConfiguration(const QString& = "");

    void setMapOfInformation();
    void compressMapOfInformation();

    virtual void createLocalNew() {};
    virtual void setLocalMapOfInformation() {};
    virtual void saveLocalCurrentConfiguration() {};

    // Getters and setters
    QMap<QString, QString> getMapOfInformation();
    void setMapOfInformation(const QMap<QString, QString> &);

protected:

    QString m_typeOfStudyCase;

    QString m_fileTitle;
    QString m_source;

    unsigned int m_stepOfProcess;

    double m_grid_height;
    double m_grid_width;

    double m_youngModulus;
    double m_poissonCoefficient;
    double m_densityOfDomain;
    double m_thickOfDomain;

    int m_typeOfProblem;

    QString m_coordinates;
    QString m_elements;
    QString m_fixnodes;
    QString m_pointload;
    QString m_sideload;

    QDateTime m_created;
    QDateTime m_modified;

    QMap<QString, QString> m_mapOfInformation;

    QString m_encoded;
};

#endif // STUDYCASE_H
