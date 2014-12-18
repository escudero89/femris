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

    processArgs << "--interactive" << "temp/fileForProcessingInterpreter_tmp.m";

    m_process->start(Configure::read("interpreterPath"), processArgs);

    m_stepOfProcessManipulation = 0;

    emit proccessCalled();
}

void ProcessHandler::callingMatlab() {

    QStringList processArgs;

    processArgs << "-nosplash "       // does  not display the splash screen during startup
                << "-nodesktop"       // use the current terminal for commands
                << "-r \"run('temp/fileForProcessingInterpreter_tmp.m'); exit;\"";

    emit proccessCalled();

    m_process->start(Configure::read("interpreterPath"), processArgs);

    m_stepOfProcessManipulation = 0;

}

void ProcessHandler::writingInProcess() {

    if (m_process->state() == QProcess::Running && m_stepOfProcessManipulation == 0) {

        m_stepOfProcessManipulation = 1;

        qDebug() << "writingInProcess... " << m_command;

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
            finishingProcess();
        }
    }
}

void ProcessHandler::finishingProcess() {
    if (m_stepOfProcessManipulation == 1) {

        m_stepOfProcessManipulation = 2;

        qDebug() << "ProcessHandler::finishingProcess(): Closing process...";
        m_process->kill();

        emit processRead();
        exitingProcess();
    }
}

void ProcessHandler::exitingProcess() {
    if (m_stepOfProcessManipulation == 2) {

        qDebug() << "ProcessHandler::exitingProcess(): Process finished.";

        m_stepOfProcessManipulation = 0;
        emit processFinished();
    }
}

void ProcessHandler::errorInProcess() {
    qDebug() << "state for gosh sake: " << m_process->state();
    emit processWithError();
}

void ProcessHandler::executeInterpreter(QString typeOfStudyCase) {
//@TODO Modificar ToJS en base a GidCal. Revisar el terma de "Guardar" cuando se cierra un archivo.
    FileIO fileIO("temp/currentMatFemFile.m");
    m_currentMatFemFile = fileIO.read();

    if (typeOfStudyCase == "heat") {
        fileIO.setSource("scripts/MAT-fem/MATfemrisCal.m");

    } else if (typeOfStudyCase == "plane-stress" || typeOfStudyCase == "plane-strain") {
        fileIO.setSource("scripts/MAT-fem/MATfemris.m");

    } else {
        Utils::throwErrorAndExit("ProcessHandler::executeInterpreter(): typeOfStudyCase unkown - " + typeOfStudyCase);
    }

    m_currentMatFemFile += fileIO.read();

    fileIO.setSource("temp/fileForProcessingInterpreter_tmp.m");
    fileIO.write(m_currentMatFemFile);

    emit callingProcess();
}

void ProcessHandler::kill() {
    m_process->kill();

    m_stepOfProcessManipulation = 0;

    emit processWithError();
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

void ProcessHandler::setCommand(const QString& command) {
    m_command = command;
}
