import QtQuick
import Quickshell
import QtQuick.Controls
import "components"
import "../../"
import "."
 
//color0: #80050512
//color3: #313244
//foreground: #fface6f3

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
            drawerWidth:Config.clockDrawerWidth
            drawerLeft:Config.clockDrawerLeft
            buttonWidth:Config.clockWidth
            contentWidth:Config.clockWidth

            drawerButton:Clock{}
            drawerContent:Date{}
        }
    }
}
