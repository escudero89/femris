#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>

class FileIO : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)

public:
    FileIO();

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString &data);

    QString source() const;
    bool isSourceEmpty();

    static bool readConfigurationFile(QString, const QString&);
    static void writeConfigurationFile(const QString&, const QString&, const QMap<QString, QString>&);
    static bool splitConfigurationFile(const QString&, const QString&, const QStringList&, bool);

public Q_SLOTS:

    void setSource(QString arg);

Q_SIGNALS:

    void error(const QString &msg);
    void sourceChanged();
    void performedRead(const QString &content);

private:

    QString m_source;

};

#endif // FILEIO_H
