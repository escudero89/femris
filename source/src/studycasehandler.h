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

    Q_INVOKABLE bool createNewStudyCase();

    Q_INVOKABLE QString getSingleStudyCaseInformation(const QString&);
    Q_INVOKABLE void setSingleStudyCaseInformation(const QString&, const QString&);

    Q_INVOKABLE QString saveAndContinue(const QString&);

signals:

public slots:

private:

    bool saveAndContinueHelper(const QString&, const QString&, const unsigned int&, const unsigned int&);

    StudyCase *m_studyCase;

    QMap<QString, QString> m_currentStudyCaseVariables;
};

#endif // STUDYCASEHANDLER_H
