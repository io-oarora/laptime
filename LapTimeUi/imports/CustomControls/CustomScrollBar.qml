import QtQuick 2.15

Item {

    /*** Properties ********************************************************************/

    id: customScrollBar
    clip: true

    property real position
    property real pageSize
    property int orientation : Qt.Vertical
    property color barColor

    QtObject {
        id: stateTheme

        property real x: 1
        property real y: customScrollBar.position * (customScrollBar.height - 2) + 1
        property real height: customScrollBar.pageSize * (customScrollBar.height - 2)
        property real width: customScrollBar.width - 2
        property real radius: (stateTheme.width / 2) - 1
    }

    /*** Layout ************************************************************************/

    Rectangle {
        x: stateTheme.x
        y: stateTheme.y
        width: stateTheme.width
        height: stateTheme.height
        radius: stateTheme.radius
        color: barColor
    }

    /*************************************** States ***************************************/

    states: [
        State {
            when: customScrollBar.orientation === Qt.Horizontal
            PropertyChanges {
                target: stateTheme
                x: customScrollBar.position * (customScrollBar.width - 2) + 1
                y: 1
                height: customScrollBar.height - 2
                width: customScrollBar.pageSize * (customScrollBar.width - 2)
                radius: (stateTheme.height / 2) - 1
            }
        }
    ]
}
