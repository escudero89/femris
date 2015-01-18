#include "configure.h"
#include "fileio.h"
#include "utils.h"

#include "femrisxmlcontenthandler.h"
#include <QXmlSimpleReader>
#include <QXmlDefaultHandler>

#include <QDateTime>
#include <QFile>
#include <QRegExp>
#include <QStringList>

#include <QDebug>

Configure* Configure::instance = NULL;

/**
 * @brief Set the parameter "OS" by default to Linux to avoid execution problems
 */
Configure::Configure() {
    // We need to set at least this variable before loading the configuration (because FileIO)
    m_configuration["OS"] = "linux";
}

/**
 * @brief When the configuration is closed, it's saved in its proper file.
 * @see Configure::saveConfiguration()
 */
Configure::~Configure() {
    saveConfiguration();
}

/**
 * @brief When the app starts, creates the custom configuration file.
 *
 * This method also takes care of crashes, by setting the parameter "crashed"
 * to "true". When the app finishes due to an unexpected behaviour, this setting
 * remains true. This is taken into account the next time that the app starts.
 *
 * @see Configure::exitApp()
 *
 */
void Configure::initApp() {
    // We mark this flag as true. It'll be false if the user exits correctly
    write("crashed", "true");
    write("lastAccessDate", QDateTime::currentDateTime().toString(Utils::dateFormat));
    instance->saveConfiguration();

}

/**
 * @brief Removes temporary files and saves for the last time the configuration.
 *
 * It's also takes care of putting the setting "crashed" to "false".
 *
 * @see Configure::initApp();
 */
void Configure::exitApp() {
    instance->write("crashed", "false");
    instance->write("lastExitDate", QDateTime::currentDateTime().toString(Utils::dateFormat));
    instance->saveConfiguration();

    // As this function is called at the correct exit, we delete the temporal files
    FileIO::removeTemporaryFiles();
}

/**
 * @brief Saves the configuration into a XML file.
 *
 * By using a base file, generates a copy of it and stores the current
 * configuration in it.
 *
 */
void Configure::saveConfiguration() {
    FileIO fileIO;
    fileIO.setSource(m_pathConfigurationXml);
    QString configuration = fileIO.read();

    QStringList configurationSplitted = configuration.split("\n");
    QStringList newConfiguration;

    QRegExp rx(".*setting=\"(\\w*)\".*value=\"(.*)\".*/>");

    for (int k = 0; k < configurationSplitted.length(); k++) {
        int pos = 0;
        bool addedSetting = false;

        while ((pos = rx.indexIn(configurationSplitted.at(k), pos)) != -1) {
            pos += rx.matchedLength();

            QString setting = rx.cap(1);
            QString value = rx.cap(2);

            QString line = configurationSplitted.at(k);
            QString replacement = instance->m_configuration[setting];

            QString newValue = line.replace(
                        line.indexOf("value=") + QString("value=").size() + 1,
                        value.size(),
                        replacement);

            newConfiguration << newValue;

            addedSetting = true;
        }

        if (!addedSetting && configurationSplitted.at(k).length() > 1) {
            newConfiguration << configurationSplitted.at(k);
        }
    }

    fileIO.setSource(m_pathUserConfigurationXml);
    fileIO.write(newConfiguration.join("\n"));
}

/**
 * @brief Loads the configuration file into a class variable
 *
 * If the custom configuration file doesn't exits, copy the original that comes
 * with the program.
 *
 * @param pathConfigurationXml Path where the custom configuration will be saved
 * @see Configure::loadConfigurationFromFile()
 */
void Configure::loadConfiguration(const QString& pathConfigurationXml) {

    m_pathConfigurationXml = pathConfigurationXml;
    m_pathUserConfigurationXml = pathConfigurationXml;

    FileIO fileIO;
    bool firstTime = !fileIO.setSource(m_pathConfigurationXml) || fileIO.read().isEmpty();

    if (firstTime) {
        m_pathConfigurationXml = ":/resources/config.xml";
    }

    loadConfigurationFromFile(firstTime);
    saveConfiguration();
}

/**
 * @brief Loads into a class variable the configuration by reading from a XML file.
 *
 * This method is called by Configure::loadConfiguration(), which sets the
 * path variables.
 *
 * @param firstTime Whether the custom configuration file already exists
 */
void Configure::loadConfigurationFromFile(bool firstTime) {

    FileIO fileIO;
    fileIO.setSource(m_pathConfigurationXml);
    QString configuration = fileIO.read();

    QXmlSimpleReader xmlReader;
    QXmlInputSource *source = new QXmlInputSource();
    source->setData(configuration);

    FemrisXmlContentHandler* handler = new FemrisXmlContentHandler();
    xmlReader.setContentHandler(handler);

    if (!xmlReader.parse(source)) {
        Utils::throwErrorAndExit("Configuration::loadConfiguration(): there was a problem loading the configuration file");
    }

    if (firstTime) {
        fileIO.setSource(m_pathUserConfigurationXml);
        fileIO.write(configuration);
    }
}

/**
 * @brief Reads a setting from the configuration
 * @param setting Key of the setting
 * @throw Utils::throwErrorAndExit If invalid key
 *
 * @return Value of the setting
 */
QString Configure::read(const QString& setting) {
    if (!instance->m_configuration.contains(setting)) {
        Utils::throwErrorAndExit("Configuration::read(): unknown setting " + setting);
    }
    return instance->m_configuration[setting];
}

/**
 * @brief Stores a configuration setting.
 *
 * The setting is saved dynamically into the class. Only those keys that are in
 * the original configuration file are chosen afterwards to be saved once the app
 * finishes its current process.
 *
 * @param setting Key of the setting to be stored
 * @param value Setting's value to be stored as string
 * @param checkIfExists Whether the setting needs to be checked if exists or not before storing its value
 * @throw Utils::throwErrorAndExit() If the key doesn't exists and checkIfExists is true
 */
void Configure::write(const QString& setting, const QString& value, bool checkIfExists) {

    if (!instance->m_configuration.contains(setting) && checkIfExists) {
        Utils::throwErrorAndExit("Configuration::write(): unknown setting " + setting);
    }

    instance->m_configuration[setting] = value;

    instance->saveConfiguration();
}

/**
 * @brief Checks if the passed value is the same as the stored by the setting
 *
 * @param setting Key of the setting to be checked
 * @param value Value to be checked if is equal to the already stored
 * @throw Utils::throwErrorAndExit() If the key is not stored in the current class

 * @return The result of the check (true if it's the same value)
 */
bool Configure::check(const QString& setting, const QString& value) {

    if (!instance->m_configuration.contains(setting)) {
        Utils::throwErrorAndExit("Configuration::check(): unknown setting " + setting);
    }

    return ( instance->m_configuration[setting] == value );
}

/**
 * @brief Receives a path, and removes the file URI scheme (if exists) from it.
 *
 * @param path Path to be checked
 * @return Path without the file URI scheme in front of it
 */
QString Configure::getPathWithoutPrefix(QString path) {

    // Windows has an extra / between the file URI scheme and the path
    if (instance->check("OS", "windows")) {
        path.replace("file:///", "");
    } else {
        path.replace("file://", "");
    }

    return path;
}

/**
 * @brief Adds the current path of the installed app to a relative path
 *
 * @param base_path Relative path (such as "temp/file")
 * @return Absolute path
 */
QString Configure::formatWithAbsPath(QString base_path) {
    return instance->read("fileApplicationDirPath") + base_path;
}

/**
 * @brief Gets the single instance of the Configure class (because of the Singleton Pattern Design)
 * @return Unique instance of Configure
 */
Configure* Configure::getInstance() {

    if (!instance) {
        instance = new Configure();
    }

    return instance;
}

/**
 * @brief Sends a signal through the app. It's mainly used in the QML section.
 *
 * @param signalName Name that identifies the custom signal sent
 * @param args Parameters that are carried by the signal (usually stringified JSON)
 */
void Configure::emitMainSignal(const QString &signalName, QString args ) {
    emit mainSignalEmitted(signalName, args);
}
