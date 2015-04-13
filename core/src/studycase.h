#ifndef STUDYCASE_H
#define STUDYCASE_H

#include <QObject>
#include <QDateTime>
#include <QMap>

#include "validator.h"

/**
 * @brief The StudyCase stores the currently working study case, and all its variables
 *
 * The instances of the this class are handled by the StudyCaseHandler. As so,
 * this class just stores all the variables required to solve a Study Case, and
 * also to save and load `.femris` files.
 *
 * @see StudyCaseHeat
 * @see StudyCaseStructural
 * @see StudyCaseHandler
 *
 */
class StudyCase {

public:

    StudyCase();
    virtual ~StudyCase();

    void createNew();

    QMap<QString, QString> loadConfiguration(const QString&);
    void saveCurrentConfiguration(const QString& = "");
    bool exportToGid(const QString&);

    void setInitialMapOfInformation();
    void compressMapOfInformation();

    bool isReady(QString&, QString&);
    bool checkRule(const QString, const QString, QString&);
    QString getRuleMessage(const QString, const QString);

    virtual bool checkIfReady() { return false; }

    virtual void setLocalMapOfInformation() {}
    virtual void saveLocalCurrentConfiguration() {}

    QMap<QString, QString> getMapOfInformation();
    void setMapOfInformation(QMap<QString, QString>, QMap<QString, QString>);

protected:

    //! Path where the temporary file which stores the StudyCase is.
    QString m_source;

    QDateTime m_created;
    QDateTime m_modified;

    //! The QMap that stores almost all the information of the StudyCase
    QMap<QString, QString> m_mapOfInformation;

    //! As m_mapOfInformation, except that stores information that will be stored only encoded
    QMap<QString, QString> m_extraInformation;

    //! The validation rules for the Study Case are stored here
    QMap<QString, Validator> m_validates;

};

#endif // STUDYCASE_H
