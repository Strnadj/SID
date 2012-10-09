#-------------------------------------------------
#
# Project created by QtCreator 2012-05-24T18:33:47
#
#-------------------------------------------------

QT       += core gui network

TARGET = SID
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    helpwindow.cpp

HEADERS  += mainwindow.h \
    helpwindow.h

FORMS    += mainwindow.ui \
    helpwindow.ui

RESOURCES += \
    resoruces.qrc

OTHER_FILES += \
    Resources/images/open.png \
    Resources/images/help.png \
    Resources/images/exit.png \
    Resources/images/splash.png
