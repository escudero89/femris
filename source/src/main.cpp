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

#include <QDebug>

#include "fileio.h"
#include "studycasehandler.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");


    StudyCaseHandler studyCaseHandler;

    QMap<QString, QString> replacement;
    replacement["YOUNG_MODULUS"] = "210000000000";
    replacement["POISSON_COEFF"] = "0.2";
    replacement["DENSITY_OF_DOMAIN"] = "78000";
    replacement["TYPE_OF_PROBLEM"] = "1";
    replacement["THICK_OF_DOMAIN"] = "0.1";

    FileIO::writeConfigurationFile("studyCase", replacement);
exit(0);
    return app.exec();
}
