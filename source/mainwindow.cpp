#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QFile>
#include <QDebug>
#include <QTextStream>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) {
    ui->setupUi(this);
}

MainWindow::~MainWindow() {
    delete ui;
}

void MainWindow::on_pushButton_clicked() {

    // Simple reading of a file
    QFile myFile(":/data/txt/tutorial.txt");
    myFile.open(QIODevice::ReadOnly);

    QTextStream textStream(&myFile);
    QString line = textStream.readAll();

    myFile.close();

    ui->textEdit->setPlainText(line);
}
