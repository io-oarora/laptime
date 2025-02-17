import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionSummary

    property QtObject sessionSummaryTheme: baseTheme.session
    property var sessionModel: sessionView.getSessionModel()

    property var durationSummary: [
        {
            "label": baseLiterals.start,
            "value": sessionModel.values.startTime
        },
        {
            "label": baseLiterals.end,
            "value": sessionModel.values.stopTime
        },
        {
            "label": baseLiterals.timeElapsed,
            "value": sessionModel.values.lapsedTime
        }
    ]


    /*** Layout ************************************************************************/

    // Summary
    Item {
        id: contentsItem

        width: parent.width * .7
        height: parent.height * .325

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        CustomLabel {
            id: outcomeLabel
            width: contentsItem.width
            height: contentsItem.height * .115

            color: sessionSummaryTheme.summaryColor
            fontWeight: Font.Bold

            text: sessionModel.values.sessionCompleted ?
                      baseLiterals.sessionCompleted :
                      baseLiterals.sessionStopped
        }

        Column {
            anchors.top: outcomeLabel.bottom

            spacing: contentsItem.height * .05

            Repeater {
                model: durationSummary

                Row {
                    spacing: 0

                    Item {
                        width: contentsItem.width * .4
                        height: contentsItem.height * .2

                        CustomLabel {
                            width: parent.width
                            height: parent.height * .5

                            anchors.bottom: parent.bottom

                            horizontalAlignment: Text.AlignLeft

                            color: sessionSummaryTheme.summaryColor
                            fontWeight: Font.DemiBold

                            text: modelData.label
                        }
                    }

                    Item {
                        width: contentsItem.width * .2
                        height: contentsItem.height * .2

                        CustomLabel {
                            width: parent.width
                            height: parent.height * .5

                            anchors.bottom: parent.bottom

                            color: sessionSummaryTheme.summaryColor
                            fontWeight: Font.DemiBold

                            text: baseLiterals.colon
                        }
                    }

                    Item {
                        width: contentsItem.width * .4
                        height: contentsItem.height * .2

                        CustomLabel {
                            width: parent.width
                            height: parent.height * .5

                            anchors.bottom: parent.bottom

                            horizontalAlignment: Text.AlignRight

                            color: sessionSummaryTheme.summaryColor
                            fontWeight: Font.DemiBold

                            text: modelData.value
                        }
                    }
                }
            }
        }
    }

    Item {
        id: setCountItem
        width: parent.width * .65
        height: parent.height * .07

        anchors {
            top: contentsItem.bottom
            topMargin: parent.height * .02
            horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 0
            anchors.centerIn: parent

            Item {
                width: setCountItem.width * .35
                height: setCountItem.height

                Rectangle
                {
                    width: parent.width
                    height: parent.height * .025
                    anchors.centerIn: parent

                    color: sessionSummaryTheme.summaryColor
                }
            }

            Item
            {
                width: setCountItem.width * .3
                height: setCountItem.height

                CustomLabel {
                    width: parent.width
                    height: parent.height * .45

                    anchors.centerIn: parent

                    color: sessionSummaryTheme.summaryColor
                    fontWeight: Font.DemiBold

                    text: {
                        var totalSets = sessionModel.values.setCount
                        var output = totalSets === 1 ?
                                    baseLiterals.setCount1 :
                                    baseLiterals.setCountPlural.arg(totalSets)
                        return output
                    }
                }
            }

            Item {
                width: setCountItem.width * .35
                height: setCountItem.height

                Rectangle
                {
                    width: parent.width
                    height: parent.height * .025
                    anchors.centerIn: parent

                    color: sessionSummaryTheme.summaryColor
                }
            }
        }
    }

    // ListView
    Item {
        id: setListItem
        width: parent.width * .9

        anchors {
            top: setCountItem.bottom
            topMargin: parent.height * .05
            bottom: closeButton.top
            bottomMargin: parent.height * .1
            horizontalCenter: parent.horizontalCenter
        }

        property real setListHeight: setListItem.height * (.5 * Math.min(
                                                               sessionModel.values.setCount,
                                                               2))
        property real setHeight: setListItem.height * .42


        ListView {
            id: setList
            width: parent.width
            height: setListItem.setListHeight

            model: sessionSummary.sessionModel
            clip: true
            spacing: height * .125
            delegate: SessionSet {
                implicitWidth: setList.width
                implicitHeight: setListItem.setHeight

                summaryMode: true
                enabled: false
            }
        }

        CustomScrollBar {
            id: verticalScrollBar
            width: parent.width * .0375
            height: setList.height * .9
            anchors {
                right: parent.right
                rightMargin: parent.width * .02
                verticalCenter: setList.verticalCenter
            }

            orientation: Qt.Vertical
            position: setList.visibleArea.yPosition
            pageSize: setList.visibleArea.heightRatio

            barColor: sessionSummaryTheme.headerColor
        }
    }

    // Close button
    CloseButton {
        id: closeButton

        width: parent.width * .3
        height: parent.height * .065

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * .02
            horizontalCenter: parent.horizontalCenter
        }
        callback: sessionView.resetSession
    }
}
