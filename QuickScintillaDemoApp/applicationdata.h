#ifndef APPLICATIONDATA_H
#define APPLICATIONDATA_H

#include <QObject>

// **************************************************************************

class ApplicationData : public QObject
{
    Q_OBJECT

public:
    explicit ApplicationData(QObject *parent);
    ~ApplicationData();

    Q_INVOKABLE QString readFileContent(const QString & fileName) const;
    Q_INVOKABLE bool writeFileContent(const QString & fileName, const QString & content);

    Q_INVOKABLE bool deleteFile(const QString & fileName);
};

#endif // APPLICATIONDATA_H
