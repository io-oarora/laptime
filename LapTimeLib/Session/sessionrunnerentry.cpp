#include "sessionrunnerentry.h"

SessionRunnerEntry::SessionRunnerEntry(QObject *parent)
    : QObject{parent} {

}

SessionRunnerEntry::SessionRunnerEntry(QString label, QTime time,
                                     SessionRunnerEntryDirection direction,
                                     QObject *parent):
    m_label(label), m_time(time), m_direction(direction) {

    Q_UNUSED(parent);
}

QString SessionRunnerEntry::label() const {
    return m_label;
}

QTime SessionRunnerEntry::time() const {
    return m_time;
}

SessionRunnerEntry::SessionRunnerEntryDirection SessionRunnerEntry::direction() const {
    return m_direction;
}
