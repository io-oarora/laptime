#ifndef SESSIONSET_H
#define SESSIONSET_H

#include <QTime>

class SessionSet : public QObject {

    public:
        SessionSet(QObject *parent = nullptr);
        SessionSet(const QString &title,
                   const QTime &delay,
                   const int laps,
                   const QTime &lapTime,
                   const QTime &rest,
                   QObject *parent = nullptr);
        ~SessionSet();

        void markCompleted();

        bool completed() const;
        SessionSet* setCompleted(const bool completed);

        int laps() const;
        SessionSet* setLaps(const int laps);

        QString title() const;
        SessionSet* setTitle(const QString &title);

        QTime delay() const;
        SessionSet* setDelay(const QTime &delay);

        QTime lapTime() const;
        SessionSet* setLapTime(const QTime &lapTime);

        QTime rest() const;
        SessionSet* setRest(const QTime &rest);

    private:
        bool m_completed{false};
        QString m_title;
        QTime m_delay;
        int m_laps;
        QTime m_lapTime;
        QTime m_rest;
};

#endif // SESSIONSET_H
