#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QThread>
#include <QDebug>
#include <QDirIterator>
#include <QDirModel>

class Wait : public QThread
{
public:
        static void sleep(unsigned long secs) {
                QThread::sleep(secs);
        }
};


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    version = QString("SID 0.1 pre-release");

    setWindowTitle(version);
    setUnifiedTitleAndToolBarOnMac(true);

    // Open help window
    connect(ui->actionHelp, SIGNAL(triggered()), this, SLOT(openHelp()));

    // Close application
    connect(ui->actionEnd, SIGNAL(triggered()), this, SLOT(close()));

    // Open folder with project
    connect(ui->actionOpenfolder, SIGNAL(triggered()), this, SLOT(openProjectFolder()));

}
/** Destroy main window */
MainWindow::~MainWindow()
{
    delete ui;
}

/** Open folder with project */
void MainWindow::openProjectFolder() {
    QString folder = QFileDialog::getExistingDirectory(this, tr("Otevřít projektovou složku"), "", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    projectDir = QDir(folder);

    QStringList fileTypes;
    fileTypes << ".php";

    dirModel = new QDirModel(this);
    dirModel->setSorting(QDir::DirsFirst | QDir::IgnoreCase | QDir::Name);
    ui->files->setModel(dirModel);
    ui->files->setAnimated(true);
    ui->files->setRootIndex(dirModel->index(folder));
    ui->files->hideColumn(1);
    ui->files->hideColumn(2);
    ui->files->hideColumn(3);
}

/** Open Help window */
void MainWindow::openHelp() {
    help = new HelpWindow(this);
    help->show();
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

/** Start click */
void MainWindow::on_start_clicked()
{
    int value = 0;

    ui->progressBar->setTextVisible(true);

    for(value = 0; value <= 100000; value++) {
        ui->progressBar->setValue(value/1000);
        ui->progressBar->setFormat(QString("Hotovo: %1").arg(value/1000));
    }


}
