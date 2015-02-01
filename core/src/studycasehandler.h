#ifndef STUDYCASEHANDLER_H
#define STUDYCASEHANDLER_H

#include <QObject>

#include "studycase.h"
#include "studycasestructural.h"
#include "studycaseheat.h"

/**
 * @brief Main class that handles all the interactions with the StudyCase
 */
class StudyCaseHandler : public QObject
{
    Q_OBJECT

public:
    StudyCaseHandler();
    ~StudyCaseHandler() {}

    Q_INVOKABLE void start();
    Q_INVOKABLE bool exists();

    Q_INVOKABLE void selectNewTypeStudyCase(const QString&);
    Q_INVOKABLE void adoptNewTypeStudyCaseIfNecessary();
    Q_INVOKABLE void createNewStudyCase();

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

    void loadingNewStudyCase();
    void savingCurrentStudyCase();

    void markedAsSaved();
    void markedAsNotSaved();

    void beforeCheckIfReady();
    void ready(const bool& status);

protected:

    void markAsSaved();
    QString setSingleStudyCaseJsonHelper(const QString&, const QJsonArray&);

    //! Whether is already saved in an external file or not
    bool m_isSaved;
    //! The current location of the saved file (empty if it doesn't exists)
    QString m_lastSavedPath;

    //! Type of Study Case that is being handled
    QString m_studyCaseType;
    //! The current Study Case that is being handled
    StudyCase *m_studyCase;

    //! A QMap that stores almost the same as the current Study Case
    QMap<QString, QString> m_currentStudyCaseVariables;
    //! A temporary QMap that only stores variables which are not going to be saved
    QMap<QString, QString> m_temporalStudyCaseVariables;
};

#endif // STUDYCASEHANDLER_H
