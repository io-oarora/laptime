import QtQuick 2.15
import QtMultimedia

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionRun

    property QtObject sessionRunTheme: baseTheme.session
    property var sessionRunner: sessionView.getSessionRunner()

    /*** Layout ************************************************************************/

    ListView {
        id: setList
        width: parent.width * .95
        height: parent.height * .165
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        model: sessionView.getSessionModel()
        currentIndex: sessionRunner.activeSetIndex
        clip: true
        interactive: false
        highlightMoveDuration: 500

        spacing: 0
        delegate: SessionSet {
            implicitWidth: setList.width
            implicitHeight: setList.height
            enabled: false
        }
    }

    Item {
        width: parent.width * .5
        anchors {
            top: setList.bottom
            bottom: backCircle.top
            horizontalCenter: parent.horizontalCenter
        }

        CustomLabel {
            width: parent.width * .8
            height: parent.height * .225

            anchors.centerIn: parent

            fontItalic: true
            fontWeight: Font.DemiBold
            color: sessionRunTheme.summaryColor

            text: sessionRunner.values.activeLabel
        }
    }

    Rectangle
    {
        id: backCircle
        width: progressRing.width + (progressRing.width * .058)
        height: width
        anchors.centerIn: parent
        radius: width * .5
        color: sessionRunTheme.summaryColor
    }

    ProgressRing {
        id: progressRing
        width: parent.width * .5
        height: width
        anchors.centerIn: parent

        controlValue: sessionRunner.values.activeProgress
        timeValue: sessionRunner.values.activeTime
        progressRingTheme: sessionRunTheme.progressRing
    }

    CustomLabel {
        id: totalTimeLabel

        width: parent.width * .8
        height: parent.height * .0325
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: progressIndicator.top
            bottomMargin: parent.height * .05
        }

        color: sessionRunTheme.headerColor
        fontWeight: Font.DemiBold
        fontItalic: true

        text: baseLiterals.totalTimeLeft.arg(sessionRunner.values.sessionTimeLeft)
    }

    Rectangle {
        id: progressIndicator

        width: parent.width * .75
        height: parent.height * .005

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: controlsItem.top
            bottomMargin: parent.height * .05
        }

        color: sessionRunTheme.noProgressColor

        property real progressMark: width * sessionRunner.values.sessionProgress

        Rectangle {
            width: progressIndicator.progressMark
            height: progressIndicator.height

            color: sessionRunTheme.headerColor
        }

        Rectangle {
            width: height
            height: parent.height * 4
            radius: height * .5

            anchors.verticalCenter: parent.verticalCenter
            x: progressIndicator.progressMark - radius

            color: progressIndicator.progressMark
                   ? sessionRunTheme.headerColor
                   : sessionRunTheme.noProgressColor
        }
    }

    // Controls
    Item {
        id: controlsItem

        width: parent.width * .6
        height: parent.height * .065

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * .02
            horizontalCenter: parent.horizontalCenter
        }

        Row {
            anchors.fill: parent
            spacing: 0

            Repeater {
                model: controlsModel

                Item {
                    implicitWidth: controlsItem.width / 3
                    implicitHeight: controlsItem.height

                    ImageButton {
                        width: parent.width * modelData.widthRation
                        anchors.centerIn: parent

                        source: modelData.source
                        enabled: modelData.enabled
                        callback: modelData.callback
                    }
                }
            }
        }
    }

    property var controlsModel: [
        {
            "widthRation": .5,
            "source": sessionViewTheme.editIcon,
            "enabled": !sessionRunner.running,
            "callback": function() {
                if(sessionRunner.sessionStarted()) {
                    sessionView.openPrompt(editPromptModel)
                } else {
                    sessionView.switchToView(0)
                }
            }
        },
        {
            "widthRation": .7,
            "source": sessionRunner.running ? sessionViewTheme.pauseIcon : sessionViewTheme.playIcon,
            "enabled": true,
            "callback": function() {
                if (sessionRunner.running)
                    sessionRunner.stop()
                else
                    sessionRunner.start()
            }
        },
        {
            "widthRation": .5,
            "source": sessionViewTheme.stopIcon,
            "enabled": !sessionRunner.running,
            "callback": function() {
                sessionView.openPrompt(stopPromptModel)
            }
        }
    ]

    property var editPromptModel:  [
        [
            baseLiterals.cancel,
            sessionView.closePrompt
        ],
        [
            baseLiterals.continueLiteral,
            function() {
                sessionView.switchToView(0)
            }
        ],
        [
            baseLiterals.editSessionAlertLine1,
            baseLiterals.editSessionAlertLine2
        ]
    ]

    property var stopPromptModel:  [
        [
            baseLiterals.cancel,
            sessionView.closePrompt
        ],
        [
            baseLiterals.end,
            function() {
                sessionRunner.stop(true)
            }
        ],
        [
            baseLiterals.endSessionAlertLine1,
            baseLiterals.endSessionAlertLine2
        ]
    ]

    MediaPlayer {
        id: alertsPlayer

        audioOutput: AudioOutput {
            volume: 1
        }
    }

    /*** Connections *******************************************************************/
    Connections {
        target: sessionRunner

        function onSessionCompleted() {
            sessionView.loadRunSummary()
        }

        function onActiveEntryCompleted() { 
            alertsPlayer.source = sessionRunTheme.beepLongAlert
            alertsPlayer.play()
        }

        function onThreeTwoOne() {
            alertsPlayer.source = sessionRunTheme.beepAlert
            alertsPlayer.play()
        }
    }
}
