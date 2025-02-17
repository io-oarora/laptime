#include "sessionset.h"

SessionSet::SessionSet(QObject *parent) {

    Q_UNUSED(parent);
}

SessionSet::SessionSet(const QString &title, const QTime &delay,
                       const int laps, const QTime &lapTime,
                       const QTime &rest,
                       QObject *parent):
    m_title(title), m_delay(delay),
    m_laps(laps), m_lapTime(lapTime),
    m_rest(rest) {

    Q_UNUSED(parent);
}

SessionSet::~SessionSet() {
}

void SessionSet::markCompleted() {
    setCompleted(true);
}

int SessionSet::laps() const {

    return m_laps;
}

SessionSet *SessionSet::setLaps(const int laps) {

    if (m_laps != laps) {
        m_laps = laps;
    }
    return this;
}

QString SessionSet::title() const {

    return m_title;
}

SessionSet *SessionSet::setTitle(const QString &title) {

    if (m_title != title) {
        m_title = title;
    }
    return this;
}

QTime SessionSet::delay() const {

    return m_delay;
}

SessionSet *SessionSet::setDelay(const QTime &delay) {

    if (m_delay != delay) {
        m_delay = delay;
    }
    return this;
}

QTime SessionSet::lapTime() const {

    return m_lapTime;
}

SessionSet *SessionSet::setLapTime(const QTime &lapTime) {

    if (m_lapTime != lapTime) {
        m_lapTime = lapTime;
    }
    return this;
}

QTime SessionSet::rest() const {

    return m_rest;
}

SessionSet *SessionSet::setRest(const QTime &rest) {

    if (m_rest != rest) {
        m_rest = rest;
    }
    return this;
}

bool SessionSet::completed() const {
    return m_completed;
}

SessionSet *SessionSet::setCompleted(const bool completed) {
    if (m_completed != completed) {
        m_completed = completed;
    }
    return this;
}
