import QtQuick 2.15

import CustomControls 1.0

Item {

    /*** Properties ********************************************************************/

    id: infoBox
    anchors.centerIn: parent

    property QtObject infoBoxTheme: baseTheme.customItems.customInfoBox

    property var messageModel: inArgs ? inArgs : ["", ""]

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        anchors.fill: parent
        color: infoBoxTheme.backColor
        radius: Math.min(width * .0386, height * .0568)

        layer.enabled: true
        layer.effect: CustomShadow {
        }
    }

    // Content
    CustomImage {
        id: iconImg
        width: parent.width * .125

        anchors {
            top: parent.top
            topMargin: parent.height * .2
            horizontalCenter: parent.horizontalCenter
        }

        rotation: 180
        source: infoBoxTheme.infoImg
    }

    // Message
    Item {
        id: messageItem
        width: parent.width
        anchors {
            top: iconImg.bottom
            topMargin: parent.height * .2
            bottom: parent.bottom
            bottomMargin: parent.height * .1
        }

        Column {
            anchors.centerIn: parent
            spacing: 0

            Repeater {
                model: messageModel

                CustomLabel {
                    width: messageItem.width
                    height: messageItem.height * .225

                    fontWeight: Font.DemiBold
                    color: infoBoxTheme.messageColor

                    text: modelData
                }
            }
        }
    }
}
