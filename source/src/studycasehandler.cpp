#include "studycasehandler.h"

StudyCaseHandler::StudyCaseHandler() {
    m_studyCase = new StudyCase();
}

bool StudyCaseHandler::createNewStudyCase() {

    m_studyCase->createNew();

    return true;
}
