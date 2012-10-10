#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "helpwindow.h"
#include <QFileDialog>
#include <QString>
#include <QDir>
#include <QStringList>
#include <QDirModel>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QString version;
    
private:
    HelpWindow * help;
    Ui::MainWindow *ui;
    QDir projectDir;
    QDirModel * dirModel;


private slots:
    void openHelp();
    void close();
    void on_start_clicked();
    void openProjectFolder();
};

#endif // MAINWINDOW_H
