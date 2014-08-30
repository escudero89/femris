#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    // We created our base framework
    QApplication app(argc, argv);

    // Our main window
    MainWindow *w = new MainWindow();

    // This is the standard web size
    w->resize(960, 600);
    w->show();
    w->setWindowTitle(QApplication::translate("toplevel", "FEMRIS"));

    return app.exec();
}
