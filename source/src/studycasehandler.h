#ifndef STUDYCASEHANDLER_H
#define STUDYCASEHANDLER_H

#include <QObject>

#include "studycase.h"

class StudyCaseHandler : public QObject
{
    Q_OBJECT
public:
    StudyCaseHandler();

    Q_INVOKABLE bool createNewStudyCase();

signals:

public slots:

private:

    StudyCase *m_studyCase;
};

#endif // STUDYCASEHANDLER_H
