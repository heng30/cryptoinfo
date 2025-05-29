import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import "qrc:/res/qml/Base" as Base

Popup {
    id: msgTip

    property bool isWarnMsg: true
    property var boxData: []
    property alias interval: timer.interval

    function add(msg, isWarnMsg) {
        var item = {
            "msg": msg,
            "isWarnMsg": isWarnMsg
        };
        boxData.push(item);
        timer.running = true;
    }

    implicitWidth: row.width + theme.itemMargins * 4
    implicitHeight: row.height + theme.itemMargins * 2
    focus: true
    closePolicy: Popup.NoAutoClose
    padding: 0

    Row {
        id: row

        anchors.centerIn: parent
        height: Math.max(image.height, label.height)
        spacing: theme.itemSpacing

        Item {
            width: Math.min(label.height + theme.itemMargins, theme.iconSize)
            height: width

            Image {
                id: image

                width: parent.width
                height: width
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                source: msgTip.isWarnMsg ? "qrc:/res/image/warn.png" : "qrc:/res/image/info.png"
            }

            MultiEffect {
                source: image
                anchors.fill: image
                brightness: 1
                colorization: 1
                colorizationColor: theme.imageColor
            }
        }

        Label {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: theme.itemMargins
            wrapMode: Text.WordWrap
            color: theme.fontColor
            font.pixelSize: theme.fontPixelNormal
        }
    }

    Timer {
        id: timer

        interval: 2000
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (msgTip.boxData.length > 0) {
                var item = msgTip.boxData[0];
                label.text = item.msg;
                msgTip.isWarnMsg = item.isWarnMsg;
                msgTip.boxData.shift();
                msgTip.open();
            } else {
                msgTip.close();
                timer.running = false;
            }
        }
    }

    background: Rectangle {
        anchors.fill: parent
        border.width: theme.borderWidth
        border.color: theme.borderColor
        color: theme.bgColor
    }
}
