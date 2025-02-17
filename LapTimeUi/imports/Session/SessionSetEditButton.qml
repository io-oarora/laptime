import QtQuick 2.15

import CustomControls 1.0

Item {

    /*** Properties ********************************************************************/
    id: sessionEditButton

    width: parent.width * .4
    height: parent.height * .4
    anchors.verticalCenter: parent.verticalCenter

    property alias callback: textButton.callback

    property string buttonText
    property string buttonTextColor

    /*** Layout ************************************************************************/

    TextButton {
        id: textButton
        width: parent.width
        height: parent.height * .7
        anchors.centerIn: parent

        label {
            fontWeight: Font.DemiBold
            color: buttonTextColor
            text: buttonText
        }
    }
}
