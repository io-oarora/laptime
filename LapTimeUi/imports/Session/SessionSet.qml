import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0

Item {

    /*** Properties ********************************************************************/

    id: sessionSet
    opacity: stateTheme.setOpacity
    scale: stateTheme.setScale

    layer.enabled: sessionSet.enabled
    layer.effect: CustomShadow {
    }

    property alias callback: sessionSetMa.callback
    property bool summaryMode: false
    property QtObject sessionSetTheme: baseTheme.session.sessionSet

    property var setData: [
        {
            "label": baseLiterals.delay,
            "value": r_delay
        },
        {
            "label": baseLiterals.lapTime,
            "value": r_lapTime
        },
        {
            "label": baseLiterals.laps,
            "value": r_laps
        },
        {
            "label": baseLiterals.rest,
            "value": r_laps === 1 ? "--:--" : r_rest
        }
    ]

    QtObject {
        id: stateTheme

        property real setOpacity: 1
        property real setScale: 1
    }

    NumberAnimation on implicitHeight {
        id: detDeleteAnim

        to: 0
        duration: 100
        running: false
        onFinished: deleteSet()
    }

    /*** Layout ************************************************************************/

    Flickable {
        id: setFlickable
        width: sessionSet.width * .8
        height: sessionSet.height
        contentWidth: sessionSet.width
        contentHeight: sessionSet.height

        anchors.centerIn: parent

        boundsBehavior: Flickable.StopAtBounds
        clip: true
        enabled: !summaryMode

        Rectangle {
            width: sessionSet.width
            height: sessionSet.height
            radius: setBackground.radius

            color: setFlickable.contentX > 0 ? sessionSetTheme.borderColor :
                                               sessionSetTheme.flickedColor

            Item {
                id: setDetailsItem
                width: parent.width * .8
                height: parent.height

                Rectangle {
                    id: setBackground
                    anchors.fill: parent
                    radius: Math.min(width * .025,
                                     height * .065)
                    border {
                        width: setBackground.radius * .5
                        color: sessionSetTheme.borderColor
                    }

                    color: sessionSetTheme.backColor
                }

                // Title
                CustomLabel {
                    id: titleLabel

                    width: parent.width * .8
                    height: parent.height * .225
                    anchors {
                        top: parent.top
                        topMargin: parent.height * .025
                        horizontalCenter: parent.horizontalCenter
                    }

                    color: sessionSetTheme.borderColor
                    fontWeight: Font.Bold

                    text: r_title
                }

                // Content
                Grid {
                    id: setGrid
                    width: parent.width
                    anchors {
                        top: titleLabel.bottom
                        topMargin: parent.height * .025
                        bottom: parent.bottom
                        bottomMargin: parent.height * .025
                    }

                    rows: 2
                    columns: 2

                    Repeater {
                        model: setData

                        Item {
                            implicitWidth: setGrid.width * .5
                            implicitHeight: setGrid.height * .5

                            Item {
                                id: setContent
                                width: parent.width * .8
                                height: parent.height
                                anchors.centerIn: parent

                                Row {
                                    spacing: 0
                                    anchors.centerIn: parent

                                    CustomLabel {
                                        width: setContent.width * .6
                                        height: setContent.height * .5

                                        color: sessionSetTheme.contentColor
                                        fontWeight: Font.DemiBold
                                        horizontalAlignment: Text.AlignLeft

                                        text: modelData.label
                                    }

                                    CustomLabel {
                                        width: setContent.width * .1
                                        height: setContent.height * .5

                                        color: sessionSetTheme.contentColor
                                        fontWeight: Font.DemiBold
                                        horizontalAlignment: Text.AlignLeft

                                        text: baseLiterals.colon
                                    }

                                    CustomLabel {
                                        width: setContent.width * .3
                                        height: setContent.height * .5

                                        color: sessionSetTheme.contentColor
                                        horizontalAlignment: Text.AlignLeft

                                        text: modelData.value
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: incompleteOverlay
                    anchors.fill: setBackground
                    color: sessionSetTheme.incompleteColor
                    opacity: .6
                    visible: summaryMode && !r_completed
                }

                CustomMouseArea {
                    id: sessionSetMa
                }
            }

            Rectangle {
                id: setDeleteItem
                width: parent.width * .2
                height: parent.height
                radius: setBackground.radius

                anchors.right: parent.right
                color: sessionSetTheme.borderColor

                ImageButton {
                    width: parent.width * .3
                    anchors.centerIn: parent
                    source: sessionSetTheme.deleteImg
                    callback: function() {
                        animateDelete()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: setFlickable

        radius: setBackground.radius
        border {
            width: setBackground.border.width
            color: setBackground.border.color
        }

        color: sessionSetTheme.flickedColor
    }


    /*** States ************************************************************************/
    states: [
        State {
            when: sessionSetMa.pressed
            PropertyChanges {
                target: stateTheme
                setOpacity: .9
                setScale: 1.02
            }
        }
    ]

    /*** Functions *********************************************************************/
    function animateDelete() {
        setDetailsItem.visible = false
        setDeleteItem.visible = false
        detDeleteAnim.running = true
    }

    function deleteSet() {
        sessionView.removeSet(index)
    }
}
