TEMPLATE = subdirs

SUBDIRS += \
    LapTimeLib \
    LapTimeUi

LapTimeUi.depends = LapTimeLib
