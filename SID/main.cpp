#include <QtGui/QApplication>
#include "mainwindow.h"
#include <QTextCodec>
#include <QSplashScreen>
#include <QPixmap>
#include <QThread>

class Wait : public QThread
{
public:
        static void sleep(unsigned long secs) {
                QThread::sleep(secs);
        }
};


int main(int argc, char *argv[])
{
    // Text format
    QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));


    QApplication a(argc, argv);

    // Splash screen
    QPixmap pixmap(":/myresources/splash.png");
    QSplashScreen * splash = new QSplashScreen(pixmap);
    splash->show();

    // Prepare for data loading!
    //Wait::sleep(1);
    splash->showMessage(QObject::tr("Kontrola aktualizací..."), Qt::AlignRight | Qt::AlignBottom, Qt::white);
    a.processEvents();
    //Wait::sleep(3);
    splash->showMessage(QObject::tr("Vytváření spojení..."), Qt::AlignRight | Qt::AlignBottom, Qt::white);
    //Wait::sleep(2);

    // Main window
    MainWindow w;
    w.show();
    splash->finish(&w);
    
    return a.exec();
}
