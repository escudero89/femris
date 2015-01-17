#ifndef STUDYCASEHANDLER_H
#define STUDYCASEHANDLER_H

#include <QObject>

#include "studycase.h"
#include "studycasestructural.h"
#include "studycaseheat.h"

class StudyCaseHandler : public QObject
{
    Q_OBJECT

public:
    StudyCaseHandler();
    ~StudyCaseHandler();

    Q_INVOKABLE void start();
    Q_INVOKABLE bool exists();

    Q_INVOKABLE void selectNewTypeStudyCase(const QString&);
    Q_INVOKABLE void adoptNewTypeStudyCaseIfNecessary();
    Q_INVOKABLE void createNewStudyCase();
    Q_INVOKABLE void createDomainFromScriptFile();

    Q_INVOKABLE void saveCurrentStudyCase(QString);
    Q_INVOKABLE bool exportCurrentStudyCase(QString);
    Q_INVOKABLE bool loadStudyCase(const QString&);

    Q_INVOKABLE bool checkSingleStudyCaseInformation(const QString&);
    Q_INVOKABLE bool checkSingleStudyCaseInformation(const QString&, const QString&);
    Q_INVOKABLE QString getSingleStudyCaseInformation(const QString&, bool = false);

    Q_INVOKABLE void setSingleStudyCaseInformation(const QString&, const QString &, bool = false);
    Q_INVOKABLE void setSingleStudyCaseJson(const QString&, const QJsonArray&);

    Q_INVOKABLE QString saveAndContinue(const QString&);

    Q_INVOKABLE void loadUrlInBrowser(QString, bool = false);

    Q_INVOKABLE bool getSavedStatus();
    Q_INVOKABLE void markAsNotSaved();
    Q_INVOKABLE QString getLastSavedPath();
    Q_INVOKABLE bool isStudyType(const QString&);
    Q_INVOKABLE void isReady();

public Q_SLOTS:

Q_SIGNALS:

    void newStudyCaseChose(const QString& studyCaseType);
    void newStudyCaseCreated();

    void loadingStart();
    void loadingDone();

    void loadingNewStudyCase();
    void savingCurrentStudyCase();

    void callProcess();

    void markedAsSaved();
    void markedAsNotSaved();

    void ready(const bool& status);

private:

    void markAsSaved();

    bool m_isSaved;
    QString m_lastSavedPath;

    QString setSingleStudyCaseJsonHelper(const QString&, const QJsonArray&);

    QString m_studyCaseType;
    StudyCase *m_studyCase;

    QMap<QString, QString> m_currentStudyCaseVariables;
    QMap<QString, QString> m_temporalStudyCaseVariables;
};

#endif // STUDYCASEHANDLER_H
