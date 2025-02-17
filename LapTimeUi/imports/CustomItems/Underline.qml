import QtQuick 2.15

Item {

    /*** Properties ********************************************************************/

    id: underline

    property QtObject underlineTheme: baseTheme.customItems.underline
    property bool shadow: true

    /*** Layout ************************************************************************/

    Rectangle {
        id: line
        width: parent.width * .5
        height: parent.height * .2
        color: underlineTheme.lineColor

        layer.enabled: shadow
        layer.effect: CustomShadow {
        }
        anchors.centerIn: parent
    }
}
