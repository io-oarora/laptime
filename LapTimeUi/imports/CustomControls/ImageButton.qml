import QtQuick 2.15

import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: imageBtn
    height: width

    scale: stateTheme.btnScale
    opacity: stateTheme.btnOpacity

    property alias callback: imageButtonMa.callback
    property alias iconWidth: image.width
    property alias source: image.source

    QtObject {
        id: stateTheme

        property real btnOpacity: 1
        property real btnScale: 1
    }

    /*** Layout ************************************************************************/

    Image {
        id: image
        width: parent.width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit

        layer.enabled: imageBtn.enabled
        layer.effect: CustomShadow {
        }
    }

    CustomMouseArea {
        id: imageButtonMa
    }

    /*** States *************************************************************************/

    states: [
        State {
            when: !imageBtn.enabled
            PropertyChanges {
                target: stateTheme
                btnOpacity: .3
            }
        },
        State {
            when: imageButtonMa.pressed
            PropertyChanges {
                target: stateTheme
                btnOpacity: .7
                btnScale: 1.05
            }
        },
        State {
            when: imageButtonMa.containsMouse
            PropertyChanges {
                target: stateTheme
                btnOpacity: .8
            }
        }
    ]
}
