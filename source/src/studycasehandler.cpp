#include "studycasehandler.h"

StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = new StudyCase();
}

bool StudyCaseHandler::createNewStudyCase(const QString& filePath) {

    m_studyCase->createNew();

    return true;
}
