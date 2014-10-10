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

int main(int argc, char *argv[]) {

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");

    StudyCaseHandler studyCaseHandler;
    ProcessHandler processHandler;
    FileIO currentFileIO;

    QObject::connect(&studyCaseHandler, SIGNAL(callProcess()),
                     &processHandler, SLOT(callingMatlab()));

    // We make the StudyCaseHandler instance accessible from QML
    engine.rootContext()->setContextProperty("StudyCaseHandler", &studyCaseHandler);
    engine.rootContext()->setContextProperty("ProcessHandler", &processHandler);
    engine.rootContext()->setContextProperty("CurrentFileIO", &currentFileIO);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();

}
