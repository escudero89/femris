#include "fileio.h"
#include "configure.h"

#include <QApplication>
#include <QFile>
#include <QTextStream>

#include <QJsonDocument>
#include <QJsonObject>

#include <QDir>
#include <QDebug>

/**
 * @brief Constructor for the FileIO. It sets the filename of the file if it's passed
 * @param filename Path of the source. It can be relative (like `:/resources/config.xml`)
 */
FileIO::FileIO(const QString& filename) {
    if (filename != "") {
        setSource(filename);
    }
}

/**
 * @brief Checks if the source is empty (not the file, but rather the filename)
 * @return Whether if empty (true) or not (false)
 */
bool FileIO::isSourceEmpty() {
    bool isEmpty = m_source.isEmpty();

    if (isEmpty) {
        emit error("FileIO::isSourceEmpty(): Source is empty");
    }

    return isEmpty;
}

/**
 * @brief Opens the current file associated, reads its content, and returns it.
 * @return Content of the file, or empty string
 */
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
            emit error("FileIO::read(): Unable to open the file: " + m_source);
        }
    }

    emit performedRead(fileContent);

    return fileContent;
}

/**
 * @brief Writes data into the file
 *
 * @param data String with the data to be saved
 * @return Whether succeeded in saving the data or not
 */
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

/**
 * @brief Gets the current path for the FileIO instance
 * @return The path
 */
QString FileIO::source() const {
    return m_source;
}

/**
 * @brief Whether the file linked by the stored path exists
 * @return Exists result
 */
bool FileIO::exists() {
    QFile file(m_source);
    return file.exists();
}

/**
 * @brief Removes the file linked with the stored path
 * @return Returns true if successful; otherwise returns false
 */
bool FileIO::deleteFile() {
    return QFile::remove(m_source);
}

/**
 * @brief Sets the stored path of the FileIO instance
 * @param arg New path string to be set
 * @return Wheter exists
 */
bool FileIO::setSource(QString arg) {
    if (m_source != arg) {
        m_source = Configure::getPathWithoutPrefix(arg);
        emit sourceChanged();
    }

    return exists();
}

/**
 * @brief Parses a JSON string, and returns its content
 *
 * This function is mainly used to read JSON files and parse its content to be
 * used later on the QML files.
 *
 * @param jsonFile String with the content of a JSON file
 * @return Returns the raw binary representation of the JSON
 */
QJsonObject FileIO::getVarFromJsonString(const QString& jsonFile) {

    QJsonDocument jsonResponse = QJsonDocument::fromJson(jsonFile.toUtf8());

    if (jsonResponse.isNull()) {
        emit error("FileIO::getVarFromJsonString() : jsonFile is not a valid JSON object");
    }

    return jsonResponse.object();
}

/**
 * @brief Returns a list of the names of all the files and directories in the directory
 *
 * Returns a list of the names of all the files and directories in the directory,
 * ordered according to the name and the argument filters.
 * Returns an empty list if the directory is unreadable, does not exist, or if nothing matches the specification.
 *
 * @param filters List with the filters that are going to be applied to the filenames
 * @param directory Relative path of the directory that contains the files
 *
 * @return A list of the names of all the files and directories
 */
QStringList FileIO::getFilteredFilesFromDirectory(const QStringList& filters, const QString& directory) {

    QDir dir(directory);
qDebug() << directory << dir.exists() << dir.absolutePath();
    QStringList searchedFiles;
    searchedFiles = dir.entryList(filters, QDir::Files);

    QStringList searchedFilesPath;

    for ( int k = 0 ; k < searchedFiles.length() ; k++ ) {
        searchedFilesPath << dir.filePath(searchedFiles[k]);qDebug() <<searchedFiles[k] << dir.filePath(searchedFiles[k]);
    }

    return searchedFilesPath;
}

/**
 * @brief Read from a source without changing the stored path in the FileIO instance
 *
 * This function is mainly used in QML, to avoid having to re-set in there the
 * previous path in the FileIO instance.
 *
 * @param file Path of the file to be read
 * @return Content of the file, or a empty string
 */
QString FileIO::readFromSource(const QString& file) {
    QString previous_m_source = m_source;
    setSource(file);
qDebug() << "-------------------> File source: " << file;
    QString data = read();
    setSource(previous_m_source);

    return data;
}

//----------------------------------------------------------------------------//
//--                           STATIC FUNCTIONS                             --//
//----------------------------------------------------------------------------//

/**
 * @brief Writes a QMap variable into a file, using another file as base.
 *
 * The base file needs to have the keys of the QMap written into it, like
 *
 *      MyKey: {{key}}
 *
 * This "key" is going to be replaced by the current value of the QMap[key].
 *
 * @param pathConfigurationToLoad Base file to be used
 * @param pathFileToSave Where the new file is going te be stored
 * @param replacement The QMap used as a replacement for the keys of the base file
 */
void FileIO::writeConfigurationFile(const QString &pathConfigurationToLoad,
                                    const QString &pathFileToSave,
                                    const QMap<QString, QString> &replacement) {

    FileIO fileIO;
    fileIO.setSource(pathConfigurationToLoad);

    QString configurationFileContent = fileIO.read();

    QMapIterator<QString, QString> iteratorMap(replacement);
    while (iteratorMap.hasNext()) {
        iteratorMap.next();

        // All the keys in the configuration are surrounded by {{key}}
        QString replacementKey = "{{" + iteratorMap.key() + "}}";
        configurationFileContent.replace(replacementKey, iteratorMap.value());
    }

    fileIO.setSource(pathFileToSave);
    fileIO.write(configurationFileContent);

}

/**
 * @brief Reads a configuration file and splits its content into several files
 *
 * Reads the configuration file created by FileIO::writeConfigurationFile, and
 * splits its content in different files. This allows the creation of a single
 * ".femris" that will store all the Study Case's information in one file.
 *
 * @param configurationTemplate Base file for the configuration (indicates where to split)
 * @param configurationPath Where the current configuration file is
 * @param capturedTextFilter Filter to know where to do the split
 * @param jumpSeparationLines Should it jump the previous line?
 *
 * @return Whether succeeded in splitting and merging
 */
bool FileIO::splitConfigurationFile(const QString &configurationTemplate,
                                    const QString &configurationPath,
                                    const QStringList &capturedTextFilter,
                                    bool jumpSeparationLines) {

    bool successInSplitingAndMerging = false;

    QString pathDir = qApp->applicationDirPath();

    QString pathFile;
    if (configurationPath.indexOf("file") == -1) {
        pathFile = pathDir + configurationPath;
    } else {
        pathFile = Configure::getPathWithoutPrefix(configurationPath);
    }

    QString matlabFileContent = "";

    QFile fileConfiguration(pathFile);

    if (fileConfiguration.open(QIODevice::ReadOnly)) {

        QString line;
        QTextStream streamConfiguration(&fileConfiguration);

        QRegExp regex("^%%.* STUDY CASE (\\S*)\\s* .*>>$");

        bool saveDataInMatlabFile = false;
        bool inDefinitionLine = false;

        do {
            line = streamConfiguration.readLine();
            inDefinitionLine = line.contains(regex);

            // If there is a match, the regex will contain the matched captures
            if (inDefinitionLine) {
                saveDataInMatlabFile = capturedTextFilter.contains(regex.cap(1));
            }

            // If we don't want to save the previous line, we jump it
            if (saveDataInMatlabFile && (!inDefinitionLine || !jumpSeparationLines)) {
                matlabFileContent += line + "\r\n";
            }

        } while (!line.isNull());

        fileConfiguration.close();

        FileIO fileCurrentMatlab;
        fileCurrentMatlab.setSource(pathDir + "/temp/" + configurationTemplate);

        successInSplitingAndMerging = fileCurrentMatlab.write(matlabFileContent);
    }

    return successInSplitingAndMerging;
}

/**
 * @brief Removes all the temporary files
 *
 * The files removed are from the temp folder, and are those with the extensions
 * `.femris.old`, `.base64`, and those which have the strings  `*_tmp_*` and
 * `currentMatFemFile*` in their name.
 *
 */
void FileIO::removeTemporaryFiles() {

    QDir dir(qApp->applicationDirPath() + "/temp");

    QStringList filters;
    filters << "*.femris.old" << "*.base64" << "*_tmp*" << "currentMatFemFile*";

    QStringList temporaryFiles;
    temporaryFiles = dir.entryList(filters, QDir::Files);

    for ( int k = 0 ; k < temporaryFiles.length() ; k++ ) {
        qDebug() << "Deleting... " << temporaryFiles[k];
        dir.remove(temporaryFiles[k]);
    }
}
