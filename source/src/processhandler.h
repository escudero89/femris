#ifndef PROCESSHANDLER_H
#define PROCESSHANDLER_H

#include <QObject>
#include <QDebug>

// Para procesar con gnuplot
#include <QProcess>

class ProcessHandler : public QObject {
    Q_OBJECT

  public:
    ProcessHandler() {};

  signals:

  public slots:

    void cppSlot(const QString &, const QString &, float);
    void invokingOctave(float);
};


#endif // PROCESSHANDLER_H
