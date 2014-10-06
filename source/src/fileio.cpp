#include "fileio.h"

#include <QApplication>
#include <QFile>
#include <QTextStream>

#include <QDebug>

#include <armadillo>

FileIO::FileIO()
    : m_source(-1) {
}

bool FileIO::isSourceEmpty() {
    bool isEmpty = m_source.isEmpty();

    if (isEmpty) {
        emit error("FileIO::isSourceEmpty(): Source is empty");
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
            emit error("FileIO::read(): Unable to open the file");
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
            emit error("FileIO::write(): Can't open the file");
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

    QString pathFile = pathDir + "/scripts/" + configurationTemplate + ".femris";

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

bool FileIO::splitConfigurationFile(const QString &configurationTemplate,
                                    const QString &configurationPath,
                                    const QStringList &capturedTextFilter,
                                    bool jumpSeparationLines) {

    bool successInSplitingAndMerging = false;

    QString pathDir = qApp->applicationDirPath();
    QString pathFile = pathDir + configurationPath;

    QString octaveFileContent = "";

    QFile fileConfiguration(pathFile);

    if (fileConfiguration.open(QIODevice::ReadOnly)) {

        QString line;
        QTextStream streamConfiguration(&fileConfiguration);

        QRegExp regex("^##.* STUDY CASE (\\S*)\\s* .*>>$");

        bool saveDataInOctaveFile = false;
        bool inDefinitionLine = false;

        do {
            line = streamConfiguration.readLine();
            inDefinitionLine = line.contains(regex);

            // If there is a match, the regex will contain the matched captures
            if (inDefinitionLine) {
                saveDataInOctaveFile = capturedTextFilter.contains(regex.cap(1));
            }

            // If we don't want to save the previous line, we jump it
            if (saveDataInOctaveFile && (!inDefinitionLine || !jumpSeparationLines)) {
                octaveFileContent += line + "\r\n";
            }

        } while (!line.isNull());

        fileConfiguration.close();

        FileIO fileCurrentOctave;
        fileCurrentOctave.setSource(pathDir + "/temp/" + configurationTemplate);

        successInSplitingAndMerging = fileCurrentOctave.write(octaveFileContent);
    }

    return successInSplitingAndMerging;
}
