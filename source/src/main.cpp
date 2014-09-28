#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtQml>

#include "fileio.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    qmlRegisterType<FileIO, 1>("FileIO", 1, 0, "FileIO");

    return app.exec();
}
