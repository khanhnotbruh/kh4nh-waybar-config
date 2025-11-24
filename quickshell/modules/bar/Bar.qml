import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "components"
import "."

PanelWindow {
    id: topPanel
    anchors { top: true; left: true; right: true }
    implicitHeight: topPanel.hovered  ? 55 : 2          
    exclusiveZone: 0
    Behavior on height {
        NumberAnimation {
            duration:30
            easing.type: Easing.OutCubic
        }
    }
    property bool hovered: false

    color: "transparent"  
    MouseArea {
        anchors {
            left: parent.left
            right: parent.right
            margins: 50
        }
        height:55
        hoverEnabled: true
        onEntered: topPanel.hovered=true
        onExited: topPanel.hovered=false
    }
    Rectangle {
        id: topBar
        anchors {
            left: parent.left
            right: parent.right
            margins: 100   
        }

        y: topPanel.hovered ? 20 : -40
        z:1
        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        height: 35
        radius: 20
        color:"#ff050512"
        Drawer{
            drawerWidth:200
            Clock{
                anchors.centerIn: parent
            }
        }
    }
}
