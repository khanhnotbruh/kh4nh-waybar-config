import QtQuick

Text {
    text: {
        // Split the formatted string and pick the time part
        const parts = Time.formatted.split(" ");
        // Assuming format: Day Month Date HH:MM:SS Year
        return parts[3];  
    }
    font.pixelSize: 14
}

