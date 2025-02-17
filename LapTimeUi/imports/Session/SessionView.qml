import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionView

    property QtObject sessionViewTheme: baseTheme.session
    property var sessionModel: be_currentSession
    property var sessionRunner: be_sessionRunner

    /*** Layout ************************************************************************/

    // Label
    CustomLabel {
        id: header

        width: parent.width * .8
        height: parent.height * .04
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * .035
        }

        color: sessionViewTheme.headerColor
        fontWeight: Font.Bold

        layer.enabled: true
        layer.effect: CustomShadow {
        }

        text: baseLiterals.session
    }

    // Underline
    Underline {
        id: underline
        width: parent.width
        height: parent.height * .025

        anchors{
            top: header.bottom
            topMargin: parent.height * .01
        }
    }

    SwipeView {
        id: sessionSwipeView

        width: parent.width
        anchors {
            top: underline.bottom
            topMargin: parent.height * .03
            bottom: parent.bottom
            bottomMargin: parent.height * .03
        }

        orientation: Qt.Horizontal
        interactive: false
        clip: true

        SessionEdit {
            id: sessionEdit
        }

        SessionRun {
            id: sessionRun
        }

        SessionSummary {
            id: sessionSummary
        }
    }

    /*** Overlays and components *********************************************************/

    CustomOverlay {
        id: sessionViewOverlay
        closeButtonVisible: false
    }

    CustomOverlay {
        id: sessionViewInfoOverlay
    }

    /*** Functions *********************************************************************/

    function getSessionModel() {
        return sessionModel
    }

    function getSessionRunner() {
        return sessionRunner
    }

    function addSet() {
        var response = sessionModel.addSessionSet()

        if (!response.acceptable) {
            openInfoBox(response.message)
        }
    }

    function removeSet(setIndex) {
        sessionModel.removeSessionSet(setIndex)
    }

    function editSet(setData) {
        sessionViewOverlay.inArgs = setData
        sessionViewOverlay.overlaySourceTheme = sessionViewTheme.sessionSetEdit
        sessionViewOverlay.open()
    }

    function updateSet(setData) {
        var response = sessionModel.validateSessionDuration(setData)

        if (response.acceptable) {
            sessionModel.updateSet(setData)
            closeSetEdit()
        } else {
            openInfoBox(response.message)
        }
    }

    function calculateSetDuration(setMap) {
        return sessionModel.calculateSetDuration(setMap)
    }

    function closeSetEdit() {
        sessionViewOverlay.close()
    }

    function openPrompt(buttonData) {
        sessionViewOverlay.inArgs = buttonData
        sessionViewOverlay.overlaySourceTheme = baseTheme.customControls.customDialog
        sessionViewOverlay.open()
    }

    function closePrompt() {
        sessionViewOverlay.close()
    }

    function openInfoBox(message) {
        sessionViewInfoOverlay.inArgs = message.split("--")
        sessionViewInfoOverlay.overlaySourceTheme = baseTheme.customItems.customInfoBox
        sessionViewInfoOverlay.open()
    }

    function startRunSession() {
        sessionRunner.initRunner()
        switchToView(1)
    }

    function loadRunSummary() {
        switchToView(2)
    }

    function resetSession() {
        sessionModel.resetSession()
        switchToView(0)
    }

    function switchToView(index) {
        sessionViewOverlay.close()
        sessionSwipeView.currentIndex = index
    }
}
