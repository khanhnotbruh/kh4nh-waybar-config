pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id:time 

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property date date: clock.date
    readonly property string timeString: Qt.formatDateTime(clock.date, "HH:mm:ss")
    readonly property string dateString: Qt.formatDateTime(clock.date, "dddd, MMMM d")
}

