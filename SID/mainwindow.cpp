#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    version = QString("SID 0.1 pre-release");

    setWindowTitle(version);

    // Open help window
    connect(ui->actionHelp, SIGNAL(triggered()), this, SLOT(openHelp()));

    // Close application
    connect(ui->actionEnd, SIGNAL(triggered()), this, SLOT(close()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

/** Open Help window */
void MainWindow::openHelp() {
    if(!help) {
        help = new HelpWindow(this);
    }
    help->show();
    help->activateWindow();
}

/** Close window */
void MainWindow::close() {
    int ret = QMessageBox::question(this, version,
                                   tr("Opravdu chcete ukončit program?"),
                                   QMessageBox::Ok | QMessageBox::Cancel);
    switch (ret) {
       case QMessageBox::Ok:
           qApp->exit(0);
           break;
       case QMessageBox::Cancel:
           // Don't Save was clicked, do nothing
           break;
       default:
           // should never be reached
           break;
     }
}
