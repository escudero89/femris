#include "studycasehandler.h"

#include <QDebug>

StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = new StudyCaseStructural();
}

StudyCaseHandler::~StudyCaseHandler() {
    delete m_studyCase;
}

bool StudyCaseHandler::createNewStudyCase() {

    m_studyCase->createNew();
    m_currentStudyCaseVariables = m_studyCase->getMapOfInformation();

    return true;
}

QString StudyCaseHandler::getSingleStudyCaseInformation(const QString& variable) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        qDebug() << "StudyCaseHandler::getStudyCaseInformationAbout(): unknown variable" << variable;
    }

    return m_currentStudyCaseVariables.value(variable);
}

void StudyCaseHandler::setSingleStudyCaseInformation(const QString& variable,
                                                     const QString& newVariable) {

    if (!m_currentStudyCaseVariables.contains(variable)) {
        qDebug() << "StudyCaseHandler::setSingleStudyCaseInformation(): unknown variable" << variable;
    }

    m_currentStudyCaseVariables[variable] = newVariable;

    m_studyCase->setMapOfInformation(m_currentStudyCaseVariables);
    m_studyCase->saveCurrentConfiguration();
}
