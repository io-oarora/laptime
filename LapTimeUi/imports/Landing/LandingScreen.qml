import QtQuick 2.15

import CustomControls 1.0
import CustomItems 1.0
import Themes 1.0

Item {

    /*** Properties ********************************************************************/

    id: landingScreen
    anchors.fill: parent

    property QtObject landingScreenTheme: baseTheme.landing

    /*** Layout ************************************************************************/

    CustomLabel {
        width: parent.width * .6
        height: parent.height * .05
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: logo.top
            bottomMargin: parent.height * .075
        }

        layer.enabled: true
        layer.effect: CustomShadow {
        }

        color: landingScreenTheme.labelsColor
        fontWeight: Font.Bold

        text: baseLiterals.appName
    }

    CustomImage {
        id: logo
        width: parent.width * .55
        height: width
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * .075
        }

        layer.enabled: true
        layer.effect: CustomShadow {
        }

        source: landingScreenTheme.logo
    }

    CustomLabel {
        width: parent.width * .6
        height: parent.height * .035
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * .2
        }

        layer.enabled: true
        layer.effect: CustomShadow {
        }

        fontWeight: Font.DemiBold
        fontItalic: true
        color: landingScreenTheme.labelsColor

        text: baseLiterals.appSlogan
    }

    ImageButton {
        id: infoBtn
        width: parent.width * .085
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: parent.width * .03
        }

        source: landingScreenTheme.infoImg
        callback: landingScreen.loadInfo
    }

    /*** Overlays and components *********************************************************/

    CustomOverlay {
        id: landingOverlay
    }

    function loadInfo() {
        landingOverlay.overlaySourceTheme = landingScreenTheme.info
        landingOverlay.open()
    }
}
