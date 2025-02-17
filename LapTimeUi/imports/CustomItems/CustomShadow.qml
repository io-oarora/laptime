import Qt5Compat.GraphicalEffects

DropShadow {

    /*** Properties ********************************************************************/

    id: customDropShadow

    property string shadowColor: "#80000000"

    /*** Layout ************************************************************************/

    transparentBorder: true
    horizontalOffset: 2
    verticalOffset: 2
    radius: 8
    color: customDropShadow.shadowColor
}
