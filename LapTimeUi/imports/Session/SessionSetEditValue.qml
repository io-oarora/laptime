import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: setEditValue

    property bool valueAcceptable: true

    property string label
    property real valueIndex: 0

    signal valueChanged(value: int)

    /*** Layout ************************************************************************/

    Row {
        spacing: 0
        anchors.centerIn: parent

        Item {
            width: setEditValue.width * .375
            height: setEditValue.height

            CustomLabel {
                width: parent.width
                height: parent.height * .115

                anchors.centerIn: parent

                color: setEditTheme.contentColor

                text: "%0:".arg(label)
            }
        }

        CustomTumbler {
            id: valueTumbler
            width: setEditValue.width * .25
            height: setEditValue.height

            tumbler {
                model: [1, 2, 3, 4, 5, 6, 7, 8]
                currentIndex: valueIndex
                onCurrentIndexChanged: valueChanged(getValue())
            }
        }
    }

    /*** Functions *********************************************************************/
    function initTumbler(value) {
        valueIndex = value
    }

    function getValue() {
        return valueTumbler.tumbler.model[valueTumbler.tumbler.currentIndex]
    }
}
