import QtQuick 6.5
import QtQuick.Window 6.5
import"components"

Rectangle{
    id:drawer
    property int animationDuration
    property int Height
    property int buttonWidth
    property int contentWidth

    property Component button
    property Component content

    property bool left:false
    property bool hovered: drawerMouse.containsMouse

    width:drawer.hovered?drawer.buttonWidth:

    anchors{
        top:parent.top
        right:drawer.left?undefined:parent.right
        left:drawer.left?parent.left:undefined
    }
    MouseArea{
        id:drawerMouse
        anchors.fill:parent
    }
     
}

