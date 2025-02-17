import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0

Popup {

    /*** Properties ********************************************************************/

    id: customOverlay
    width: overlaySourceTheme.width
    height: overlaySourceTheme.height
    anchors.centerIn: parent

    property alias closeButtonVisible: closeBtn.visible

    modal: true
    Overlay.modal: CustomModal {
        modalOpacity: .75
    }

    padding: 0

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property QtObject overlayTheme: baseTheme.customItems.overlay
    property QtObject overlaySourceTheme: emptyOverlaySourceTheme

    QtObject {
        id: emptyOverlaySourceTheme
        property real height: 0
        property real width: 0
        property string source: baseLiterals.emptyString
    }

    property var inArgs
    property var outArgs

    /*** Layout ************************************************************************/

    // Background
    background: Item {

    }

    // Loader
    Loader {
        id: overlayLoader
        anchors.fill: parent
        source: overlaySourceTheme.source
    }

    // Close button
    ImageButton {
        id: closeBtn
        width: parent.width * .065
        anchors {
            right: parent.right
            top: parent.top
            margins: parent.width * .02
        }

        source: overlayTheme.closeIcon
        callback: customOverlay.close
    }

    /*** Functions *********************************************************************/

    onClosed: {
       overlaySourceTheme = emptyOverlaySourceTheme

       resetArgs()
    }

    function resetArgs() {
        inArgs = undefined
        outArgs = undefined
    }
}
