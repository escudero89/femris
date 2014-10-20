#ifndef STUDYCASEHANDLER_H
#define STUDYCASEHANDLER_H

#include <QObject>

#include "studycase.h"
#include "studycasestructural.h"

class StudyCaseHandler : public QObject
{
    Q_OBJECT

public:
    StudyCaseHandler();
    ~StudyCaseHandler();

    Q_INVOKABLE void selectNewTypeStudyCase(const QString&);
    Q_INVOKABLE void createNewStudyCase();
    Q_INVOKABLE bool createDomainFromScriptFile();

    Q_INVOKABLE QString getSingleStudyCaseInformation(const QString&);
    void setSingleStudyCaseInformation(const QString&, const QString&);

    Q_INVOKABLE QString saveAndContinue(const QString&);

public Q_SLOTS:

Q_SIGNALS:

    void newStudyCaseChose(const QString& studyCaseType);

    void loadingStart();
    void loadingDone();

    void callProcess();

private:

    bool saveAndContinueHelper(const QString&, const QString&, const unsigned int&, const unsigned int&);

    QString m_studyCaseType;
    StudyCase *m_studyCase;

    QMap<QString, QString> m_currentStudyCaseVariables;
};

#endif // STUDYCASEHANDLER_H
