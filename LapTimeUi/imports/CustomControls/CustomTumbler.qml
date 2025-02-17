import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/
    id: customTumbler

    property alias label: tumblerLabel
    property alias tumbler: tumblerWheel

    /*** Layout ************************************************************************/

    CustomLabel {
        id: tumblerLabel
        width: parent.width
        height: parent.height * .075

        anchors {
            top: parent.top
            topMargin: parent.height * .1
        }
    }

    Tumbler {
        id: tumblerWheel
        width: parent.width
        height: parent.height * .5
        anchors.centerIn: parent

        delegate: tumblerLabelDelegate

        visibleItemCount: 3
        visible: customTumbler.enabled
    }

    Tumbler {
        id: tumblerWheelDisabled
        width: parent.width
        height: parent.height * .5
        anchors.centerIn: parent

        delegate: tumblerLabelDelegate

        visibleItemCount: 3
        model: ["--"]
        visible: !customTumbler.enabled
    }

    /*** Functions **********************************************************************/

    Component {
        id: tumblerLabelDelegate

        CustomLabel {
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            maximumPixelSize: Math.min(customTumbler.width * .216,
                                       customTumbler.height * .07)

            text: modelData
        }
    }

    /*** Functions **********************************************************************/

    function reset() {
        tumblerWheel.currentIndex = 0
    }
}
