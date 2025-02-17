import QtQuick 2.15

Item {

    /*** Properties ********************************************************************/

    id: toast

    property string message: inArgs? inArgs : ""
    property QtObject toastTheme: baseTheme.customItems.toast

    /*** Layout ************************************************************************/

    Item {
        id: toastItem

        width: parent.width * .5
        height: parent.height * .035

        anchors.horizontalCenter: parent.horizontalCenter
        y: toast.height * .95 - toastItem.height

        // Background
        Rectangle {
            anchors.fill: parent
            opacity: .75
            radius: Math.min(width * .024,
                             height * .156)

            layer.enabled: true
            layer.effect: CustomShadow {
            }

            color: toastTheme.backColor
        }

        // Message
        CustomLabel {
            width: parent.width * .8
            height: parent.height * .7
            anchors.centerIn: parent

            fontWeight: Font.DemiBold
            color: toastTheme.messageColor

            text: toast.message
        }
    }
}
