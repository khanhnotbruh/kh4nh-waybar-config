import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: root

    // Window Configuration
    color: "transparent"
    visible: true

    // Quickshell/Wayland Settings:
    WlrLayershell.layer: WlrLayer.Top 
    WlrLayershell.keyboardFocus:WlrLayershell.none
    WlrLayershell.exclusiveZone: -1 

    anchors {
        top: true
        left: true
        right: true
        bottom:true
    }

    mask: Region {
        item: container; 
        intersection: Intersection.Xor 
    }
    Item {
        id: container
        anchors.fill: parent
        z:0
        Canvas {
            id: frameCanvas
            anchors.fill: parent

            property color frameColor: "#ff050512"//"#ffffff" 
            property real thickness: 10          
            property real roundness: 30         

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                ctx.beginPath();
                ctx.rect(0, 0, width, height);

                var x = thickness;
                var y = thickness;
                var w = width - (thickness * 2);
                var h = height - (thickness * 2);
                var r = roundness;

                ctx.moveTo(x + r, y);
                ctx.lineTo(x + w - r, y);
                ctx.quadraticCurveTo(x + w, y, x + w, y + r);
                ctx.lineTo(x + w, y + h - r);
                ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
                ctx.lineTo(x + r, y + h);
                ctx.quadraticCurveTo(x, y + h, x, y + h - r);
                ctx.lineTo(x, y + r);
                ctx.quadraticCurveTo(x, y, x + r, y);
                ctx.closePath();

                ctx.fillStyle = frameColor;
                ctx.fillRule = Qt.OddEvenFill;
                ctx.fill();
            }
        }

        // --- 3. INPUT HOLE GEOMETRY ---
        Item {
            id: hole
            anchors.fill: parent
            anchors.margins: frameCanvas.thickness // Sync with canvas thickness
            visible: false
        }
    }
}

