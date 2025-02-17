import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

    /*** Properties ********************************************************************/

    id: customLabel

    property alias color: label.color
    property alias labelContentWidth: label.contentWidth
    property alias fontItalic: label.font.italic
    property alias fontUnderline: label.font.underline
    property alias fontWeight: label.font.weight
    property alias text: label.text
    property alias horizontalAlignment: label.horizontalAlignment
    property alias verticalAlignment: label.verticalAlignment

    property int maximumPixelSize: 600

    /*** Layout ************************************************************************/

    Label {
        id: label

        anchors.fill: parent

        font.pixelSize: maximumPixelSize
        font.weight: Font.Normal
        font.family: baseTheme.appFontFamily

        minimumPixelSize: 1
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
