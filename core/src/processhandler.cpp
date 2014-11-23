#include "processhandler.h"
#include "configure.h"
#include "utils.h"

#include <QObject>
#include <QDebug>
#include <QProcess>

#include <QStringList>

ProcessHandler::ProcessHandler() {
    connect(&m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(writingInProcess()));
    connect(&m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(readingInProcess()));
    connect(&m_process, SIGNAL(readChannelFinished()), this, SLOT(finishingProcess()));
    connect(&m_process, SIGNAL(finished(int)), this, SLOT(exitingProcess()));
    connect(&m_process, SIGNAL(error(QProcess::ProcessError)), this, SLOT(errorInProcess()));

    m_command = "ls";
}


void ProcessHandler::cppSlot(const QString &msg, const QString &amplitud, float freq = 1) {
    qDebug() << "Called the C++ slot with message:" << msg << " and " << amplitud;
    // GNUPLOT
    QProcess gnuplot;
    gnuplot.start("gnuplot", QIODevice::ReadWrite);

    if (!gnuplot.waitForStarted()) {
        qDebug() << "gnuplot no :c";
        qDebug() << gnuplot.errorString();

    } else {
        qDebug() << "gnuplot yeah!";
    }

    // NO OLVIDAR LOS SALTOS DE LINEA
    gnuplot.write("set term svg enhanced \n");
    gnuplot.write("set output 'temp/output_qt.svg' \n");
    //gnuplot.write("splot sin(x+y) lc rgb '#FF3030' \n");
    gnuplot.write("plot ");
    gnuplot.write(amplitud.toUtf8().constData());
    gnuplot.write("*sin(x*");
    QString str;
    str.setNum(freq);
    gnuplot.write(str.toUtf8().constData());
    gnuplot.write(") \n");
    // Cerramos
    gnuplot.closeWriteChannel();
    gnuplot.waitForBytesWritten();

    if (!gnuplot.waitForFinished(1000)) {
        qDebug() << "gnuplot crashing :c";

    } else {
        qDebug() << "gnuplot turning off...";
    }

    QByteArray result = gnuplot.readAll();
}

void ProcessHandler::callingProcess() {
    if (Configure::check("interpreter", "octave")) {
        callingOctave();
    } else if (Configure::check("interpreter", "matlab")) {
        callingMatlab();
    } else {
        Utils::throwErrorAndExit("ProcessHandler::callingProcess(): Unknown interpreter");
    }
}

void ProcessHandler::callingOctave() {

    m_process.start(Configure::read("octave"), QIODevice::ReadWrite);

    m_stepOfProcessManipulation = 0;

    emit proccessCalled();
}

void ProcessHandler::callingMatlab() {

    QStringList processArgs;

    processArgs << " -nojvm "          // start MATLAB without the JVM software
                << " -nodisplay "      // Start the Oracle® JVM™ software, but do not start the MATLAB desktop
                << " -nosplash ";      // does  not display the splash screen during startup

    m_process.start(Configure::read("matlab"), processArgs, QIODevice::ReadWrite);

    m_stepOfProcessManipulation = 0;

    emit proccessCalled();
}

void ProcessHandler::writingInProcess() {

    if (m_process.state() == QProcess::Running && m_stepOfProcessManipulation == 0) {

        m_stepOfProcessManipulation = 1;

        qDebug() << "writingInProcess... " << m_command;
        //m_command = "cd temp/; ls;  [xnode ielem] = domain([1:10]',[1:10]')";
        m_process.write(m_command.toUtf8().constData());
        m_process.closeWriteChannel();

        m_process.waitForBytesWritten();

        emit processWrote();
    }
}

void ProcessHandler::readingInProcess() {
    if (m_process.state() == QProcess::Running && m_stepOfProcessManipulation == 1) {

        QByteArray result = m_process.readAll();
        qDebug() << "Result: "  << result;

        emit resultMessage(result);
    }
}

void ProcessHandler::finishingProcess() {
    if (m_stepOfProcessManipulation == 1) {

        m_stepOfProcessManipulation = 2;

        qDebug() << "ProcessHandler::readingInProcess(): Closing process...";
        m_process.close();

        emit processRead();
    }
}

void ProcessHandler::exitingProcess() {
    if (m_stepOfProcessManipulation == 2) {
        m_stepOfProcessManipulation = 0;
        emit processFinished();
    }
}

void ProcessHandler::errorInProcess() {
    emit processWithError();
}

void ProcessHandler::kill() {
    m_process.kill();
    emit processWithError();
}

//----------------------------------------------------------------------------//
//--                          GETTER AND SETTERS                            --//
//----------------------------------------------------------------------------//

void ProcessHandler::setCommand(const QString& command) {
    m_command = command;
}