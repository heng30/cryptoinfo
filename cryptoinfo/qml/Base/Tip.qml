import QtQuick 2.15
import QtQuick.Controls 2.15

ToolTip {
    id: root

    property color bgColor: theme.bgColor
    property color borderColor: theme.fontColor
    property color textColor: theme.fontColor
    property real textFontPixelSize: theme.fontPixelNormal

    background: Rectangle {
        color: bgColor
        border.width: theme.borderWidth
        border.color: borderColor
    }

    contentItem: Label {
        text: root.text
        color: root.textColor
        font.pixelSize: root.textFontPixelSize
    }
}
