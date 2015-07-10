#ifndef PROCESSHANDLER_H
#define PROCESSHANDLER_H

#include <QObject>

#include <QProcess>
#include "fileio.h"

/**
 * @brief This class handles the input/ouput of the interpreters
 *
 * It's in charge of the handling of the process related to the two interpreters
 * availables: MATLAB and GNU Octave. It manages their inputs and outputs, and
 * emits signals whenever there is a change in the status of the process.
 */
class ProcessHandler : public QObject {
    Q_OBJECT

public:
    ProcessHandler();
    ~ProcessHandler() {};

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

protected:

    //! Pointer to the interpreter's process
    QProcess* m_process;
    //! In which step of the process is (0: none, 1: writing, 2: reading, 3: exiting).
    unsigned int m_stepOfProcessManipulation;

};


#endif // PROCESSHANDLER_H
