#include "configure.h"
#include "fileio.h"
#include "utils.h"

#include "femrisxmlcontenthandler.h"
#include <QXmlSimpleReader>
#include <QXmlDefaultHandler>

#include <QFile>
#include <QDebug>

Configure* Configure::instance = NULL;

Configure::Configure() {
    // We need to set at least this variable before loading the configuration (because FileIO)
    m_configuration["OS"] = "linux";
}

Configure::~Configure() {
}

void Configure::loadConfiguration(const QString& pathConfigurationXml) {

    m_pathConfigurationXml = pathConfigurationXml;
    m_pathUserConfigurationXml = pathConfigurationXml;

    FileIO fileIO;
    fileIO.setSource(m_pathConfigurationXml);

    if (fileIO.read().isEmpty()) {
        m_pathConfigurationXml = ":/resources/config.xml";
    }

    loadConfigurationFromFile();
}

void Configure::loadConfigurationFromFile() {

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

    fileIO.setSource(m_pathUserConfigurationXml);
    fileIO.write(configuration);

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
}

bool Configure::check(const QString& setting, const QString& value) {

    if (!instance->m_configuration.contains(setting)) {
        Utils::throwErrorAndExit("Configuration::check(): unknown setting " + setting);
    }

    return ( instance->m_configuration[setting] == value );
}

// Singleton Pattern Design
Configure* Configure::getInstance() {

    if (!instance) {
        instance = new Configure();
    }

    return instance;
}
