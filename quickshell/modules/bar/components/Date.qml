import QtQuick
import "../../../"
Rectangle {
    width: Config.dateWidth 
    height:Config.dateHeight
    radius:Config.radiusAll
    color: Config.background2ColorDim

    Text {
        id:dateText
        anchors.centerIn: parent
        renderType: Text.QtRendering
        text: Time.dateString
        color:Config.textColor 
        font.pixelSize: Config.dateTextSize
        font.bold: true
    }
}
