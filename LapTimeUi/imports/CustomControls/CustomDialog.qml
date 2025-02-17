import QtQuick 2.15

import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: dialog

    property QtObject dialogTheme: baseTheme.customControls.customDialog

    property var leftButtonParams: inArgs ? inArgs[0] : [baseLiterals.emptyString, undefined]
    property var rightButtonParams: inArgs ? inArgs[1] : [baseLiterals.emptyString, undefined]
    property var messageModel: inArgs ? inArgs[2] : ["", ""]

    /*** Layout ************************************************************************/

    Item {
        id: dialogItem
        width: parent.width * .9
        height: parent.height * .15

        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height

        NumberAnimation on y {
            id: dialogItemAnim

            to: dialog.height * .95 - dialogItem.height
            duration: 200
            running: false
        }

        // Background
        Rectangle {
            anchors.fill: parent
            radius: Math.min(width * .039,
                             height * .1)

            layer.enabled: true
            layer.effect: CustomShadow {
            }

            color: dialogTheme.backColor
        }

        // Message
        Item {
            id: messageItem
            width: parent.width
            anchors {
                top: parent.top
                topMargin: parent.height * .1
                bottom: buttonsItem.top
                bottomMargin: parent.height * .1
            }

            Column {
                spacing: 0

                Repeater {
                    model: messageModel

                    CustomLabel {
                        width: messageItem.width
                        height: messageItem.height * .4

                        fontWeight: Font.DemiBold
                        color: dialogTheme.messageColor

                        text: modelData
                    }
                }
            }
        }

        // Buttons
        Item {
            id: buttonsItem
            width: parent.width
            height: parent.height * .3

            anchors.bottom: parent.bottom

            TextButton {
                width: parent.width * .35
                height: parent.height * .6

                anchors {
                    right: buttonsDivider.left
                    rightMargin: parent.width * .125
                    verticalCenter: parent.verticalCenter
                }

                label {
                    fontWeight: Font.DemiBold
                    horizontalAlignment: Text.AlignRight
                    color: dialogTheme.buttonsTextColor

                    text: leftButtonParams[0]
                }
                callback: leftButtonParams[1]
            }

            Rectangle {
                id: buttonsDivider
                width: parent.width * .01
                height: parent.height * .75
                anchors.centerIn: parent

                color: dialogTheme.buttonsDividerColor
            }

            TextButton {
                width: parent.width * .35
                height: parent.height * .6

                anchors {
                    left: buttonsDivider.right
                    leftMargin: parent.width * .125
                    verticalCenter: parent.verticalCenter
                }

                label {
                    fontWeight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    color: dialogTheme.buttonsTextColor

                    text: rightButtonParams[0]
                }
                callback: rightButtonParams[1]
            }
        }
    }

    /*** Functions *********************************************************************/

    onVisibleChanged: {
        if (visible) {
            dialogItemAnim.running = true
        }
        else {
            dialogItem.y = dialog.height
        }
    }
}
