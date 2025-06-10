import QtQml 2.15
import QtQuick.Window 2.15

QtObject {
    property bool darkTheme: config.is_dark_theme
    property color bgColor: darkTheme ? "16161A" : "white"
    property color invertBgColor: darkTheme ? "white" : "16161A"
    property color itemBgColor: darkTheme ? "#444444" : "lightgray"
    property color inputBarBgColor: darkTheme ? "#333333" : "#eeeeee"
    property color scrollBarColor: itemBgColor
    property color fontColor: darkTheme ? "#969696" : "#222222"
    property color borderColor: fontColor
    property color imageColor: fontColor
    property color underFontColor: theme.darkTheme ? Qt.darker("lightgray") : "lightgray"
    property color lineSeriesColor: darkTheme ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0.0001, 0, 0, 1)
    property color imageEnteredColor: darkTheme ? "white" : "16161A"
    property color windowBorderEnterColor: darkTheme ? "white" : "16161A"
    property color headerBG: darkTheme ? Qt.darker("steelblue") : "steelblue"
    property color itemEnterColor: darkTheme ? "#555555" : "lightgray"
    property color itemEnteredBG: darkTheme ? "#444444" : "lightgray"
    property color itemEnxitedBG: darkTheme ? "lightgray" : "#444444"
    property color itemCheckedBG: darkTheme ? Qt.lighter("#444444") : Qt.darker("lightgray")
    property color sepColor: darkTheme ? Qt.darker("steelblue") : "steelblue"
    property color carouselBG: darkTheme ? "#101010" : "#eeeeee"
    property color priceUnmarkedColor: darkTheme ? "#555555" : "lightgray"
    property color priceMarkedColor: darkTheme ? Qt.lighter("red") : Qt.lighter("red")
    property color unmarkedColor: darkTheme ? "#555555" : "lightgray"
    property color markedColor: darkTheme ? Qt.darker("red") : Qt.lighter("red")
    property color priceUpFontColor: darkTheme ? Qt.lighter("green") : "green"
    property color priceDownFontColor: darkTheme ? Qt.lighter("red") : "red"
    property color floorPriceBGColor: darkTheme ? Qt.lighter("red") : Qt.lighter("red")
    property color settingFieldHeaderColor: darkTheme ? "#555555" : "lightgray"
    property color searchBarColor: darkTheme ? "#444444" : "lightgray"
    property color switchButtonColor: darkTheme ? "#bbbbbb" : "#444444"

    property int borderWidth: 1
    property int itemSpacing: 4
    property int itemPadding: 4
    property int itemMargins: 4
    property int itemRadius: 4
    property int fontPixelNormal: config.font_pixel_size_normal
    property real panelWidth: config.window_width
    property real panelHeight: config.window_height
    property real iconSize: fontPixelNormal * 1.6
    property real panelHeaderHeight: iconSize + itemPadding * 2
    property real windowOpacity: config.window_opacity

    signal themeSig

    onDarkThemeChanged: themeSig()
}
