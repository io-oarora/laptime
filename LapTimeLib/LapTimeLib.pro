QT -= gui

TEMPLATE = lib

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    Session/sessionmodel.cpp \
    Session/sessionrunner.cpp \
    Session/sessionrunnerentry.cpp \
    Session/sessionset.cpp \
    laptimelib.cpp

HEADERS += \
    Session/sessionconstants.h \
    Session/sessionmodel.h \
    Session/sessionrunner.h \
    Session/sessionrunnercontext.h \
    Session/sessionrunnerentry.h \
    Session/sessionset.h \
    laptimelib.h

INCLUDEPATH += \
    Session

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
