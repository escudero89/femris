#ifndef CONFIGURE_H
#define CONFIGURE_H

#include <QObject>
#include <QMap>

class Configure : public QObject {

    Q_OBJECT


public:

    Configure();
    ~Configure();
    void loadConfiguration();

    Q_INVOKABLE static QString read(const QString&);
    Q_INVOKABLE static void write(const QString&, const QString&);
    Q_INVOKABLE static bool check(const QString&, const QString&);

    static Configure* getInstance();

public Q_SLOTS:


Q_SIGNALS:


private:

    static Configure *instance;

    QMap<QString, QString> m_configuration;

};

#endif // CONFIGURE_H
