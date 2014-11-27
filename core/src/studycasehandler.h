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

    Q_INVOKABLE void start();
    Q_INVOKABLE bool exists();

    Q_INVOKABLE void selectNewTypeStudyCase(const QString&);
    Q_INVOKABLE void createNewStudyCase();
    Q_INVOKABLE void createDomainFromScriptFile();

    Q_INVOKABLE void saveCurrentStudyCase(const QString&);
    Q_INVOKABLE bool loadStudyCase(const QString&);

    Q_INVOKABLE bool checkSingleStudyCaseInformation(const QString&);
    Q_INVOKABLE QString getSingleStudyCaseInformation(const QString&, bool = false);

    Q_INVOKABLE void setSingleStudyCaseInformation(const QString&, const QString &, bool = false);
    Q_INVOKABLE void setSingleStudyCaseJson(const QString&, const QJsonArray&, bool = false);

    Q_INVOKABLE QString saveAndContinue(const QString&);

    Q_INVOKABLE void loadUrlInBrowser(QString, bool = false);

    Q_INVOKABLE bool savedStatus();
    void markAsSaved();
    void markAsNotSaved();

public Q_SLOTS:

Q_SIGNALS:

    void newStudyCaseChose(const QString& studyCaseType);
    void newStudyCaseCreated();

    void loadingStart();
    void loadingDone();

    void callProcess();

private:

    bool m_isSaved;

    QString setSingleStudyCaseJsonHelper(const QString&, const QJsonArray&);
    bool saveAndContinueHelper(const QString&, const QString&, const unsigned int&, const unsigned int&);

    QString m_studyCaseType;
    StudyCase *m_studyCase;

    QMap<QString, QString> m_currentStudyCaseVariables;
    QMap<QString, QString> m_temporalStudyCaseVariables;
};

#endif // STUDYCASEHANDLER_H
