#include "processhandler.h"
#include "configure.h"
#include "utils.h"
#include "fileio.h"

#include <QObject>
#include <QDebug>
#include <QProcess>

#include <QStringList>

ProcessHandler::ProcessHandler() {
    m_command = "ls";
}

void ProcessHandler::callingProcess() {

    m_process = new QProcess();
    m_process->setProcessChannelMode(QProcess::MergedChannels);

    connect(m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(writingInProcess()));
    connect(m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(readingInProcess()));
    connect(m_process, SIGNAL(readChannelFinished()), this, SLOT(finishingProcess()));
    connect(m_process, SIGNAL(finished(int)), this, SLOT(exitingProcess()));
    connect(m_process, SIGNAL(error(QProcess::ProcessError)), this, SLOT(errorInProcess()));

    // We remove the previous file with the current output of the interpreter
    QString dir(Configure::read("fileApplicationDirPath"));
    FileIO previousCurrentMatFemFileJs(dir + "temp/currentMatFemFile.femris.js");
    previousCurrentMatFemFileJs.deleteFile();

    if (Configure::check("interpreter", "octave")) {
        callingOctave();
    } else if (Configure::check("interpreter", "matlab")) {
        callingMatlab();
    } else {
        Utils::throwErrorAndExit("ProcessHandler::callingProcess(): Unknown interpreter");
    }
}

void ProcessHandler::callingOctave() {

    QStringList processArgs;

    processArgs << "--interactive" << Configure::read("applicationDirPath") + "temp/fileForProcessingInterpreter_tmp.m";

    m_process->start(Configure::read("interpreterPath"), processArgs);

    m_stepOfProcessManipulation = 0;

    emit proccessCalled();
}

void ProcessHandler::callingMatlab() {

    QString runThisFile(Configure::read("applicationDirPath") + "temp/fileForProcessingInterpreter_tmp.m");
    QStringList processArgs;

    processArgs << "-nosplash"       // does  not display the splash screen during startup
                << "-nodesktop"       // use the current terminal for commands
                << "-r" << "run('" + runThisFile + "');";

    emit proccessCalled();

    m_process->start(Configure::read("interpreterPath"), processArgs);

    m_stepOfProcessManipulation = 0;

}

void ProcessHandler::writingInProcess() {

    if (m_process->state() == QProcess::Running && m_stepOfProcessManipulation == 0) {

        m_stepOfProcessManipulation = 1;

        m_process->closeWriteChannel();

        m_process->waitForBytesWritten();

        emit processWrote();
    }
}

void ProcessHandler::readingInProcess() {
    if (m_process->state() == QProcess::Running && m_stepOfProcessManipulation == 1) {

        QByteArray result = m_process->readAll();
        qDebug() << "Result: "  << result;

        emit resultMessage(result);

        if (QString(result).contains("EXIT_PROCESS")) {
            m_stepOfProcessManipulation = 2;
        }
    }
}

void ProcessHandler::finishingProcess() {

    if (m_stepOfProcessManipulation == 2) {

        m_stepOfProcessManipulation = 3;

        qDebug() << "ProcessHandler::finishingProcess(): Closing process...";

        emit processRead();
        exitingProcess();
    }
}

void ProcessHandler::exitingProcess() {

    // If we are in Windows usign matlab, we can't know the current state of the process
    // so, we enable the process anyways
    if (Configure::check("interpreter", "matlab") && Configure::check("OS", "windows")) {
        m_stepOfProcessManipulation = 3;
        emit processMatlabInWindows();
        return;
    }

    if (m_stepOfProcessManipulation == 3) {
        qDebug() << "ProcessHandler::exitingProcess(): Process finished.";

        m_stepOfProcessManipulation = 0;
        emit processFinished();
    }
}

void ProcessHandler::errorInProcess() {
    qDebug() << "ProcessHandler::errorInProcess: state[" << m_process->state() << "]";
    qDebug() << "ProcessHandler::errorInProcess(): " << m_process->errorString();
    emit processWithError();
}

void ProcessHandler::executeInterpreter(QString typeOfStudyCase) {

    QString dir(Configure::read("fileApplicationDirPath"));
    FileIO fileIO(dir + "temp/currentMatFemFile.m");

    m_currentMatFemFile = fileIO.read();

    m_currentMatFemFile += "\n  cd '" + Configure::read("applicationDirPath") + "'\n\n";

    if (typeOfStudyCase == "heat") {
        fileIO.setSource(dir + "scripts/MAT-fem/MATfemrisCal.m");

    } else if (typeOfStudyCase == "plane-stress" || typeOfStudyCase == "plane-strain") {
        fileIO.setSource(dir + "scripts/MAT-fem/MATfemris.m");

    } else {
        Utils::throwErrorAndExit("ProcessHandler::executeInterpreter(): typeOfStudyCase unkown - " + typeOfStudyCase);
    }

    m_currentMatFemFile += fileIO.read();

    fileIO.setSource(dir + "temp/fileForProcessingInterpreter_tmp.m");
    fileIO.write(m_currentMatFemFile);

    emit callingProcess();
}

void ProcessHandler::kill() {
    m_process->kill();

    m_stepOfProcessManipulation = 0;

    emit processWithError();
}
