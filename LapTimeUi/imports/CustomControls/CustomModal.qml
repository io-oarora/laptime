import QtQuick 2.15

import CustomControls 1.0

Item {

    /*** Properties ********************************************************************/

    id: customModal
    anchors.fill: parent

    property alias callback: modalMa.callback
    property alias modalOpacity: modalRect.opacity
    property int simulationDuration: 0

    property QtObject modalTheme: baseTheme.customItems.customModal

    /*** Layout ************************************************************************/

    Rectangle {
        id: modalRect

        anchors.fill: parent
        color: modalTheme.color
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: simulationDuration }
        }

        CustomMouseArea {
            id: modalMa
        }
    }
}
