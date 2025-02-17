#ifndef SESSIONCONSTANTS_H
#define SESSIONCONSTANTS_H

#include <QString>
#include <QTime>

class SessionConstants {

    protected:
        static inline int DEFAULT_LAPS = 4;
        static inline int MAX_SET_COUNT = 8;

        static inline QString COMPLETED{"completed"};
        static inline QString DELAY{"delay"};
        static inline QString LAPS{"laps"};
        static inline QString LAP_TIME{"lapTime"};
        static inline QString REST{"rest"};
        static inline QString ROLE_FORMAT{"r_%0"};
        static inline QString ROW{"row"};
        static inline QString SESSION_DURATION_LIMIT_MESSAGE{
            "Total session duration cannot--exceed 1 day."
        };
        static inline QString SESSION_DURATION_LIMIT_REACHED_MESSAGE{
            "Session duration limit--already reached: 23:59:59."
        };
        static inline QString SET_FORMAT{"Set %0"};
        static inline QString TIME_MMSS{"mm:ss"};
        static inline QString TIME_HHMMSS{"HH:mm:ss"};
        static inline QString TITLE{"title"};

        static inline QTime DEFAULT_DELAY{0, 0, 45};
        static inline QTime DEFAULT_LAPTIME{0, 1, 0};
        static inline QTime DEFAULT_REST{0, 0, 30};
        static inline QTime MAX_TIME{23, 59, 59};
};

#endif // SESSIONCONSTANTS_H
