import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: setEditDuration

    property bool durationAcceptable: true
    property bool durationEnabled: true

    property string invalidDuration
    property string invalidDurationMessage
    property string label

    property real minutesIndex: 0
    property real secondsIndex: 0

    /*** Layout ************************************************************************/

    Row {
        spacing: 0
        anchors.centerIn: parent

        Item {
            width: setEditDuration.width * .375
            height: setEditDuration.height

            CustomLabel {
                width: parent.width
                height: parent.height * .115

                anchors.centerIn: parent

                color: setEditTheme.contentColor

                text: "%0:".arg(label)
            }
        }

        CustomTumbler {
            id: minutesTumbler
            width: setEditDuration.width * .25
            height: setEditDuration.height

            label {
                text: baseLiterals.minutes
                color: setEditTheme.contentColor
            }

            tumbler {
                currentIndex: minutesIndex
                model: getTumblerModel()

                onCurrentIndexChanged: validateDuration()
            }

            enabled: durationEnabled
        }

        Item {
            width: setEditDuration.width * .125
            height: setEditDuration.height

            CustomLabel {
                width: parent.width
                height: parent.height * .115

                anchors.centerIn: parent

                text: baseLiterals.colon
            }
        }

        CustomTumbler {
            id: secondsTumbler
            width: setEditDuration.width * .25
            height: setEditDuration.height

            label {
                text: baseLiterals.seconds
                color: setEditTheme.contentColor
            }

            tumbler {
                currentIndex: secondsIndex
                model: getTumblerModel()

                onCurrentIndexChanged: validateDuration()
            }

            enabled: durationEnabled
        }
    }

    // Invalid duration message
    CustomLabel {
        id: invalidDurationLabel
        width: parent.width * .8
        height: parent.height * .09
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * .05
            horizontalCenter: parent.horizontalCenter
        }

        fontItalic: true
        color: setEditTheme.backBorderColor
        opacity: .7

        text: setEditDuration.invalidDurationMessage
        visible: false
    }

    /*** Functions *********************************************************************/
    function getTumblerModel() {
        var model = []

        for(var index = 0; index < 60; index ++) {
            model.push(index.toString().padStart(2, 0))
        }

        return model
    }

    function initTumblers(minutes, seconds) {
        minutesIndex = minutes
        secondsIndex = seconds
    }

    function getDuration() {
        var model = getTumblerModel()

        var mins = model[minutesTumbler.tumbler.currentIndex]
        var secs = model[secondsTumbler.tumbler.currentIndex]

        return mins + baseLiterals.colon + secs
    }

    function validateDuration() {
        if (invalidDuration && (getDuration() === invalidDuration)) {
            invalidDurationLabel.visible = true
            durationAcceptable = false
        } else {
            invalidDurationLabel.visible = false
            durationAcceptable = true
        }
    }
}
