#ifndef CONFIGURE_H
#define CONFIGURE_H

#include <QObject>
#include <QMap>

/**
 * @brief The Configure class that handles mainly the Configuration
 *
 * The Configure class works as a Singleton. Its main purpose is to read/write
 * the custom configuration file for the user, which stores configuration
 * parameters (such as which OS the user has, or what interpreter [matlab/octave]
 * is the user using).
 *
 */
class Configure : public QObject {

    Q_OBJECT

public:

    Configure();
    ~Configure();

    void loadConfiguration(const QString&);
    void loadConfigurationFromFile(bool = false);
    void saveConfiguration();

    Q_INVOKABLE static void initApp();
    Q_INVOKABLE static void exitApp();

    Q_INVOKABLE static QString read(const QString&);
    Q_INVOKABLE static void write(const QString&, const QString&, bool = false);
    Q_INVOKABLE static bool check(const QString&, const QString&);
    Q_INVOKABLE static QString getPathWithoutPrefix(QString);
    Q_INVOKABLE static QString formatWithAbsPath(QString);

    Q_INVOKABLE void emitMainSignal(const QString&, QString = "");

    static Configure* getInstance();

public Q_SLOTS:


Q_SIGNALS:

    void mainSignalEmitted(const QString& signalName, const QString& args);

private:

    static Configure *instance; ///< Configure instance needed by the Singleton Pattern

    QMap<QString, QString> m_configuration; ///< Map of the configuration parameters

    QString m_pathConfigurationXml; ///< Path of the original configuration file
    QString m_pathUserConfigurationXml; ///< Path of the custom configuration file

};

#endif // CONFIGURE_H
