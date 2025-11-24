import QtQuick

Rectangle {
    width:  50
    height: 25
    radius: 20
    color: "#313244"
    z:1
    property var time: new Date()

    Text {
        anchors.centerIn: parent
        text: parent.time.toLocaleTimeString(Qt.locale(), "hh:mm")
        color: "#ffffff"
        font.pixelSize: 14
        font.bold: true
    }

    Timer {
        interval: 60000; running: true; repeat: true
        onTriggered: parent.time = new Date()
    }
}
