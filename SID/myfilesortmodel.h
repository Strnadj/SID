#ifndef MYFILESORTMODEL_H
#define MYFILESORTMODEL_H

#include <QSortFilterProxyModel>
#include <QDir>
#include <QString>
#include <QStandardItemModel>
#include <QStandardItem>
#include <QFile>
#include <QFileInfo>
#include <QIcon>
#include <QStringList>

class MyFileSortModel : public QStandardItemModel
{
    Q_OBJECT
public:
    explicit MyFileSortModel(QObject *parent = 0);
    void setPath( QString & path);
    void createModel();

protected:

private:
    void createItems(const QString &dirName, QStandardItem *parent);
    QIcon * folderIcon;
    QIcon * phpFileIcon;
    QIcon * phpFileErrorIcon;
    QString projectPath;
    QDir * projectDir;

signals:
    
public slots:
    
};

#endif // MYFILESORTMODEL_H
