#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QJsonObject>
#include <QStringList>

/**
 * @brief The FileIO class that manages the files
 *
 * The FileIO handles all the control over the external files. It reads/writes
 * all the files of the app, and also it's in charge of removing the temporary
 * files once the app finishes.
 *
 */
class FileIO : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)

public:
    FileIO(const QString& = "");

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString&);
    Q_INVOKABLE QJsonObject getVarFromJsonString(const QString&);

    Q_INVOKABLE QStringList getFilteredFilesFromDirectory(const QStringList&, const QString& = "");

    Q_INVOKABLE QString readFromSource(const QString&);

    QString source() const;
    bool isSourceEmpty();

    bool exists();
    bool deleteFile();

    // Statics
    static bool readConfigurationFile(QString, const QString&);
    static void writeConfigurationFile(const QString&, const QString&, const QMap<QString, QString>&);
    static bool splitConfigurationFile(const QString&, const QString&, const QStringList&, bool);

    static void removeTemporaryFiles();

public Q_SLOTS:

    bool setSource(QString arg);

Q_SIGNALS:

    void error(const QString &msg);
    void sourceChanged();
    void performedRead(const QString &content);

private:

    QString m_source;

};

#endif // FILEIO_H
