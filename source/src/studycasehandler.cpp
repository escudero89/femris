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

/*
 *
 **/
QString StudyCaseHandler::saveAndContinue(const QString &parentStage) {

    unsigned int stepOfProcess = getSingleStudyCaseInformation("stepOfProcess").toUInt();
    unsigned int newStepOfProcess = 0;

    int currentStepOfProcess = 1;

    QStringList stagesList;
    stagesList << "CE_Model" << "CE_Domain" << "CE_Overall";

    while (newStepOfProcess == 0) {

        if (currentStepOfProcess > stagesList.size() - 1) {
            qDebug() << "StudyCaseHandler::saveAndContinue(): parentStage doesn't exist - " << parentStage;
            exit(1);
        }

        if (saveAndContinueHelper(parentStage,
                                  stagesList.at(currentStepOfProcess - 1),
                                  stepOfProcess,
                                  currentStepOfProcess)) {

            newStepOfProcess = currentStepOfProcess + 1;
        }

        currentStepOfProcess++;

    }

    setSingleStudyCaseInformation("stepOfProcess", QString::number(newStepOfProcess));

    return stagesList.at(newStepOfProcess - 1);
}

bool StudyCaseHandler::saveAndContinueHelper(const QString &parentStage,
                                             const QString &comparisonStage,
                                             const unsigned int &stepOfProcess,
                                             const unsigned int &stepOfProcessForComparison) {

    return (parentStage == comparisonStage && stepOfProcess == stepOfProcessForComparison);
}
