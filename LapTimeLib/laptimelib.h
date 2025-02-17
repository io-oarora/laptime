#ifndef LAPTIMELIB_H
#define LAPTIMELIB_H

#include "Session/sessionmodel.h"
#include "Session/sessionrunner.h"

class LapTimeLib {

    public:
        LapTimeLib();

        SessionModel* currentSession() const;
        SessionRunner* sessionRunner() const;

    private:
        SessionModel* m_sessionModel;
        SessionRunner* m_sessionRunner;

};

#endif // LAPTIMELIB_H
