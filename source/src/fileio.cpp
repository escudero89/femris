#include "fileio.h"

#include <QFile>
#include <QTextStream>

FileIO::FileIO()
    : m_source(-1) {
}

QString FileIO::read() {
    if (m_source.isEmpty()) {
        emit error("Source is Empty");
        return QString();
    }

    // We replace the prefix (if exists)
    m_source.replace("file://", "");
    QFile file(m_source);
    QString fileContent;

    if (file.open(QIODevice::ReadOnly)) {
        QString line;
        QTextStream t(&file);

        do {
            line = t.readLine();
            fileContent += line + "\r\n";
        } while (!line.isNull());

        file.close();

    } else {
        emit error("Unable to open the file");
        return QString();
    }

    return fileContent;
}

bool FileIO::write(const QString& data) {
    if (m_source.isEmpty()) {
        emit error("Source is Empty");
        return false;
    }

    QFile file(m_source);

    if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
        emit error("Can't open the file");
        return false;
    }

    QTextStream out(&file);
    out << data;
    file.close();
    return true;
}

QString FileIO::source() const {
    return m_source;
}

void FileIO::setSource(QString arg) {
    if (m_source != arg) {
        m_source = arg;
        emit sourceChanged();
    }
}
