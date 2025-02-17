import QtQuick 2.15
import QtQuick.Layouts 1.15

import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: info
    anchors.centerIn: parent

    property QtObject infoTheme: landingScreenTheme.info

    /*** Layout ************************************************************************/

    // Background
    Rectangle {
        anchors.fill: parent
        color: infoTheme.backColor
        radius: Math.min(width * .0386, height * .0568)

        layer.enabled: true
        layer.effect: CustomShadow {
        }
    }

    // Content
    RowLayout {
        spacing: 0

        // Logo
        Item {
            implicitWidth: info.width * .35
            implicitHeight: info.height

            CustomImage {
                width: parent.width * .8
                anchors.centerIn: parent

                source: landingScreenTheme.logo
            }
        }

        Item {
            id: labelsItem
            implicitWidth: info.width * .6
            implicitHeight: info.height

            ColumnLayout {
                spacing: 0

                Item {
                    implicitWidth: labelsItem.width
                    implicitHeight: labelsItem.height * .125
                }

                Item {
                    implicitWidth: labelsItem.width
                    implicitHeight: labelsItem.height * .3

                    CustomLabel {
                        width: parent.width * .7
                        height: parent.height
                        anchors.centerIn: parent

                        color: infoTheme.labelColor
                        fontWeight: Font.Bold

                        text: baseLiterals.appName
                    }
                }
                Item {
                    implicitWidth: labelsItem.width
                    implicitHeight: labelsItem.height * .125

                    CustomLabel {
                        width: parent.width * .2
                        height: parent.height
                        anchors.centerIn: parent

                        color: infoTheme.labelColor
                        fontWeight: Font.DemiBold

                        text: baseLiterals.version
                    }
                }
                //                Item {
                //                    implicitWidth: labelsItem.width
                //                    implicitHeight: labelsItem.height * .125

                //                    CustomLabel {
                //                        width: parent.width * .6
                //                        height: parent.height
                //                        anchors.centerIn: parent

                //                        color: infoTheme.labelColor1

                //                        text: baseLiterals.upToDate
                //                    }
                //                }
                Item {
                    implicitWidth: labelsItem.width
                    implicitHeight: labelsItem.height * .225

                    CustomLabel {
                        width: parent.width
                        height: parent.height * .3
                        anchors {
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }

                        color: infoTheme.labelColor

                        text: baseLiterals.copyright
                    }
                }
                Item {
                    implicitWidth: labelsItem.width
                    implicitHeight: labelsItem.height * .225

                    CustomLabel {
                        width: parent.width * .6
                        height: parent.height * .5
                        anchors {
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }

                        text: infoTheme.mailHyperlink.arg(baseLiterals.supportEmail)
                    }
                }
            }
        }
    }
}
