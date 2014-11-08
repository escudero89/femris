#ifndef CONFIGURE_H
#define CONFIGURE_H

#include <QObject>
#include <QMap>

class Configure : public QObject {

    Q_OBJECT


public:

    Configure();
    ~Configure();

    void loadConfiguration(const QString&);
    void loadConfigurationFromFile();

    Q_INVOKABLE static QString read(const QString&);
    Q_INVOKABLE static void write(const QString&, const QString&, bool = false);
    Q_INVOKABLE static bool check(const QString&, const QString&);

    static Configure* getInstance();

public Q_SLOTS:


Q_SIGNALS:


private:

    static Configure *instance;

    QMap<QString, QString> m_configuration;

    QString m_pathConfigurationXml;
    QString m_pathUserConfigurationXml;

};

#endif // CONFIGURE_H
