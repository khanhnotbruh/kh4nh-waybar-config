import QtQuick
import "../../../"
Rectangle {
    width: Config.clockWidth 
    height:Config.clockHeight
    radius:Config.radiusAll
    color: Config.background2ColorDim
    Text {
        id:clockText
        anchors.centerIn: parent
        text: Time.timeString
        renderType: Text.QtRendering
        color:Config.textColor 
        font.pixelSize: Config.clockTextSize
        font.bold: true
    }
}
