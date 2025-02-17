#ifndef SESSIONRUNNERCONTEXT_H
#define SESSIONRUNNERCONTEXT_H

#include <QTime>

class SessionRunnerContext
{
    protected:
        SessionRunnerContext() {}

        double m_activeProgress;
        double m_sessionProgress;
        int m_activeTotalMs;
        int m_activeSetIndex;
        int m_activeEntryIndex;
        QTime m_activeTime;
        QTime m_activeTimeTarget;
        QTime m_sessionStartTime;
        QTime m_sessionStopTime;
        QTime m_sessionTimeLeft;
        QString m_activeLabel;
};

#endif // SESSIONRUNNERCONTEXT_H
