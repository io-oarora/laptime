import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import CustomItems 1.0
import Landing 1.0
import History 1.0
import Presets 1.0
import Session 1.0
import Themes 1.0

ApplicationWindow {

    /*** Properties ********************************************************************/

    id: appWindow

    width: baseTheme.appWidth
    height: baseTheme.appHeight
    minimumWidth: baseTheme.appMinWidth
    minimumHeight: baseTheme.appMinHeight
    visible: true

    title: baseLiterals.appName

    property QtObject baseTheme: LapTimeTheme
    property QtObject baseLiterals: baseTheme.literals

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        id: appBackground
        anchors.fill: parent
        color: baseTheme.main.backColor
    }

    // Sidebar
    Sidebar {
        id: sidebar
        z: 100
    }

    // Landing screen
    LandingScreen {
        id: landingScreen
        visible: false
    }

    // Modes
    SwipeView {
        id: appModes

        anchors.fill: parent
        orientation: Qt.Vertical
        interactive: false

        //visible: false
        visible: true

        SessionView {
            id: sessionView
        }

        PresetsScreen {
            id: presetsScreen
        }

        HistoryScreen {
            id: historyScreen
        }
    }

    Timer {
        id: toastTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: mainOverlay.close()
    }

    /*** Overlays and components *********************************************************/

    CustomOverlay {
        id: mainOverlay
        closeButtonVisible: false
    }


    /*** Functions *********************************************************************/
    onWidthChanged: resize()
    onHeightChanged: resize()

    function resize() {
        baseTheme.appWidth = width
        baseTheme.appHeight = height
    }

    function loadToast() {
        mainOverlay.overlaySourceTheme = baseTheme.customItems.toast
        mainOverlay.inArgs = baseLiterals.pressToExit
        mainOverlay.open()
    }

    function handleBackButton(event) {
        if (toastTimer.running) {
            event.accepted = false
        } else {
            loadToast()
            toastTimer.start()
            event.accepted = true
        }
    }

    Component.onCompleted: {
        contentItem.Keys.released.connect(
                    function(event) {
                        if (event.key === Qt.Key_Back) {
                            handleBackButton(event)
                        }
                    })
    }
}
