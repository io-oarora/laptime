#include "laptimelib.h"

LapTimeLib::LapTimeLib() {

    m_sessionModel = new SessionModel();
    m_sessionRunner = new SessionRunner(m_sessionModel);
}

SessionModel* LapTimeLib::currentSession() const {

    return m_sessionModel;
}

SessionRunner *LapTimeLib::sessionRunner() const {

    return m_sessionRunner;
}
