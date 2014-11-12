//====================================================================//
//  ----------------------------------------------------------------  //
//  |   ~ FEMRIS 1.0 ~ Finite Element Method leaRnIng Software ~   |  //
//  |                                                              |  //
//  |         Copyright (C) 2014-2015 | Cristian Escudero          |  //
//  |                                                              |  //
//  | This program is free software; you can redistribute it       |  //
//  | and/or modify it under the terms of the GNU Lesser General   |  //
//  | Public License (LGPL) as published by the Free Software      |  //
//  | Foundation; either version 2.1 of the License, or (at your   |  //
//  | option) any later version.                                   |  //
//  |                                                              |  //
//  | This program is distributed in the hope that it will be      |  //
//  | useful, but WITHOUT ANY WARRANTY; without even the implied   |  //
//  | warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      |  //
//  | PURPOSE. See the GNU Library General Public License for      |  //
//  | more details.                                                |  //
//  |                                                              |  //
//  | License File: http://www.gnu.org/licenses/lgpl.txt           |  //
//  ----------------------------------------------------------------  //
//====================================================================//

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include <QObject>
#include <QDebug>

#include "fileio.h"
#include "studycasehandler.h"
#include "processhandler.h"
#include "configure.h"

int main(int argc, char *argv[]) {

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");

    StudyCaseHandler studyCaseHandler;
    ProcessHandler processHandler;
    FileIO currentFileIO;

    // Configuration Class
    Configure *configure;
    configure = Configure::getInstance();
    configure->loadConfiguration(qApp->applicationDirPath() + "/settings.xml");

    QObject::connect(&studyCaseHandler, SIGNAL(callProcess()),
                     &processHandler, SLOT(callingMatlab()));

    // We make sure those instance are accessible from QML
    engine.rootContext()->setContextProperty("StudyCaseHandler", &studyCaseHandler);
    engine.rootContext()->setContextProperty("ProcessHandler", &processHandler);
    engine.rootContext()->setContextProperty("CurrentFileIO", &currentFileIO);
    engine.rootContext()->setContextProperty("Configure", configure);

    // A little fix for windows (file should have /// in Windows)
    QString applicationDirPath = qApp->applicationDirPath();

    if (applicationDirPath[0] != '/') {
        configure->write("OS", "windows");
        applicationDirPath = "/" + applicationDirPath;
    }

    Configure::write("fileApplicationDirPath", "file://" + applicationDirPath + "/");

    engine.rootContext()->setContextProperty("applicationDirPath", applicationDirPath);
    engine.rootContext()->setContextProperty("fileApplicationDirPath", "file://" + applicationDirPath);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QString link = "docs/ce_results.html";
    //QDesktopServices::openUrl(QUrl(link));

    return app.exec();

}
