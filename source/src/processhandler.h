#ifndef PROCESSHANDLER_H
#define PROCESSHANDLER_H

#include <QObject>
#include <QDebug>

#include <QProcess>

class ProcessHandler : public QObject
{
    Q_OBJECT

public:
    ProcessHandler();
    ~ProcessHandler() {};

    void cppSlot(const QString &, const QString &, float);
    static void invokingOctave(const QString&);

public Q_SLOTS:

    void callingMatlab();
    void writingInProcess();
    void readingInProcess();
    void finishingProcess();

Q_SIGNALS:

    void proccessCalled();
    void processWrote();
    void processRead();
    void processFinished();

private:

    QProcess m_process;
    unsigned int m_stepOfProcessManipulation;
};


#endif // PROCESSHANDLER_H
