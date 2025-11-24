import QtQuick
import "."
Text {
    text: {
        const parts = Time.formatted.split(" ");
        // Format: Day + Month + Date (you can reorder if you like)
        return `${parts[0]} ${parts[1]} ${parts[2]}`  
    }
    font.pixelSize: 14
}

