import QtQuick
import Quickshell
//default property alias contentData: content.data
Item{
    id:drawer
    property int drawerWidth
    property bool hovered

    anchors{
        right:parent.right
        top:parent.top
        bottom:parent.bottom
        rightMargin:25+5
    }

    width: drawer.hovered ? drawerWidth : 10
    height: parent ? parent.height : 25 // fallback
    z: 2
    //the expand box
    Rectangle{
        color:"#ffffff"
        Item{
            id:content
            default property alias contentData: content.data
        }
    }
    Rectangle{
        id:button
        width:10
        anchors{
            top:parent.top
            bottom:parent.bottom
            right:parent.right
        }
        MouseArea{
            acceptedButtons: Qt.NoButton
            hoverEnabled: true
            anchors.fill:parent
            z:4
            onExited: button.color="#000000" 
            onEntered:button.color="#ffffff"
        }
    }
}
