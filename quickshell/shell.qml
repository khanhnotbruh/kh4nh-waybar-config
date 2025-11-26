import Quickshell
import QtQuick
import "modules/bar"
import "modules"

ShellRoot {
    id:shell 

    property bool enableBarHover:true

    Loader {
        active: true
        sourceComponent: Frame {}
    }
    Loader {
        active:true
        sourceComponent: Bar{}
    }
//    Loader {
//        active:true
//        sourceComponent: Test{}
//    } 
}

