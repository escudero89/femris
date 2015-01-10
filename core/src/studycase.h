#ifndef STUDYCASE_H
#define STUDYCASE_H

#include <QObject>
#include <QDateTime>
#include <QMap>

class StudyCase
{

public:

    StudyCase() {}
    virtual ~StudyCase();

    void createNew();

    QMap<QString, QString> loadConfiguration(const QString&);
    void saveCurrentConfiguration(const QString& = "");
    bool exportToGid(const QString&);

    void setInitialMapOfInformation();
    void compressMapOfInformation();

    bool isReady();
    virtual bool checkIfReady() { return false; }

    virtual void setLocalMapOfInformation() {}
    virtual void saveLocalCurrentConfiguration() {}

    // Getters and setters
    QMap<QString, QString> getMapOfInformation();
    void setMapOfInformation(QMap<QString, QString>);

protected:

    QString m_source;
    QString m_encoded;

    QDateTime m_created;
    QDateTime m_modified;

    QMap<QString, QString> m_mapOfInformation;

};

#endif // STUDYCASE_H
