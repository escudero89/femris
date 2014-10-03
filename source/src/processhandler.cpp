#include "processhandler.h"

#include <QObject>
#include <QDebug>
#include <QProcess>

/*
ProcessHandler::ProcessHandler(QObject *parent) :
    QObject(parent)
{
}
*/

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

void ProcessHandler::invokingOctave(float amplitud = 1) {
    QProcess octave;
    octave.start("octave --silent", QIODevice::ReadWrite);

    if (!octave.waitForStarted()) {
        qDebug() << "octave no :c";
        qDebug() << octave.errorString();

    } else {
        qDebug() << "octave yeah!";
    }

    // Nos paramos en el directorio y ejecutamos la funcion
    QString str;
    str.setNum(amplitud);
    QString message  = QString("cd temp; testing(%1);").arg(str);
    octave.write(message.toUtf8().constData());
    // Cerramos
    octave.closeWriteChannel();
    octave.waitForBytesWritten();

    if (!octave.waitForFinished(3000)) {
        qDebug() << "octave crashing :c";

    } else {
        qDebug() << "octave turning off...";
    }

    QByteArray result = octave.readAll();
    qDebug() << result;
}
