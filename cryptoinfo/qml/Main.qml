import QtQml 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import "qrc:/res/qml/Base" as Base

Window {
    id: main

    property alias theme: theme

    x: (Screen.width -  window.window) / 2
    y: (Screen.height / 2 - window.height) / 2
    width: column.width
    height: column.height
    opacity: theme.windowOpacity
    flags: Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint |  Qt.Dialog
    color: "transparent"
    title: "cryptoinfo"
    visible: true

    Base.Theme {
        id: theme
    }

    UtilityFn {
        id: utilityFn
    }

    Base.MsgTip {
        id: msgTip

        anchors.centerIn: parent
    }

    Column {
        id: column

        MainWindow {
            id: window
        }
    }
}
