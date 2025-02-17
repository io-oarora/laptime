#ifndef SESSIONRUNNER_H
#define SESSIONRUNNER_H

#include "sessionconstants.h"
#include "sessionmodel.h"
#include "sessionrunnercontext.h"
#include "sessionrunnerentry.h"

#include <QObject>
#include <QTimer>

class SessionRunner : public QObject, SessionRunnerContext, SessionConstants {

    Q_OBJECT

    Q_PROPERTY(bool running READ timerRunning NOTIFY timerRunningChanged)
    Q_PROPERTY(int activeSetIndex READ activeSetIndex NOTIFY activeSetIndexChanged)
    Q_PROPERTY(QVariantMap values READ values NOTIFY runnerValuesChanged)

    public:
        explicit SessionRunner(QObject *parent = nullptr);
        SessionRunner(SessionModel* sessionModel,
                     QObject *parent = nullptr);

    Q_INVOKABLE void initRunner();
    Q_INVOKABLE bool sessionStarted() const;
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop(const bool endSession = false);

    bool timerRunning() const;
    int activeSetIndex() const;

    QVariantMap values() const;

    signals:
        void activeEntryCompleted();
        void activeSetIndexChanged();
        void threeTwoOne();
        void runnerValuesChanged();
        void sessionCompleted();
        void timerRunningChanged();

    private:
        void endActiveSession(const int lastSetIndex, const bool completed);
        void initActiveRunnerEntry();
        void initActiveSessionSet();
        bool moveToNextRunnerEntry();
        void processTimerEvent();
        void resetRunner();

        int m_timerInterval{100};
        QTimer *m_timer;

        SessionModel* m_sessionModel;
        QList<SessionRunnerEntry*> m_runnerEntries;
};

#endif // SESSIONRUNNER_H
