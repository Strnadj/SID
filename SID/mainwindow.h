#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "helpwindow.h"

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

private slots:
    void openHelp();
    void close();
    void on_start_clicked();
};

#endif // MAINWINDOW_H
