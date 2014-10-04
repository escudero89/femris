#include "fileio.h"

#include <QApplication>
#include <QFile>
#include <QTextStream>

#include <armadillo>

FileIO::FileIO()
    : m_source(-1) {
}

bool FileIO::isSourceEmpty() {
    bool isEmpty = m_source.isEmpty();

    if (isEmpty) {
        emit error("Source is empty");
    }

    return isEmpty;
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

bool FileIO::write(const QString &data) {
    bool successInWriting = false;

    if (!this->isSourceEmpty()) {
        QFile file(m_source);

        if (file.open(QFile::WriteOnly | QFile::Truncate)) {
            QTextStream out(&file);
            out << data;
            file.close();
            successInWriting = true;

        } else {
            emit error("Can't open the file");
        }
    }

    return successInWriting;
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

//----------------------------------------------------------------------------//
//--                           STATIC FUNCTIONS                             --//
//----------------------------------------------------------------------------//

bool FileIO::readConfigurationFile(QString configurationTemplate, const QString &data) {
    return true;
}

void FileIO::writeConfigurationFile(const QString &configurationTemplate,
                                    const QString &configurationPath,
                                    const QMap<QString, QString> &replacement) {

    QString pathDir = qApp->applicationDirPath();
    QString currentFile = pathDir + configurationPath;

    QString pathFile = pathDir;

    if (configurationTemplate == "base") {
        pathFile += "/scripts/base.femris";
        std::cout << "WORKS" << std::endl;
    }

    FileIO fileIO;
    fileIO.setSource(pathFile);

    QString configurationFileContent = fileIO.read();

    QMapIterator<QString, QString> iteratorMap(replacement);
    while (iteratorMap.hasNext()) {
        iteratorMap.next();

        // All the keys in the configuration are surrounded by {{key}}
        QString replacementKey = "{{" + iteratorMap.key() + "}}";
        configurationFileContent.replace(replacementKey, iteratorMap.value());
    }

    fileIO.setSource(currentFile);
    fileIO.write(configurationFileContent);

}
