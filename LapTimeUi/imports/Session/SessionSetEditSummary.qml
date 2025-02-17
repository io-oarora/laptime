import QtQuick 2.15

import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: setEditSummary

    property var setData: [
        {
            "label": baseLiterals.delay,
            "value": setValues.delay,
            "acceptable": setValues.delayAcceptable
        },
        {
            "label": baseLiterals.lapTime,
            "value": setValues.lapTime,
            "acceptable": setValues.lapTimeAcceptable
        },
        {
            "label": baseLiterals.laps,
            "value": setValues.laps,
            "acceptable": setValues.lapsAcceptable
        },
        {
            "label": baseLiterals.rest,
            "value": setValues.rest,
            "acceptable": setValues.restAcceptable
        }
    ]

    QtObject {
        id: setValues

        property bool delayAcceptable
        property bool lapTimeAcceptable
        property bool lapsAcceptable
        property bool restAcceptable

        property string delay
        property string lapTime
        property string laps
        property string rest
        property string totalDuration
    }

    /*** Layout ************************************************************************/

    Column {
        id: setColumn
        width: parent.width * .7
        height: parent.height * .8

        anchors {
            top: parent.top
            topMargin: parent.height * .1
            horizontalCenter: parent.horizontalCenter
        }

        spacing: 0

        Repeater {
            model: setData

            Item {
                id: summaryContent
                implicitWidth: setColumn.width
                implicitHeight: setColumn.height * .25

                Row {
                    CustomLabel {
                        width: summaryContent.width * .7
                        height: summaryContent.height * .5

                        color: modelData.acceptable
                               ? setEditTheme.contentColor
                               : setEditTheme.backBorderColor

                        horizontalAlignment: Text.AlignLeft

                        text: modelData.label
                    }

                    CustomLabel {
                        width: summaryContent.width * .3
                        height: summaryContent.height * .5

                        color: modelData.acceptable
                               ? setEditTheme.contentColor
                               : setEditTheme.backBorderColor

                        horizontalAlignment: Text.AlignLeft

                        text: modelData.value
                    }
                }
            }
        }
    }

    Item {
        width: parent.width
        height: parent.height * .1

        anchors.bottom: parent.bottom

        CustomLabel {
            id: totalTimeLabel

            width: parent.width * .8
            height: parent.height * .9
            anchors.centerIn: parent

            color: setEditTheme.titleEditBoxBorderColor
            fontWeight: Font.DemiBold
            fontItalic: true

            text: baseLiterals.totalTime.arg(setValues.totalDuration)
        }
    }

    /*** Functions *********************************************************************/

    function loadSummary(inputsAcceptable, totalDuration) {
        setValues.delay = editInput.delay
        setValues.laps = editInput.laps
        setValues.lapTime = editInput.lapTime
        setValues.rest = editInput.laps === 1 ? "--:--" : editInput.rest

        setValues.delayAcceptable = inputsAcceptable.delay
        setValues.lapsAcceptable = inputsAcceptable.laps
        setValues.lapTimeAcceptable = inputsAcceptable.lapTime
        setValues.restAcceptable = inputsAcceptable.rest

        setValues.totalDuration = totalDuration
    }
}
