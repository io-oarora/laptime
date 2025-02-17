import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionEdit

    property bool sessionReady: sessionModel.values.sessionReady
    property bool setLimitReached: sessionModel.values.setLimitReached
    property string sessionDuration: sessionModel.values.sessionDuration

    property var sessionModel: sessionView.getSessionModel()

    QtObject {
        id: stateTheme

        property bool readyButtonEnabled: false
        property real durationLabelOpacity: .5
    }

    /*** Layout ************************************************************************/

    // ListView
    Item {
        id: setListItem
        width: parent.width
        anchors {
            top: parent.top
            bottom: totalTimeLabel.top
            bottomMargin: parent.height * .02
        }

        property real setListHeight: setListItem.height * .267 *
                                     Math.min(sessionModel.values.setCount, 3)
        property real setHeight: setListItem.height * .192

        ListView {
            id: setList
            width: parent.width
            height: setListItem.setListHeight
            model: sessionModel
            clip: true
            spacing: height * .125
            delegate: SessionSet {
                implicitWidth: setList.width
                implicitHeight: setListItem.setHeight
                callback: function() {
                    var setData = {
                        "row": index,
                        "title": r_title,
                        "delay": r_delay,
                        "lapTime": r_lapTime,
                        "laps": r_laps,
                        "rest": r_rest
                    }

                    sessionView.editSet(setData)
                }
            }
        }

        CustomScrollBar {
            id: verticalScrollBar
            width: parent.width * .0375
            height: setList.height * .9
            anchors {
                right: parent.right
                rightMargin: parent.width * .02
                verticalCenter: setList.verticalCenter
            }

            orientation: Qt.Vertical
            position: setList.visibleArea.yPosition
            pageSize: setList.visibleArea.heightRatio

            barColor: sessionViewTheme.headerColor
        }

        // Add button item
        Item {
            width: parent.width
            height: parent.height * .2
            anchors {
                top: parent.top
                topMargin: Math.min(setList.contentHeight,
                                    setList.height)
            }

            // Add button
            ImageButton {
                id: addButton

                width: parent.height * .4
                anchors {
                    top: parent.top
                    topMargin: parent.height * .175
                    horizontalCenter: parent.horizontalCenter
                }

                source: sessionViewTheme.addIcon
                callback: function() {
                    sessionView.addSet()
                    setList.positionViewAtEnd()
                }

                enabled: !sessionEdit.setLimitReached
            }

            // Underline
            Underline {
                width: parent.width * .6
                height: parent.height * .15
                opacity: addButton.opacity

                anchors {
                    top: addButton.bottom
                    topMargin: parent.height * .125
                    horizontalCenter: parent.horizontalCenter
                }

                shadow: false
            }
        }
    }

    CustomLabel {
        id: totalTimeLabel

        width: parent.width * .8
        height: parent.height * .0325
        opacity: stateTheme.durationLabelOpacity
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: readyButton.top
            bottomMargin: parent.height * .03
        }

        color: sessionViewTheme.headerColor
        fontWeight: Font.DemiBold
        fontItalic: true

        text: baseLiterals.totalTime.arg(sessionDuration)
    }

    // Ready button
    ReadyButton {
        id: readyButton

        width: parent.width * .3
        height: parent.height * .065
        enabled: stateTheme.readyButtonEnabled

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * .02
            horizontalCenter: parent.horizontalCenter
        }

        callback: sessionView.startRunSession
    }

    /*** States ************************************************************************/
    states: [
        State {
            when: sessionEdit.sessionReady
            PropertyChanges {
                target: stateTheme
                readyButtonEnabled: true
                durationLabelOpacity: 1
            }
        }
    ]
}
