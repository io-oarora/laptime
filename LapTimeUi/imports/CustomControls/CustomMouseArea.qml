import QtQuick 2.15

MouseArea {

    /*** Properties ********************************************************************/

    id: customMouseArea

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

    property var callback

    /*** Functions **********************************************************************/

    onClicked: {
        if (callback)
            callback()
    }
}
