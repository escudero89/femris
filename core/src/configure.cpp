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

Configure::Configure() {
    // We need to set at least this variable before loading the configuration (because FileIO)
    m_configuration["OS"] = "linux";
}

Configure::~Configure() {
    saveConfiguration();
}

void Configure::initApp() {
    // We mark this flag as true. It'll be false if the user exits correctly
    write("crashed", "true");
    write("lastAccessDate", QDateTime::currentDateTime().toString(Utils::dateFormat));
    instance->saveConfiguration();

}

void Configure::exitApp() {
    instance->write("crashed", "false");
    instance->write("lastExitDate", QDateTime::currentDateTime().toString(Utils::dateFormat));
    instance->saveConfiguration();

    // As this function is called at the correct exit, we delete the temporal files
    FileIO::removeTemporaryFiles();
}

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


QString Configure::read(const QString& setting) {
    if (!instance->m_configuration.contains(setting)) {
        Utils::throwErrorAndExit("Configuration::read(): unknown setting " + setting);
    }
    return instance->m_configuration[setting];
}

void Configure::write(const QString& setting, const QString& value, bool checkIfExists) {

    if (!instance->m_configuration.contains(setting) && checkIfExists) {
        Utils::throwErrorAndExit("Configuration::write(): unknown setting " + setting);
    }

    instance->m_configuration[setting] = value;

    instance->saveConfiguration();
}

bool Configure::check(const QString& setting, const QString& value) {

    if (!instance->m_configuration.contains(setting)) {
        Utils::throwErrorAndExit("Configuration::check(): unknown setting " + setting);
    }

    return ( instance->m_configuration[setting] == value );
}

// We replace the prefix (if exists), but it depends on the OS root system
QString Configure::getPathWithoutPrefix(QString path) {

    if (instance->check("OS", "windows")) {
        path.replace("file:///", "");
    } else {
        path.replace("file://", "");
    }

    return path;
}

// Singleton Pattern Design
Configure* Configure::getInstance() {

    if (!instance) {
        instance = new Configure();
    }

    return instance;
}

void Configure::emitMainSignal(const QString &signalName) {
    emit mainSignalEmitted(signalName);
}
