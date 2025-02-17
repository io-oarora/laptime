import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {

    /*** Properties ********************************************************************/

    id: progressRing

    property color baseColor: progressRingTheme.baseColor
    property color controlColor: Qt.rgba(Math.min(1, controlValue) * .625,
                                         .008,
                                         .36,
                                         1)
    property real controlValue
    property string timeValue

    property QtObject progressRingTheme

    /*** Layout ************************************************************************/
    Rectangle
    {
        id: outerRing

        width: parent.width
        height: width
        anchors.centerIn: parent
        radius: width * .5
        color: progressRingTheme.fillColor

        border {
            width: outerRing.width * .058
            color: progressRingTheme.baseColor
        }
    }

    ConicalGradient
    {
        source: outerRing
        anchors.fill: outerRing
        gradient: Gradient
        {
            GradientStop {
                position: controlValue - Math.min(1 - controlValue, .05)
                color: controlColor
            }
            GradientStop {
                position: controlValue
                color: controlValue == 1 ? controlColor : baseColor
            }
        }
    }

    Rectangle {
        id: backRing
        width: outerRing.width - (outerRing.border.width * .75)
        height: width
        radius: width * .5
        anchors.centerIn: outerRing

        color: progressRingTheme.fillColor
        border {
            width: backCircle.width * .012
            color: controlColor
        }
    }

    Rectangle {
        width: outerRing.border.width
        height: width
        radius: width * .5
        color: controlColor

        anchors {
            top: outerRing.top
            horizontalCenter: outerRing.horizontalCenter
        }
    }

    CustomLabel {
        width: parent.width * .8
        height: parent.height * .2

        anchors.centerIn: parent
        color: controlColor

        text: timeValue
    }
}
