import QtQuick 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {
    /*** Properties ********************************************************************/

    id: readyButton

    scale: stateTheme.btnScale
    opacity: stateTheme.btnOpacity

    property alias callback: readyButtonMa.callback

    property QtObject readyButtonTheme: baseTheme.session.readyButton

    QtObject {
        id: stateTheme

        property real btnOpacity: 1
        property real btnScale: 1
        property color labelColor: readyButtonTheme.labelColor
        property string icon: readyButtonTheme.icon
    }

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        anchors.fill: parent
        radius: height * .5

        layer.enabled: readyButton.enabled
        layer.effect: CustomShadow { }

        color: readyButtonTheme.backColor
    }

    Row {
        anchors.centerIn: parent
        spacing: 0

        // Icon
        CustomImage {
            width: readyButton.width * .15
            anchors.verticalCenter: parent.verticalCenter

            source: stateTheme.icon
        }

        Rectangle {
            width: readyButton.width * .05
            height: readyButton.height
            color: readyButtonTheme.dividerColor
        }

        // Label
        CustomLabel {
            id: label

            width: readyButton.width * .6
            height: readyButton.height * .5

            anchors.verticalCenter: parent.verticalCenter

            color: stateTheme.labelColor
            fontWeight: Font.DemiBold
            horizontalAlignment: Text.AlignRight

            text: baseLiterals.ready
        }
    }



    CustomMouseArea {
        id: readyButtonMa
    }

    /*** States *************************************************************************/

    states: [
        State {
            when: !readyButton.enabled
            PropertyChanges {
                target: stateTheme
                btnOpacity: .5
                labelColor: readyButtonTheme.labelDisabledColor
                icon: readyButtonTheme.iconDisabled
            }
        },
        State {
            when: readyButtonMa.pressed
            PropertyChanges {
                target: stateTheme
                btnOpacity: .7
                btnScale: 1.05
            }
        },
        State {
            when: readyButtonMa.containsMouse
            PropertyChanges {
                target: stateTheme
                btnOpacity: .8
            }
        }
    ]
}
