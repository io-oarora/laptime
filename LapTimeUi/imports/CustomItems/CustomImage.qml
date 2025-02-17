import QtQuick 2.15

Item {

    /*** Properties ********************************************************************/

    id: customImage

    property alias source: img.source

    /*** Layout ************************************************************************/

    Image {
        id: img
        width: parent.width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
    }
}
