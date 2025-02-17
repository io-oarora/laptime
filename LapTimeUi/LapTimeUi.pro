QT += quick multimedia

SOURCES += \
        main.cpp

resources.prefix = /$${TARGET}
RESOURCES += \
    images.qrc \
    qml.qrc \
    sounds.qrc


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/imports

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../LapTimeLib/release/ -lLapTimeLib
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../LapTimeLib/debug/ -lLapTimeLib
else:unix: LIBS += -L$$OUT_PWD/../LapTimeLib/ -lLapTimeLib



INCLUDEPATH += $$PWD/../LapTimeLib
DEPENDPATH += $$PWD/../LapTimeLib
