#ifndef SESSIONMODEL_H
#define SESSIONMODEL_H

#include "sessionconstants.h"
#include "sessionset.h"

#include <QAbstractListModel>

class SessionModel : public QAbstractListModel, SessionConstants {

    Q_OBJECT

    Q_PROPERTY(QVariantMap values READ values NOTIFY sessionChanged)

    public:
        enum SessionSetRoles {
            TitleRole = Qt::UserRole + 1,
            DelayRole,
            LapsRole,
            LapTimeRole,
            RestRole,
            CompletedRole
        };

        SessionModel(QObject *parent = nullptr);

        Q_INVOKABLE QVariant addSessionSet();
        Q_INVOKABLE void removeSessionSet(const int row);
        Q_INVOKABLE void resetSession();
        Q_INVOKABLE void updateSet(const QVariantMap setData);
        Q_INVOKABLE QString calculateSetDuration(const QVariantMap setData) const;
        Q_INVOKABLE QVariantMap validateSessionDuration(const QVariantMap setData) const;

        bool setLimitReached() const;
        bool sessionReady() const;
        QTime sessionDuration() const;
        QVariantMap values() const;

        int rowCount(const QModelIndex &parent = QModelIndex()) const;
        QVariant data(const QModelIndex &index, int role) const;

        QList<SessionSet*>& getSessionSets();
        void endSession(const QTime &startTime, const QTime &stopTime,
                        const bool completed, const int lastSetIndex);

    signals:
        void sessionChanged();

    protected:
        QHash<int, QByteArray> roleNames() const;

    private:
        bool indexOutOfBounds(const QModelIndex &index) const;
        QString getNewSetTitle() const;
        QTime calculateSetDuration(const SessionSet *sessionSet) const;
        QTime calculateSetDuration(const QTime &delay,
                                   const int laps,
                                   const QTime &lapTime,
                                   const QTime &rest) const;
        QTime getLapsedTime() const;
        bool validateAddSet(SessionSet* newSet) const;
        void markSessionsCompleted(const int lastSetIndex);

        bool m_completed{false};
        QList<SessionSet*> m_sessionSets;
        QTime m_startTime{0, 0, 0};
        QTime m_stopTime{0, 0, 0};
};

#endif // SESSIONMODEL_H
