#ifndef SESSIONRUNNERENTRY_H
#define SESSIONRUNNERENTRY_H

#include <QObject>
#include <QTime>

class SessionRunnerEntry : public QObject {

    public:
        enum SessionRunnerEntryDirection {
            Clockwise = 0,
            Anticlockwise
        };

        explicit SessionRunnerEntry(QObject *parent = nullptr);
        SessionRunnerEntry(QString label,
                          QTime time,
                          SessionRunnerEntryDirection direction,
                          QObject *parent = nullptr);

        QString label() const;
        QTime time() const;
        SessionRunnerEntryDirection direction() const;

    private:
        QString m_label;
        QTime m_time;
        SessionRunnerEntryDirection m_direction;
};

#endif // SESSIONRUNNERENTRY_H
