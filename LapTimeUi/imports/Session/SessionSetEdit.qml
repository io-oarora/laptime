import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionSetEdit
    anchors.centerIn: parent

    property QtObject setEditTheme: sessionViewTheme.sessionSetEdit
    property var editInput: inArgs

    property string title: editInput ? editInput.title : baseLiterals.emptyString

    QtObject {
        id: stateTheme

        property bool nextVisible: true
        property bool previousVisible: true
        property bool titleEditable: true
    }

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        id: setEditBackground
        anchors.fill: parent
        color: setEditTheme.backColor
        radius: Math.min(width * .0386, height * .0568)
        border {
            width: Math.min(setEditBackground.width * .01,
                            setEditBackground.height * .009)
            color: setEditTheme.backBorderColor
        }

        layer.enabled: true
        layer.effect: CustomShadow {
        }
    }

    // Set title
    Item {
        id: titleItem
        width: parent.width
        height: parent.height * .2

        Rectangle {
            id: titleBackground
            width: parent.width * .8
            height: parent.height * .5
            anchors.centerIn: parent

            radius: height * .5

            color: setEditTheme.titleEditBoxColor
            border {
                width: Math.min(titleBackground.width * .01,
                                titleBackground.height * .075)
                color: setEditTheme.titleEditBoxBorderColor
            }

            visible: stateTheme.titleEditable
        }

        TextInput {
            id: titleInput
            width: parent.width * .8
            height: parent.height * .5
            anchors.centerIn: parent

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            font {
                pointSize: Math.max(1, height * .36)
                weight: Font.DemiBold
                family: baseTheme.appFontFamily
            }

            maximumLength: 12

            color: setEditTheme.backBorderColor

            text: title
            onTextChanged: {
                if (!text.length)
                    return

                if (!text.trim().length) {
                    text = ""
                    return
                }

                text = validateTitle(text)
            }

            enabled: stateTheme.titleEditable
        }

        // Empty title label
        CustomLabel {
            width: parent.width * .8
            height: parent.height * .275
            anchors.centerIn: parent

            fontItalic: true
            color: setEditTheme.contentColor
            opacity: .6
            visible: !titleInput.displayText.trim()

            text: baseLiterals.setTitleEmptyMessage
        }
    }

    // Set values
    Item {
        id: valuesItem
        width: parent.width
        anchors {
            top: titleItem.bottom
            bottom: buttonsItem.top
        }

        SwipeView {
            id: editSwipeView

            width: parent.width * .8
            height: parent.height
            anchors.centerIn: parent

            orientation: Qt.Horizontal
            clip: true

            SessionSetEditDuration {
                id: delayView
                height: editSwipeView.height
                width: editSwipeView.width

                label: baseLiterals.delay
            }

            SessionSetEditValue {
                id: lapsView
                width: editSwipeView.width
                height: editSwipeView.height

                label: baseLiterals.laps

                onValueChanged: function(value) {
                    if (value === 1) {
                        restView.durationEnabled = false
                    } else {
                        restView.durationEnabled = true
                    }
                }
            }

            SessionSetEditDuration {
                id: lapTimeView
                width: editSwipeView.width
                height: editSwipeView.height

                label: baseLiterals.lapTime
                invalidDuration: "00:00"
                invalidDurationMessage: baseLiterals.lapTimeInvalidMessage
            }

            SessionSetEditDuration {
                id: restView
                width: editSwipeView.width
                height: editSwipeView.height

                label: baseLiterals.rest
            }

            SessionSetEditSummary {
                id: summaryView
                width: editSwipeView.width
                height: editSwipeView.height
            }

            onVisibleChanged: {
                if(!visible) {
                    currentIndex = 0
                }
            }

            onCurrentItemChanged: {
                if (currentItem == summaryView) {
                    sessionSetEdit.prepareSummary()
                }
            }
        }

        // Previous button
        ImageButton {
            width: parent.width * .1
            height: parent.height * .4
            iconWidth: parent.width * .04

            anchors {
                left: parent.left
                leftMargin: parent.width * .01
                verticalCenter: parent.verticalCenter
            }
            rotation: 180
            source: setEditTheme.swipeArrowImg
            callback: function() {
                editSwipeView.currentIndex = editSwipeView.currentIndex - 1
            }

            visible: stateTheme.previousVisible
        }

        // Next button
        ImageButton {
            width: parent.width * .1
            height: parent.height * .4
            iconWidth: parent.width * .04

            anchors {
                right: parent.right
                rightMargin: parent.width * .01
                verticalCenter: parent.verticalCenter
            }
            source: setEditTheme.swipeArrowImg
            callback: function() {
                editSwipeView.currentIndex = editSwipeView.currentIndex + 1
            }

            visible: stateTheme.nextVisible
        }
    }

    // Buttons
    Item {
        id: buttonsItem
        width: parent.width
        height: parent.height * .2
        anchors.bottom: parent.bottom

        SessionSetEditButton {
            anchors.right: buttonsDivider.left

            buttonTextColor: setEditTheme.titleEditBoxBorderColor
            buttonText: baseLiterals.cancel
            callback: sessionView.closeSetEdit
        }

        Rectangle {
            id: buttonsDivider
            width: setEditBackground.border.width
            height: parent.height * .4
            anchors.centerIn: parent
            color: setEditTheme.backBorderColor
        }

        SessionSetEditButton {
            anchors.left: buttonsDivider.right

            buttonTextColor: setEditTheme.titleEditBoxBorderColor
            buttonText: baseLiterals.save
            callback: sessionSetEdit.updateSet
            enabled: titleInput.text.length && lapTimeView.durationAcceptable
        }
    }

    /*** States *************************************************************************/

    states: [
        State {
            when: editSwipeView.currentIndex === 0
            PropertyChanges {
                target: stateTheme
                previousVisible: false
            }
        },
        State {
            when: editSwipeView.currentIndex === 4
            PropertyChanges {
                target: stateTheme
                nextVisible: false
                titleEditable: false
            }
        }
    ]


    /*** Functions *********************************************************************/

    onVisibleChanged: {
        if (!visible) {
            return;
        }

        initViews()
    }

    function initViews() {
        var delay = parseTime(editInput.delay)
        delayView.initTumblers(delay[0], delay[1])

        var laps = parseInt(editInput.laps)
        lapsView.initTumbler(laps - 1)

        var lapTime = parseTime(editInput.lapTime)
        lapTimeView.initTumblers(lapTime[0], lapTime[1])

        var rest = parseTime(editInput.rest)
        restView.initTumblers(rest[0], rest[1])
    }

    function parseTime(timeStr) {
        var mins = parseInt(timeStr.substring(0, 2))
        var secs = parseInt(timeStr.substring(3))
        return [mins, secs]
    }

    function updateSet() {
        updateEditInput()

        sessionView.updateSet(editInput)
    }

    function prepareSummary() {
        updateEditInput()
        var totalDuration = sessionView.calculateSetDuration(editInput)
        var inputsAcceptable = {
            "delay": delayView.durationAcceptable,
            "lapTime": lapTimeView.durationAcceptable,
            "laps": lapsView.valueAcceptable,
            "rest": restView.durationAcceptable
        }

        summaryView.loadSummary(inputsAcceptable, totalDuration)
    }

    function updateEditInput() {
        editInput.title = titleInput.text.trim()
        editInput.delay = delayView.getDuration()
        editInput.lapTime = lapTimeView.getDuration()
        editInput.laps = lapsView.getValue()
        editInput.rest = restView.getDuration()
    }

    function validateTitle(title) {
        var charCode = title.charCodeAt(title.length-1)

        // Check if character is digit
        if ((charCode >= 48) && (charCode <= 57))
            return title

        // Check if character is lowercase char
        if ((charCode >= 97) && (charCode <= 122))
            return title

        // Check if character is uppercase char
        if ((charCode >= 65) && (charCode <= 90))
            return title

        // Check if character is space,  dash or underscore
        if ((charCode === 32) || (charCode === 45) || (charCode === 95))
            return title

        return title.substring(0, title.length-1)
    }
}
