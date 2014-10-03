#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>

class FileIO : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)

  public:
    FileIO();

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);

    QString source() const;

  public Q_SLOTS:

    void setSource(QString arg);

  Q_SIGNALS:

    void error(const QString& msg);
    void sourceChanged();

  private:

    QString m_source;

};

#endif // FILEIO_H
