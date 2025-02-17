#include "sessionrunner.h"
#include <QtMath>

SessionRunner::SessionRunner(QObject *parent)
    : QObject{parent} {
}

SessionRunner::SessionRunner(SessionModel *sessionModel, QObject *parent)
    : m_sessionModel(sessionModel) {

    Q_UNUSED(parent)

    m_timer = new QTimer(this);
    m_timer->setInterval(m_timerInterval);
    m_timer->setTimerType(Qt::PreciseTimer);
    connect(m_timer, &QTimer::timeout, this, &SessionRunner::processTimerEvent);
}

void SessionRunner::initRunner() {

    // Initializer timer entries
    m_activeSetIndex = 0;
    initActiveSessionSet();

    m_sessionTimeLeft = QTime(m_sessionModel->sessionDuration());
    m_sessionProgress = 0;

    emit runnerValuesChanged();
    emit activeSetIndexChanged();
}

bool SessionRunner::sessionStarted() const {
    return m_sessionTimeLeft != m_sessionModel->sessionDuration();
}

void SessionRunner::start() {
    // Set session start time
    if (!sessionStarted()) {
        m_sessionStartTime = QTime::currentTime();
    }

    m_timer->start();
    emit timerRunningChanged();
}

void SessionRunner::stop(const bool endSession) {

    if (endSession) {
        endActiveSession(m_activeSetIndex-1, false);

    } else {
        m_timer->stop();
        emit timerRunningChanged();
    }
}

bool SessionRunner::timerRunning() const {
    return m_timer->isActive();
}

void SessionRunner::processTimerEvent() {

    int msLeft;
    if (m_runnerEntries.at(m_activeEntryIndex)->direction() ==
            SessionRunnerEntry::SessionRunnerEntryDirection::Anticlockwise) {

        m_activeTime = m_activeTime.addMSecs(-m_timerInterval);
        msLeft = m_activeTimeTarget.msecsTo(m_activeTime);
        m_activeProgress = (double) msLeft / m_activeTotalMs;

    } else {
        m_activeTime = m_activeTime.addMSecs(m_timerInterval);
        msLeft = m_activeTime.msecsTo(m_activeTimeTarget);
        m_activeProgress = 1.0 - (double) msLeft / m_activeTotalMs;
    }

    m_sessionTimeLeft = m_sessionTimeLeft.addMSecs(-m_timerInterval);
    m_sessionProgress = 1 - ((double) m_sessionTimeLeft.msecsSinceStartOfDay()) /
            m_sessionModel->sessionDuration().msecsSinceStartOfDay();

    if (msLeft == 3000 || msLeft == 2000 || msLeft == 1000) {
        emit threeTwoOne();
    } else if (msLeft <= 0) {

        emit activeEntryCompleted();

        if (!moveToNextRunnerEntry()) {

            m_timer->stop();
            endActiveSession(m_activeSetIndex, true);

            emit timerRunningChanged();
        }
    }

    emit runnerValuesChanged();
}

void SessionRunner::resetRunner() {

    // Reset entries
    foreach (SessionRunnerEntry* entry, m_runnerEntries) {
        m_runnerEntries.removeAll(entry);
        entry->deleteLater();
    }

    // Reset properties
    m_activeProgress = 0;
    m_activeTotalMs = -1;
    m_activeLabel = "";
    m_activeTime = QTime::fromMSecsSinceStartOfDay(0);
    m_activeTimeTarget = QTime::fromMSecsSinceStartOfDay(0);
}

int SessionRunner::activeSetIndex() const {
    return m_activeSetIndex;
}

QVariantMap SessionRunner::values() const
{
    QVariantMap values;
    values.insert("activeProgress", m_activeProgress);
    values.insert("activeLabel", m_activeLabel);
    values.insert("activeTime", m_activeTime.toString(TIME_MMSS));
    values.insert("sessionTimeLeft", m_sessionTimeLeft.toString(TIME_HHMMSS));
    values.insert("sessionProgress", m_sessionProgress);

    return values;
}

void SessionRunner::endActiveSession(const int lastSetIndex, const bool completed) {

    m_sessionStopTime = QTime::currentTime();
    if (!sessionStarted()) {
        m_sessionStartTime = m_sessionStopTime;
    }
    m_sessionModel->endSession(m_sessionStartTime, m_sessionStopTime, completed, lastSetIndex);
    resetRunner();

    emit sessionCompleted();
}

void SessionRunner::initActiveSessionSet() {

    resetRunner();

    SessionSet* sessionSet = m_sessionModel->getSessionSets().at(m_activeSetIndex);

    if (sessionSet->delay().msecsSinceStartOfDay() > 0) {
        m_runnerEntries.append(new SessionRunnerEntry(QString("Delay"),
                                                    sessionSet->delay(),
                                                    SessionRunnerEntry::SessionRunnerEntryDirection::Anticlockwise));
    }

    for (int lap = 0; lap < sessionSet->laps(); lap++) {
        m_runnerEntries.append(new SessionRunnerEntry(QString("Lap %0").arg(lap + 1),
                                                    sessionSet->lapTime(),
                                                    SessionRunnerEntry::SessionRunnerEntryDirection::Clockwise));

        if ((lap < sessionSet->laps() - 1) &&
            (sessionSet->rest().msecsSinceStartOfDay() > 0)) {
            m_runnerEntries.append(new SessionRunnerEntry(QString("Rest"),
                                                        sessionSet->rest(),
                                                        SessionRunnerEntry::SessionRunnerEntryDirection::Anticlockwise));
        }
    }

    m_activeEntryIndex = 0;
    initActiveRunnerEntry();
}

void SessionRunner::initActiveRunnerEntry() {
    SessionRunnerEntry* currentEntry = m_runnerEntries.at(m_activeEntryIndex);

    m_activeLabel = currentEntry->label();

    if (currentEntry->direction() == SessionRunnerEntry::SessionRunnerEntryDirection::Anticlockwise)
    {
        m_activeTime = currentEntry->time();
        m_activeTimeTarget = QTime::fromMSecsSinceStartOfDay(0);
        m_activeProgress = 1.0;
    } else {
        m_activeTime = QTime::fromMSecsSinceStartOfDay(0);
        m_activeTimeTarget = currentEntry->time();
        m_activeProgress = 0.0;
    }

    m_activeTotalMs = qFabs(m_activeTimeTarget.msecsTo(m_activeTime));
}

bool SessionRunner::moveToNextRunnerEntry() {

    int totalEntries = m_runnerEntries.size();
    int totalSets = m_sessionModel->getSessionSets().size();

    if (m_activeEntryIndex == (totalEntries - 1)) {
        if (m_activeSetIndex == (totalSets - 1)) {
            return false;
        } else {
            m_activeSetIndex++;
            initActiveSessionSet();
            emit activeSetIndexChanged();
        }
    } else {
        m_activeEntryIndex++;
        initActiveRunnerEntry();
    }

    return true;
}
