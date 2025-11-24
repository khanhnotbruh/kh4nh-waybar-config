pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    // Use Quickshell's SystemClock for efficient time tracking
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    // A string version of the date/time; you can adjust format
    readonly property string formatted: Qt.formatDateTime(
        clock.date,
        "ddd MMM d hh:mm:ss yyyy"
    )
}

