#include "sessionmodel.h"

SessionModel::SessionModel(QObject *parent) :
    QAbstractListModel(parent) {

}

QVariant SessionModel::addSessionSet() {

    QString title = getNewSetTitle();
    int laps = DEFAULT_LAPS;
    QTime delay(DEFAULT_DELAY);
    QTime lapTime(DEFAULT_LAPTIME);
    QTime rest(DEFAULT_REST);
    SessionSet* newSet = new SessionSet(title, delay, laps, lapTime, rest);

    bool canAddSet = validateAddSet(newSet);
    QVariantMap response;

    if (!canAddSet) {
        int maxAllowableMs = MAX_TIME.msecsSinceStartOfDay() - sessionDuration().msecsSinceStartOfDay();

        if (maxAllowableMs > 0 )
        {
            newSet = new SessionSet(
                        title,
                        QTime::fromMSecsSinceStartOfDay(0),
                        1,
                        QTime::fromMSecsSinceStartOfDay(maxAllowableMs),
                        QTime::fromMSecsSinceStartOfDay(0)
                    );
        } else {
            response.insert("acceptable", false);
            response.insert("message", SESSION_DURATION_LIMIT_REACHED_MESSAGE);

            return response;
        }
    }

    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    m_sessionSets << newSet;
    endInsertRows();
    emit sessionChanged();

    response.insert("acceptable", true);
    return response;
}


QString SessionModel::getNewSetTitle() const {

    QSet<QString> currentSetNames;

    foreach (SessionSet* set, m_sessionSets) {

        currentSetNames.insert(set->title());
    }

    int nextNo = 1;
    QString title = SET_FORMAT.arg(nextNo);

    while (currentSetNames.contains(title)) {

        nextNo++;
        title = SET_FORMAT.arg(nextNo);
    }

    return title;
}

void SessionModel::removeSessionSet(const int row) {

    beginRemoveRows(QModelIndex(), row, row);

    SessionSet* currentSet = m_sessionSets[row];
    m_sessionSets.removeAt(row);
    currentSet->deleteLater();

    endRemoveRows();
    emit sessionChanged();
}

void SessionModel::updateSet(const QVariantMap setData) {

    int row = setData.value(ROW).toInt();

    QString title = setData.value(TITLE).toString();
    QTime delay = QTime::fromString(setData.value(DELAY).toString(),
                                    TIME_MMSS);
    QTime lapTime = QTime::fromString(setData.value(LAP_TIME).toString(),
                                      TIME_MMSS);
    int laps = setData.value(LAPS).toInt();
    QTime rest = QTime::fromString(setData.value(REST).toString(),
                                   TIME_MMSS);

    m_sessionSets[row]
            ->setTitle(title)
            ->setDelay(delay)
            ->setLapTime(lapTime)
            ->setLaps(laps)
            ->setRest(rest);

    emit dataChanged(index(row, 0), index(row, 0));
    emit sessionChanged();
}

bool SessionModel::validateAddSet(SessionSet* newSet) const {

    int updatedMs = sessionDuration().msecsSinceStartOfDay()
            + calculateSetDuration(newSet).msecsSinceStartOfDay();

    return updatedMs <= MAX_TIME.msecsSinceStartOfDay();
}

QVariantMap SessionModel::validateSessionDuration(const QVariantMap setData) const {

    int row = setData.value(ROW).toInt();
    QTime oldSetDuration = calculateSetDuration(m_sessionSets.at(row));
    QTime newSetDuration = QTime::fromString(calculateSetDuration(setData), TIME_HHMMSS);

    int updatedMs = sessionDuration().msecsSinceStartOfDay()
            - oldSetDuration.msecsSinceStartOfDay()
            + newSetDuration.msecsSinceStartOfDay();

    bool acceptable = updatedMs <= MAX_TIME.msecsSinceStartOfDay();

    QVariantMap response;
    response.insert("acceptable", acceptable);

    if (!acceptable) {
        response.insert("message", SESSION_DURATION_LIMIT_MESSAGE);
    }

    return response;
}

void SessionModel::endSession(const QTime &startTime, const QTime &stopTime,
                              const bool completed, const int lastSetIndex) {

    m_startTime = startTime;
    m_stopTime = stopTime;
    m_completed = completed;

    markSessionsCompleted(lastSetIndex);

    emit sessionChanged();
}

void SessionModel::markSessionsCompleted(const int lastSetIndex) {
    for (int setIndex = 0; setIndex <= lastSetIndex; setIndex++) {
        m_sessionSets.at(setIndex)->markCompleted();
        emit dataChanged(index(setIndex, 0), index(setIndex, 0));
    }
}

void SessionModel::resetSession() {

    beginRemoveRows(QModelIndex(), 0, m_sessionSets.size()-1);

    foreach (SessionSet* sessionSet, m_sessionSets) {
        m_sessionSets.removeAll(sessionSet);
        sessionSet->deleteLater();
    }

    endRemoveRows();

    m_startTime = QTime::fromMSecsSinceStartOfDay(0);
    m_stopTime = QTime::fromMSecsSinceStartOfDay(0);
    m_completed = false;
    emit sessionChanged();
}

QTime SessionModel::sessionDuration() const {

    QTime totalTime(0, 0, 0);

    foreach(SessionSet * set, m_sessionSets) {
        QTime setTime = calculateSetDuration(
                    set->delay(),
                    set->laps(),
                    set->lapTime(),
                    set->rest());

        totalTime = totalTime.addMSecs(setTime.msecsSinceStartOfDay());
    }

    return totalTime;
}

QString SessionModel::calculateSetDuration(const QVariantMap setData) const
{
    QTime delay = QTime::fromString(setData.value(DELAY).toString(),
                                    TIME_MMSS);
    QTime lapTime = QTime::fromString(setData.value(LAP_TIME).toString(),
                                      TIME_MMSS);
    int laps = setData.value(LAPS).toInt();
    QTime rest = QTime::fromString(setData.value(REST).toString(),
                                   TIME_MMSS);

    QTime totalTime = calculateSetDuration(delay, laps, lapTime, rest);

    return totalTime.toString(TIME_HHMMSS);
}

QTime SessionModel::calculateSetDuration(const SessionSet *sessionSet) const {
    return calculateSetDuration(sessionSet->delay(),
                                sessionSet->laps(),
                                sessionSet->lapTime(),
                                sessionSet->rest());
}

QTime SessionModel::calculateSetDuration(const QTime &delay, const int laps,
                                         const QTime &lapTime, const QTime &rest) const
{
    QTime totalTime(delay);

    // Add lap time
    for(int lap = 0; lap < laps; lap++) {
        totalTime = totalTime.addMSecs(lapTime.msecsSinceStartOfDay());
    }

    // Add rest
    for (int lap = 0; lap < laps-1; lap++) {
        totalTime = totalTime.addMSecs(rest.msecsSinceStartOfDay());
    }

    return totalTime;
}

QVariantMap SessionModel::values() const {

    QVariantMap values;
    values.insert("lapsedTime", getLapsedTime().toString(TIME_HHMMSS));
    values.insert("sessionCompleted", m_completed);
    values.insert("sessionDuration", sessionDuration().toString(TIME_HHMMSS));
    values.insert("setCount", rowCount());
    values.insert("setLimitReached", setLimitReached());
    values.insert("sessionReady", sessionReady());
    values.insert("startTime", m_startTime.toString(TIME_HHMMSS));
    values.insert("stopTime", m_stopTime.toString(TIME_HHMMSS));

    return values;
}

QTime SessionModel::getLapsedTime() const {

    // Remove milliseconds
    QTime stopTime = QTime(m_stopTime.hour(),
                           m_stopTime.minute(),
                           m_stopTime.second());
    QTime startTime = QTime(m_startTime.hour(),
                            m_startTime.minute(),
                            m_startTime.second());

    return stopTime.addMSecs(-startTime.msecsSinceStartOfDay());
}

bool SessionModel::setLimitReached() const {

    return rowCount() >= MAX_SET_COUNT;
}

bool SessionModel::sessionReady() const
{
    return rowCount() > 0;
}

int SessionModel::rowCount(const QModelIndex &parent) const {

    Q_UNUSED(parent);

    return m_sessionSets.count();
}

QVariant SessionModel::data(const QModelIndex &index, int role) const {

    if (indexOutOfBounds(index)) {

        return QVariant();
    }

    SessionSet* currentSet = m_sessionSets[index.row()];

    switch (role) {
        case TitleRole:
            return currentSet->title();
        case DelayRole:
            return currentSet->delay().toString(TIME_MMSS);
        case LapsRole:
            return currentSet->laps();
        case LapTimeRole:
            return currentSet->lapTime().toString(TIME_MMSS);
        case RestRole:
            return currentSet->rest().toString(TIME_MMSS);
        case CompletedRole:
            return currentSet->completed();
        default:
            return QVariant();
    }
}

QList<SessionSet *> &SessionModel::getSessionSets() {
    return m_sessionSets;
}

QHash<int, QByteArray> SessionModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TitleRole] = ROLE_FORMAT.arg(TITLE).toUtf8();
    roles[DelayRole] = ROLE_FORMAT.arg(DELAY).toUtf8();
    roles[LapsRole] = ROLE_FORMAT.arg(LAPS).toUtf8();
    roles[LapTimeRole] = ROLE_FORMAT.arg(LAP_TIME).toUtf8();
    roles[RestRole] = ROLE_FORMAT.arg(REST).toUtf8();
    roles[CompletedRole] = ROLE_FORMAT.arg(COMPLETED).toUtf8();

    return roles;
}

bool SessionModel::indexOutOfBounds(const QModelIndex &index) const {

    return index.row() < 0 || index.row() >= m_sessionSets.count();
}

