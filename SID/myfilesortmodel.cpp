#include "myfilesortmodel.h"

MyFileSortModel::MyFileSortModel(QObject *parent) :
    QStandardItemModel(parent)
{
    // Icons
    folderIcon = new QIcon(":/myresources/folder.png");
    phpFileIcon = new QIcon(":/myresources/file.png");
    phpFileErrorIcon = new QIcon(":/myresources/fileError.png");

    // Set name
    QStringList names;
    names << QObject::tr("Název");
    this->setHorizontalHeaderLabels(names);
}

void MyFileSortModel::setPath(QString & path) {
    projectPath = path;
    projectDir = new QDir(projectPath);
}

void MyFileSortModel::createModel() {
    this->createItems(projectPath, NULL);
}

/** Create items */
void MyFileSortModel::createItems(const QString & dirName, QStandardItem * parent) {
    QDir dir(dirName);
    if (dir.exists(dirName)) {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::System  | QDir::AllDirs | QDir::Files, QDir::DirsFirst)) {
            if (info.isDir()) {
                QStandardItem * folder = new QStandardItem( * folderIcon, info.fileName());
                folder->setEditable(false);
                this->createItems(info.absoluteFilePath(), folder);
                if (parent == NULL) {
                    this->appendRow(folder);
                } else {
                    parent->appendRow(folder);
                }
            } else {
                QString fileName = info.fileName();
                if (fileName.endsWith(".php", Qt::CaseInsensitive)) {
                    QStandardItem * file = new QStandardItem(* phpFileIcon, info.fileName());
                    file->setEditable(false);
                    if (parent == NULL) {
                        this->appendRow(file);
                    } else {
                        parent->appendRow(file);
                    }
                }
            }
        }
    }
}
