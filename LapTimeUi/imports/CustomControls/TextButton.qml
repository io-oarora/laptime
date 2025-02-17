import QtQuick 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/
    id: textButton

    scale: stateTheme.btnScale
    opacity: stateTheme.btnOpacity

    property alias callback: textButtonMa.callback
    property alias label: buttonLabel

    QtObject {
        id: stateTheme

        property real btnOpacity: 1
        property real btnScale: 1
    }

    /*** Layout ************************************************************************/

    CustomLabel {
        id: buttonLabel
        anchors.fill: parent
    }

    CustomMouseArea {
        id: textButtonMa
    }

    /*** States *************************************************************************/

    states: [
        State {
            when: !textButton.enabled
            PropertyChanges {
                target: stateTheme
                btnOpacity: .4
            }
        },
        State {
            when: textButtonMa.pressed
            PropertyChanges {
                target: stateTheme
                btnOpacity: .7
                btnScale: 1.05
            }
        },
        State {
            when: textButtonMa.containsMouse
            PropertyChanges {
                target: stateTheme
                btnOpacity: .8
            }
        }
    ]
}
