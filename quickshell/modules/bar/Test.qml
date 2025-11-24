import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root
    
    // Window Configuration
    anchors {
        top: true
        left: true
        right: true
    }
    height: 40
    color: "#1e1e2e" // Base background color (Catppuccin Mocha / Nord style)

    // Tell Hyprland to reserve this space so windows don't cover it
    exclusionMode: ExclusionMode.Normal

    // --- MAIN LAYOUT ---
    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10
        
        // 1. Workspaces (Left)
        WorkspaceWidget {
            height: parent.height
            width: 200
        }

        // Spacer

        // 2. Time & Date (Center)
        TimeDateWidget {
            height: parent.height
            width: 200
        }

        // Spacer

        // 3. System Stats (Right)
        Row {
            height: parent.height
            spacing: 8
            
            NetworkIoWidget { height: 30; width: 100; anchors.verticalCenter: parent.verticalCenter }
            DiskWidget      { height: 30; width: 90;  anchors.verticalCenter: parent.verticalCenter }
            GpuWidget       { height: 30; width: 90;  anchors.verticalCenter: parent.verticalCenter }
            RamWidget       { height: 30; width: 90;  anchors.verticalCenter: parent.verticalCenter }
            CpuWidget       { height: 30; width: 90;  anchors.verticalCenter: parent.verticalCenter }
        }
    }

    // ============================================================
    //                 INLINE COMPONENTS DEFINITIONS
    // ============================================================

    // --- 1. CPU COMPONENT ---
    component CpuWidget : Rectangle {
        color: "#313244"
        radius: 4
        
        property int lastUser: 0
        property int lastNice: 0
        property int lastSystem: 0
        property int lastIdle: 0
        property double usage: 0

        Text {
            anchors.centerIn: parent
            text: "CPU: " + Math.floor(parent.usage) + "%"
            color: "#cdd6f4"
            font.pixelSize: 12
            font.bold: true
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                // Read /proc/stat for instant CPU usage
                var file = File.read("/proc/stat")
                if (file) {
                    var lines = file.split("\n")
                    var cpuLine = lines[0].split(/\s+/)
                    
                    var u = parseInt(cpuLine[1]); var n = parseInt(cpuLine[2])
                    var s = parseInt(cpuLine[3]); var i = parseInt(cpuLine[4])

                    var totalDiff = (u + n + s + i) - (parent.lastUser + parent.lastNice + parent.lastSystem + parent.lastIdle)
                    var idleDiff = i - parent.lastIdle

                    if (totalDiff > 0) {
                        parent.usage = 100 * (totalDiff - idleDiff) / totalDiff
                    }

                    parent.lastUser = u; parent.lastNice = n; parent.lastSystem = s; parent.lastIdle = i
                }
            }
        }
    }

    // --- 2. RAM COMPONENT ---
    component RamWidget : Rectangle {
        color: "#313244"
        radius: 4
        property string display: "..."

        Text {
            anchors.centerIn: parent
            text: "RAM: " + parent.display
            color: "#f5c2e7" // Pink
            font.pixelSize: 12
            font.bold: true
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var content = File.read("/proc/meminfo")
                if (!content) return
                
                var t = content.match(/MemTotal:\s+(\d+)/)
                var a = content.match(/MemAvailable:\s+(\d+)/)

                if (t && a) {
                    var total = parseInt(t[1]); var avail = parseInt(a[1])
                    var used = (total - avail) / 1024 / 1024 // Convert to GB
                    parent.display = used.toFixed(1) + "G"
                }
            }
        }
    }

    // --- 3. DISK COMPONENT ---
    component DiskWidget : Rectangle {
        color: "#313244"
        radius: 4
        property string used: "-"

        Text {
            anchors.centerIn: parent
            text: "SSD: " + parent.used
            color: "#a6e3a1" // Green
            font.pixelSize: 12
            font.bold: true
        }

        // Process is safer for parsing command output like df
        Process {
            id: dfProc
            command: ["sh", "-c", "df -h / | awk 'NR==2 {print $5}'"]
            stdout: (out) => { parent.used = out.trim() }
        }

        Timer {
            interval: 60000 // Check once a minute
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: dfProc.running = true
        }
    }

    // --- 4. GPU COMPONENT ---
    component GpuWidget : Rectangle {
        color: "#313244"
        radius: 4
        property string load: "0%"

        Text {
            anchors.centerIn: parent
            text: "GPU: " + parent.load
            color: "#fab387" // Orange
            font.pixelSize: 12
            font.bold: true
        }

        // NOTE: Adjust command based on AMD vs NVIDIA
        Process {
            id: gpuProc
            // NVIDIA:
            command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
            
            // AMD (Uncomment below and comment above if using AMD):
            // command: ["cat", "/sys/class/drm/card0/device/gpu_busy_percent"]
            
            stdout: (out) => { parent.load = out.trim() + "%" }
        }

        Timer {
            interval: 3000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: gpuProc.running = true
        }
    }

    // --- 5. NETWORK I/O COMPONENT ---
    component NetworkIoWidget : Rectangle {
        color: "#313244"
        radius: 4
        
        // !!! CHANGE "wlan0" TO YOUR INTERFACE NAME (run `ip link` to find it) !!!
        property string iface: "wlan0"
        
        property double lastRx: 0
        property double lastTx: 0
        property string speed: "0KB/s"

        Text {
            anchors.centerIn: parent
            text: parent.speed
            color: "#89dceb" // Cyan
            font.pixelSize: 12
            font.bold: true
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var rxP = "/sys/class/net/" + parent.iface + "/statistics/rx_bytes"
                var txP = "/sys/class/net/" + parent.iface + "/statistics/tx_bytes"
                
                var rx = parseInt(File.read(rxP) || "0")
                var tx = parseInt(File.read(txP) || "0")
                
                if (parent.lastRx > 0) {
                    var diff = (rx - parent.lastRx) + (tx - parent.lastTx)
                    var kbs = diff / 1024
                    parent.speed = kbs > 1024 ? (kbs/1024).toFixed(1) + "MB/s" : kbs.toFixed(0) + "KB/s"
                }
                parent.lastRx = rx; parent.lastTx = tx
            }
        }
    }

    // --- 6. TIME & DATE COMPONENT ---
    component TimeDateWidget : Item {
        property var date: new Date()
        
        Column {
            anchors.centerIn: parent
            spacing: 2
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: parent.date.toLocaleTimeString(Qt.locale(), "HH:mm:ss")
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: parent.date.toLocaleDateString(Qt.locale(), "ddd, MMM d")
                color: "#bac2de"
                font.pixelSize: 11
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.date = new Date()
        }
    }

    // --- 7. WORKSPACE COMPONENT ---
    component WorkspaceWidget : Row {
        spacing: 5
        property int activeWs: 1

        // Listen for active workspace
        Process {
            id: wsProc
            // Requires 'jq' to be installed on Arch
            command: ["sh", "-c", "hyprctl activeworkspace -j | jq '.id'"]
            stdout: (out) => { parent.activeWs = parseInt(out) }
        }

        Timer {
            interval: 300
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: wsProc.running = true
        }

        Repeater {
            model: 6 // Number of workspaces to show
            delegate: Rectangle {
                width: 30
                height: 30
                radius: 4
                color: (index + 1) === activeWs ? "#89b4fa" : "#313244" // Blue active, Grey inactive
                
                Text {
                    anchors.centerIn: parent
                    text: index + 1
                    color: (index + 1) === activeWs ? "#1e1e2e" : "#cdd6f4"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var p = Qt.createQmlObject('import Quickshell.Services.System; Process {}', parent)
                        p.command = ["hyprctl", "dispatch", "workspace", index + 1]
                        p.running = true
                    }
                }
            }
        }
    }
}
