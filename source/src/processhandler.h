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

private:

    QProcess m_process;
    bool m_writing = false;
};


#endif // PROCESSHANDLER_H
