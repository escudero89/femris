#ifndef PROCESSHANDLER_H
#define PROCESSHANDLER_H

#include <QObject>
#include <QDebug>

#include <QProcess>
#include "fileio.h"
class ProcessHandler : public QObject
{
    Q_OBJECT

public:
    ProcessHandler();
    ~ProcessHandler() {};

    void cppSlot(const QString &, const QString &, float);
    static void invokingOctave(const QString&);

    Q_INVOKABLE void executeInterpreter(QString);
    Q_INVOKABLE void kill();

public Q_SLOTS:

    void callingProcess();
    void callingOctave();
    void callingMatlab();

    void writingInProcess();
    void readingInProcess();
    void finishingProcess();
    void exitingProcess();
    void errorInProcess();

Q_SIGNALS:

    void proccessCalled();
    void processWrote();
    void processRead();
    void processFinished();
    void processWithError();

    void processMatlabInWindows();

    void resultMessage(const QString &msg);

private:
    QProcess* m_process;
    unsigned int m_stepOfProcessManipulation;

    QString m_command;
    QString m_currentMatFemFile;
};


#endif // PROCESSHANDLER_H
