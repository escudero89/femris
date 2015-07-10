#include "processhandler.h"
#include "configure.h"
#include "utils.h"
#include "fileio.h"

#include <QObject>
#include <QDebug>
#include <QProcess>

#include <QStringList>

ProcessHandler::ProcessHandler() {}

/**
 * @brief Executes the interpreter
 *
 * Before calling callingProcess(), creates a file `fileForProcessingInterpreter_tmp.m`
 * which contains all the information stored in `currentMatFemFile.m` and also
 * the script of MATfem. That way, this new file is used as an argument for the
 * interpreters to use as source.
 *
 * @param typeOfStudyCase Type of Study Case required to call whether MATfem or MATfemCal.
 */
void ProcessHandler::executeInterpreter(QString typeOfStudyCase) {

    QString dir(Configure::read("fileApplicationDirPath"));
    FileIO fileIO(dir + "temp/currentMatFemFile.m");

    QString currentMatFemFile = fileIO.read();

    currentMatFemFile += "\n  cd '" + Configure::read("applicationDirPath") + "'\n\n";

    if (typeOfStudyCase == "heat") {
        fileIO.setSource(dir + "scripts/MAT-fem/MATfemrisCal.m");

    } else if (typeOfStudyCase == "plane-stress" || typeOfStudyCase == "plane-strain") {
        fileIO.setSource(dir + "scripts/MAT-fem/MATfemris.m");

    } else {
        Utils::throwErrorAndExit("ProcessHandler::executeInterpreter(): typeOfStudyCase unkown - " + typeOfStudyCase);
    }

    currentMatFemFile += fileIO.read();

    fileIO.setSource(dir + "temp/fileForProcessingInterpreter_tmp.m");
    fileIO.write(currentMatFemFile);

    emit callingProcess();
}

/**
 * @brief Summons the binary program of MATLAB or GNU Octave and executes MATfem
 *
 * Checks in the configuration whether have to call MATLAB or GNU Octave. Connects
 * a signal to each step of the QProcess.
 *
 * @see writingInProcess()
 * @see readingInProcess()
 * @see finishingProcess()
 * @see exitingProcess()
 * @see errorInProcess()
 *
 * @see callingOctave()
 * @see callingMatlab()
 */
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

/**
 * @brief Executes GNU Octave and sends it the content of the fileForProcessingInterpreter_tmp.m
 *
 * @see executeInterpreter()
 */
void ProcessHandler::callingOctave() {

    QStringList processArgs;

    processArgs << "--interactive" << Configure::read("applicationDirPath") + "temp/fileForProcessingInterpreter_tmp.m";

    m_process->start(Configure::read("interpreterPath"), processArgs);

    m_stepOfProcessManipulation = 0;

    emit proccessCalled();
}

/**
 * @brief Executes MATLAB and sends it the content of the fileForProcessingInterpreter_tmp.m
 *
 * @see executeInterpreter()
 */
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

/**
 * @brief Waits until the writing channel finishes, and then emits processWrote().
 */
void ProcessHandler::writingInProcess() {

    if (m_process->state() == QProcess::Running && m_stepOfProcessManipulation == 0) {

        m_stepOfProcessManipulation = 1;

        m_process->closeWriteChannel();

        m_process->waitForBytesWritten();

        emit processWrote();
    }
}

/**
 * @brief Waits until the reading channel finishes, and then emits resultMessage().
 *
 * It doesn't work with MATLAB in Windows (we use a QML trick to let this done)
 */
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

/**
 * @brief Emits processRead() when the program is exiting its execution.
 */
void ProcessHandler::finishingProcess() {

    if (m_stepOfProcessManipulation == 2) {

        m_stepOfProcessManipulation = 3;

        qDebug() << "ProcessHandler::finishingProcess(): Closing process...";

        emit processRead();
        exitingProcess();
    }
}

/**
 * @brief It's called when the program finished its execution. Emits processFinished().
 *
 * We make a exception for MATLAB in Windows. In such case, we emit
 * processMatlabInWindows() instead.
 */
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

/**
 * @brief If there were any errors during the execution, this function is called and emits
 * processWithError().
 */
void ProcessHandler::errorInProcess() {
    qDebug() << "ProcessHandler::errorInProcess: state[" << m_process->state() << "]";
    qDebug() << "ProcessHandler::errorInProcess(): " << m_process->errorString();
    emit processWithError();
}

/**
 * @brief Forces the detention of the current process, and emits processWithError().
 */
void ProcessHandler::kill() {
    m_process->kill();
    m_stepOfProcessManipulation = 0;

    emit processWithError();
}

//----------------------------------------------------------------------------//
//--                                SIGNALS                                 --//
//----------------------------------------------------------------------------//

//! @fn void ProcessHandler::proccessCalled()
//! @brief The process being called.

//! @fn void ProcessHandler::processWrote()
//! @brief The writing channel is being used by the process.

//! @fn void ProcessHandler::processRead()
//! @brief The reading channel is being used by the process.

//! @fn void ProcessHandler::processFinished()
//! @brief The process has finished.

//! @fn void ProcessHandler::processWithError()
//! @brief The process finished with errors.

//! @fn void ProcessHandler::processMatlabInWindows()
//! @brief The process is MATLAB and is being called in Windows.

//! @fn void ProcessHandler::resultMessage(const QString &msg)
//! @brief Contains the content of the reading channel. It's later used on QML.
