import QtQuick 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {
    /*** Properties ********************************************************************/

    id: closeButton

    scale: stateTheme.btnScale
    opacity: stateTheme.btnOpacity

    property alias callback: closeButtonMa.callback

    property QtObject closeButtonTheme: baseTheme.session.closeButton

    QtObject {
        id: stateTheme

        property real btnOpacity: 1
        property real btnScale: 1
    }

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        anchors.fill: parent
        radius: height * .5

        layer.enabled: true
        layer.effect: CustomShadow { }

        color: closeButtonTheme.backColor
    }

    // Label
    CustomLabel {
        id: label

        width: parent.width
        height: parent.height * .5
        anchors.centerIn: parent

        color: closeButtonTheme.labelColor
        fontWeight: Font.DemiBold

        text: baseLiterals.close
    }

    CustomMouseArea {
        id: closeButtonMa
    }

    /*** States *************************************************************************/

    states: [
        State {
            when: closeButtonMa.pressed
            PropertyChanges {
                target: stateTheme
                btnOpacity: .7
                btnScale: 1.05
            }
        },
        State {
            when: closeButtonMa.containsMouse
            PropertyChanges {
                target: stateTheme
                btnOpacity: .8
            }
        }
    ]
}
