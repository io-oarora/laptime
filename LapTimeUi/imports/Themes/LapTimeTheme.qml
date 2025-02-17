pragma Singleton
import QtQuick 2.15

QtObject {

    id: lapTimeTheme

    property real appWidth: 720 * devRatio
    property real appHeight: 1600 * devRatio
    property real appMinWidth: 720 * devRatio
    property real appMinHeight: 1600 * devRatio
    property real devRatio: .5

    property string appFontFamily: getAppFont() // "Segoe UI"
    property string androidFontFamily: "Source Sans Pro"
    property string defaultFontFamily: "Arial"
    property string qrcImgPng: "qrc:/images/%0.png"
    property string qrcImportsQml: "qrc:/imports/%0.qml"

    property QtObject literals: appliterals.english

    property QtObject appColors: QtObject {
        id: appColors

        property color blackTone: "#101010"
        property color blackTone1: "#000000"
        property color creamTone: "#FFF7E6"
        property color creamTone1: "#DDD4BA"
        property color creamTone2: "#FFEECE"
        property color grayTone: "#7B7B7B"
        property color grayTone1: "#A7A7A7"
        property color tealTone: "#03989E"
        property color tealTone1: "#728485"
        property color tealTone2: "#679D9F"
        property color magentaTone: "#E30383"
        property color magentaTone1: "#DF8D84"
        property color magentaTone2: "#A0025C"
        property color transparent: "transparent"
    }

    property QtObject appliterals: QtObject {
        id: appliterals

        property QtObject english: QtObject {
            id: english

            property string appName: "LapTime"
            property string appSlogan: "Lap. Rest. Repeat"
            property string cancel: "Cancel"
            property string close: "Close"
            property string colon: ":"
            property string continueLiteral: "Continue"
            property string copyright: "Copyright © 2025 Oarora (Pty) Ltd"
            property string delay: "Delay"
            property string editSessionAlertLine1: "Editing at this point will"
            property string editSessionAlertLine2: "lose the current progress."
            property string emptyString: ""
            property string end: "End"
            property string endSessionAlertLine1: "Are you sure you would like"
            property string endSessionAlertLine2: "to end this session early?"
            property string history: "History"
            property string lapTime: "Lap Time"
            property string lapTimeInvalidMessage: "Lap Time cannot be 00:00"
            property string laps: "Laps"
            property string lapNo: "Lap %0"
            property string minutes: "Minutes"
            property string presets: "Presets"
            property string pressToExit: "Press again to exit!"
            property string ready: "Ready"
            property string rest: "Rest"
            property string save: "Save"
            property string seconds: "Seconds"
            property string session: "Session"
            property string sessionCompleted: "Session completed"
            property string sessionStopped: "Session stopped"
            property string setCount1: "1 set"
            property string setCountPlural: "%0 sets"
            property string setTitleEmptyMessage: "Set title cannot be empty"
            property string start: "Start"
            property string supportEmail: "io@oarora.com"
            property string timeElapsed: "Time Elapsed"
            property string totalTime: "Total time: %0"
            property string totalTimeLeft: "Time left: %0"
            property string updateAvailable: "Update available: v%0"
            property string upToDate: "LapTime is up to date."
            property string version: "v1.0.0"
        }
    }

    property QtObject customControls: QtObject {
        id: customControls

        property QtObject customDialog: QtObject {
            id: customDialog

            property color backColor: appColors.tealTone2
            property color buttonsDividerColor: appColors.magentaTone2
            property color buttonsTextColor: appColors.creamTone1
            property color messageColor: appColors.creamTone
            property real height: appHeight
            property real width: appWidth
            property string source: qrcImportsQml.arg("CustomControls/CustomDialog")
        }
    }

    property QtObject customItems: QtObject {
        id: customItems

        property QtObject customInfoBox: QtObject {
            id: customInfoBox

            property color backColor: appColors.tealTone2
            property color messageColor: appColors.creamTone
            property color buttonsTextColor: appColors.creamTone1
            property real height: appHeight * .275
            property real width: appWidth * .9

            property string infoImg: qrcImgPng.arg("landing/info")
            property string source: qrcImportsQml.arg("CustomItems/CustomInfoBox")
        }

        property QtObject customModal: QtObject {
            id: customModal

            property color color: appColors.blackTone
        }

        property QtObject overlay: QtObject {
            id: overlay

            property string closeIcon: qrcImgPng.arg("customItems/close")
        }

        property QtObject toast: QtObject {
            id: toast

            property color backColor: appColors.tealTone2
            property color messageColor: appColors.creamTone
            property real height: appHeight
            property real width: appWidth
            property string source: qrcImportsQml.arg("CustomItems/Toast")
        }

        property QtObject underline: QtObject {
            id: underline

            property color fill: appColors.transparent
            property color lineColor: appColors.creamTone
        }
    }

    property QtObject landing: QtObject {
        id: landing

        property color labelsColor: appColors.creamTone
        property string infoImg: qrcImgPng.arg("landing/info")
        property string logo: qrcImgPng.arg("landing/logo")

        property QtObject info: QtObject {
            id: info

            property color backColor: appColors.tealTone2
            property color labelColor: appColors.creamTone
            property color labelColor1: appColors.creamTone1
            property real height: appHeight * .275
            property real width: appWidth * .9
            property string mailHyperlink: "<a href=\"mailto:%1\">%1</a>"
            property string source: qrcImportsQml.arg("Landing/Info")
        }

        property QtObject sidebar: QtObject {
            id: sidebarTheme

            property color menuColor: appColors.creamTone
            property int animDuration: 100
            property string controlArrowImg: qrcImgPng.arg("landing/arrow")
            property string homeBtnImg: qrcImgPng.arg("landing/logo_small")

            property QtObject menuItem: QtObject {
                id: menuItem

                property color selectedColor: appColors.magentaTone
                property color unselectedColor: appColors.tealTone1
            }
        }
    }

    property QtObject main: QtObject {
        id: main

        property color backColor: appColors.tealTone
    }
    property QtObject session: QtObject {
        id: session

        property color headerColor: appColors.creamTone
        property color summaryColor: appColors.creamTone
        property color noProgressColor: appColors.grayTone1
        property string addIcon: qrcImgPng.arg("session/add")
        property string beepAlert: "qrc:/sounds/beep.wav"
        property string beepLongAlert: "qrc:/sounds/beep_long.wav"
        property string editIcon: qrcImgPng.arg("session/edit")
        property string pauseIcon: qrcImgPng.arg("session/pause")
        property string playIcon: qrcImgPng.arg("session/play")
        property string stopIcon: qrcImgPng.arg("session/stop")

        property QtObject closeButton: QtObject {
            id: closeButton

            property color backColor: appColors.creamTone
            property color labelColor: appColors.magentaTone2
        }

        property QtObject progressRing: QtObject {
            id: progressRing

            property color baseColor: appColors.creamTone
            property color fillColor: appColors.transparent
        }

        property QtObject readyButton: QtObject {
            id: readyButton

            property color backColor: appColors.creamTone
            property color dividerColor: appColors.transparent
            property color labelColor: appColors.magentaTone2
            property color labelDisabledColor: appColors.magentaTone1
            property string icon: qrcImgPng.arg("session/ready")
            property string iconDisabled: qrcImgPng.arg("session/readyDisabled")
        }

        property QtObject sessionSet: QtObject {
            id: sessionSet

            property color backColor: appColors.creamTone
            property color borderColor: appColors.magentaTone2
            property color contentColor: appColors.blackTone1
            property color flickedColor: appColors.transparent
            property color incompleteColor: appColors.grayTone
            property string deleteImg: qrcImgPng.arg("session/delete")
        }

        property QtObject sessionSetEdit: QtObject {
            id: sessionEdit

            property color backColor: appColors.creamTone2
            property color backBorderColor: appColors.magentaTone2
            property color contentColor: appColors.blackTone1
            property color titleEditBoxColor: appColors.creamTone
            property color titleEditBoxBorderColor: appColors.tealTone2
            property real height: appHeight * .45
            property real width: appWidth * .9
            property string swipeArrowImg: qrcImgPng.arg("session/arrow")
            property string source: qrcImportsQml.arg("Session/SessionSetEdit")
        }
    }
    /*** Functions *********************************************************************/
    function getAppFont() {
        switch (Qt.platform.os) {
        case 'android':
            return androidFontFamily
        default:
            return defaultFontFamily
        }
    }
}
