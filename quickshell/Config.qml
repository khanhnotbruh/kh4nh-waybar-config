pragma Singleton
import QtQuick

QtObject {
    id:rootConfig
    /*-------------------------------------------------------*/
    /*                         BAR                           */
    /*-------------------------------------------------------*/
    property int barHeight: 35
    property int barWidth:1000 
    property int barY:30
    property int barAnimation:300
    /*-------------------------------------------------------*/
    /*                     CLOCK DRAWER                      */
    /*-------------------------------------------------------*/
    property int clockDrawerWidth:rootConfig.clockWidth+rootConfig.dateWidth+3 * rootConfig.clockDrawerMargins 
    property int clockDrawerHeight: 30
    property int clockDrawerMargins: 3
    property int clockDrawerAnimation:700
    property bool clockDrawerLeft:true

    property int clockWidth:   60
    property int clockHeight:  21
    property int clockTextSize:10

    property int dateWidth:   140
    property int dateHeight:  21 
    property int dateTextSize:10 
    /*-------------------------------------------------------*/
    /*                         ALL                           */
    /*-------------------------------------------------------*/
    property int radiusAll: 20
    property int textSize:10

    property color backgroundColor: "#80050512" 
    property color background2Color:"#803a6bce"
    property color background3Color:"#313244"

    property color backgroundColorDim: "#050512" //which has alpha ;-;
    property color background2ColorDim:"#803a6bce"
    property color background3ColorDim:"#3a6bce"

    property color textColor:       "#fface6f3"
    property color textColorDim:    "#aaace6f3" 
    /*-------------------------------------------------------*/
    /*                        FRAME                          */
    /*-------------------------------------------------------*/
    property int frameThick: 10
    property int frameRadius:30
    
    property color frameColor:"#dd100512"
    
}
