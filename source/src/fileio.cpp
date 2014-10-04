#include "fileio.h"

#include <QFile>
#include <QTextStream>

FileIO::FileIO()
    : m_source(-1) {
}

bool FileIO::isSourceEmpty() {
    bool is_empty = m_source.isEmpty();

    if (is_empty) {
        emit error("Source is empty");
    }

    return is_empty;
}

QString FileIO::read() {
    QString fileContent;

    if (!this->isSourceEmpty()) {
        QFile file(m_source);

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
        }
    }

    return fileContent;
}

bool FileIO::write(const QString& data) {
    bool success_in_writing = false;

    if (!this->isSourceEmpty()) {
        QFile file(m_source);

        if (file.open(QFile::WriteOnly | QFile::Truncate)) {
            QTextStream out(&file);
            out << data;
            file.close();
            success_in_writing = true;

        } else {
            emit error("Can't open the file");
        }
    }

    return success_in_writing;
}

QString FileIO::source() const {
    return m_source;
}

void FileIO::setSource(QString arg) {
    if (m_source != arg) {
        m_source = arg;
        // We replace the prefix (if exists)
        m_source.replace("file://", "");
        emit sourceChanged();
    }
}
