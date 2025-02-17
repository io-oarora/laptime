import QtQuick 2.15
import QtQuick.Controls 2.15

import CustomControls 1.0
import CustomItems 1.0
import Themes 1.0

Item {

    /*** Properties ********************************************************************/

    id: sidebar
    anchors.fill: parent

    property bool expanded: false

    property QtObject sidebarTheme: baseTheme.landing.sidebar

    QtObject {
        id: stateTheme

        property real menuWidth: sidebar.width * .15
        property real modalOpacity: .75
    }

    property var menuModel: [
        baseLiterals.session//,
//        baseLiterals.presets,
//        baseLiterals.history
    ]

    /*** Layout ************************************************************************/

    // Background
    CustomModal {
        modalOpacity: stateTheme.modalOpacity
        simulationDuration: sidebarTheme.animDuration
        callback: sidebar.toggle
    }

    // Sidebar control
    Item {
        id: sidebarControl
        width: parent.width * .15
        height: width

        anchors {
            top: parent.top
            topMargin: parent.height * .075
            right: sidebarMenu.right
            rightMargin: - width * .45
        }

        Rectangle {
            anchors.fill: parent

            radius: width * .05
            color: sidebarTheme.menuColor
            rotation: 45
            layer.enabled: true
            layer.effect: CustomShadow {
            }

            CustomMouseArea {
                callback: sidebar.toggle
            }
        }

        CustomImage {
            width: parent.width * .25
            height: width
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.width * .05
            }
            source: sidebarTheme.controlArrowImg
        }
    }

    // Sidebar menu
    Item {
        id: sidebarMenu
        width: stateTheme.menuWidth
        height: parent.height

        Behavior on width {
            NumberAnimation { duration: sidebarTheme.animDuration }
        }

        Rectangle {
            anchors.fill: parent
            color: sidebarTheme.menuColor
            MouseArea {
                anchors.fill: parent
            }
        }

        ImageButton {
            id: homeButton
            width: parent.width * .75
            anchors {
                top: parent.top
                topMargin: parent.height * .02
                horizontalCenter: parent.horizontalCenter
            }

            source: sidebarTheme.homeBtnImg
            callback: function() {
                menuList.currentIndex = -1
                appModes.visible = false
                landingScreen.visible = true

                sidebar.expanded = false
            }
        }

        ListView {
            id: menuList
            width: parent.width
            height: parent.height * .15
            //height: parent.height * .4
            anchors {
                bottom: parent.bottom
                bottomMargin: parent.height * .05
            }
            spacing: 0
            model: menuModel
            delegate: SidebarMenuItem {

                implicitWidth: menuList.width 
                implicitHeight: menuList.height * .9
                //implicitHeight: menuList.height * (1/3)
            }
            currentIndex: 0
            //currentIndex: -1
        }
    }

    /*** States ************************************************************************/
    states: [
        State {
            when: !sidebar.expanded
            PropertyChanges {
                target: stateTheme
                menuWidth: 0
                modalOpacity: 0
            }
        }
    ]

    /*** Functions *********************************************************************/
    function toggle() {
        sidebar.expanded = !sidebar.expanded
    }
}


