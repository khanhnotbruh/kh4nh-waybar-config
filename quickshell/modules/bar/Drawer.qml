//color0: #80050512
//color3: #313244
//foreground: #fface6f3
import QtQuick
import Quickshell
import "../../"

Rectangle {
    id: drawer
    property Component drawerButton
    property Component drawerContent
    property int drawerAnimation
    property int drawerHeight
    property int drawerMargins
    property int buttonWidth
    property int contentWidth
    property bool drawerLeft

    property bool hovered: drawerMouse.containsMouse

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: drawer.drawerLeft ? parent.left : undefined
        right: drawer.drawerLeft ? undefined : parent.right
        margins:(parent.height-drawer.drawerHeight)/2  
    }

    Behavior on width { NumberAnimation { duration: drawer.drawerAnimation; easing.type: Easing.OutQuad } }

    width: drawer.hovered ? drawer.buttonWidth+drawer.contentWidth+3*drawer.drawerMargins : drawer.buttonWidth+2*drawer.drawerMargins
    color:Config.backgroundColor 
    radius:Config.radiusAll
    z: 2 

    MouseArea {
        id: drawerMouse
        anchors.fill: parent
        hoverEnabled: true
    }

    //--------- content ------------
    Rectangle {
        id:contentContainer
        z:9
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: drawer.drawerLeft ? undefined : parent.left
            right: drawer.drawerLeft ? parent.right : undefined
        }

        width: drawer.hovered ? (drawer.width - drawer.buttonWidth) : 0
        color:Config.background2ColorChanged 
        radius: Config.radiusAll
        clip:true

        Item {
            anchors.fill: parent
            Loader {
                anchors.centerIn: parent
                x:drawer.hovered?0:-drawer.contentWidth
                sourceComponent: drawer.drawerContent
            }
        }
    }

    //--------- button ------------
    Rectangle {
        id: buttonContainer
        z:10
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: drawer.drawerLeft ? undefined : parent.right
            left: drawer.drawerLeft ? parent.left : undefined
        }

        width: drawer.buttonWidth+2*drawer.drawerMargins
        color: Config.background2ColorChanged
        radius: Config.radiusAll

        Loader {
            id: buttonLoader
            anchors.centerIn: parent
            sourceComponent: drawer.drawerButton
        }
    }
}
