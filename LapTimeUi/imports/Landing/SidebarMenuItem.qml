import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0
import Themes 1.0

Item {

    /*** Properties ********************************************************************/

    id: sidebarMenuItem
    opacity: stateTheme.itemOpacity

    property QtObject menuItemTheme: baseTheme.landing.sidebar.menuItem
    property bool selected: menuList.currentIndex === index

    QtObject {
        id: stateTheme

        property color stateColor: menuItemTheme.unselectedColor
        property int fontWeight: Font.Normal
        property bool underlineVisible: false
        property real itemOpacity: 1
        property real labelScale: 1
    }

    /*** Layout ************************************************************************/

    CustomLabel {
        id: itemLabel
        width: parent.height * .9
        height: parent.width * .5
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * .1
            horizontalCenter: parent.horizontalCenter
        }

        fontWeight: stateTheme.fontWeight
        rotation: -90
        color: stateTheme.stateColor
        scale: stateTheme.labelScale

        text: modelData
    }

    Rectangle {
        width: parent.width * .075
        height: parent.height * .9
        anchors {
            verticalCenter: itemLabel.verticalCenter
            right: parent.right
        }
        color: stateTheme.stateColor
        visible: stateTheme.underlineVisible
    }

    CustomMouseArea {
        id: itemMa
        callback: sidebarMenuItem.switchToMode
    }

    /*** States ************************************************************************/

    states: [
        State {
            when: sidebarMenuItem.selected
            PropertyChanges {
                target: stateTheme
                stateColor: menuItemTheme.selectedColor
                fontWeight: Font.DemiBold
                underlineVisible: true
            }
        },
        State {
            when: !sidebarMenuItem.selected && itemMa.pressed
            PropertyChanges {
                target: stateTheme
                itemOpacity: .7
                labelScale: 1.05
            }
        },
        State {
            when: !sidebarMenuItem.selected && itemMa.containsMouse
            PropertyChanges {
                target: stateTheme
                itemOpacity: .8
            }
        }
    ]

    /*** Functions *********************************************************************/

    function switchToMode() {
        menuList.currentIndex = index
        appModes.currentIndex = index
        appModes.visible = true
        landingScreen.visible = false

        sidebar.expanded = false
    }
}
