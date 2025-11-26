import QtQuick
import Quickshell
import QtQuick.Controls
import "components"
import "../../"
import "."
PanelWindow {
    id: topPanel
    anchors { top: true; left: true; right: true }
    property bool hovered: barMouse.containsMouse || clockDrawer.hovered

    implicitHeight: topPanel.hovered ? Config.barY+Config.barHeight : 2           
    exclusiveZone: 0

    Behavior on height {
        NumberAnimation {
            duration:Config.barAnimation 
            easing.type: Easing.OutCubic
        }
    }

    color: "transparent"  

    MouseArea {
        id: barMouse 
        anchors {
            left: parent.left
            right: parent.right
            margins: (Screen.desktopAvailableWidth-Config.barWidth)/2 
        }
        height: Config.barY+Config.barHeight
        hoverEnabled: true
    }
    Rectangle {
        id: topBar
        width:Config.barWidth
        anchors {
            left:parent.left
            right:parent.right
            margins:(Screen.desktopAvailableWidth-Config.barWidth)/2
        }
        y: topPanel.hovered ? Config.barY : -Config.barheight
        z: 1

        Behavior on y {
            NumberAnimation {
                duration: Config.barAnimation*2
                easing.type: Easing.InOutQuad
            }
        }
        height: 35
        radius: Config.radiusAll 
        color:  Config.backgroundColor 
        clip: true

        Drawer {
            id: clockDrawer             
            z:8
            drawerHeight:Config.clockDrawerHeight
            drawerMargins:Config.clockDrawerMargins
            drawerLeft:Config.clockDrawerLeft
            drawerAnimation:Config.clockDrawerAnimation
            buttonWidth:Config.clockWidth
            contentWidth:Config.dateWidth

            drawerButton:Clock{
            }
            drawerContent:Date{
            }
        }
    }
}
