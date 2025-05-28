import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/res/qml/Base" as Base

Popup {
    id: about

    implicitWidth: 450
    implicitHeight: content.height + theme.itemMargins * 4
    focus: true
    closePolicy: Popup.NoAutoClose
    padding: 0

    Column {
        id: content

        anchors.centerIn: parent
        width: parent.width - theme.itemMargins * 4
        spacing: theme.itemSpacing

        Base.ItemText {
            width: parent.width
            text: "Cryptoinfo " + utility.app_version_qml()
            textFontBold: true
            textFontPixelSize: theme.fontPixelNormal + 4
        }

        Row {
            width: parent.width
            spacing: theme.itemSpacing

            Image {
                id: icon

                fillMode: Image.PreserveAspectFit
                source: "qrc:/res/image/icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Base.ItemText {
                width: parent.width - icon.width - parent.spacing
                label.width: width
                wrapMode: Text.WordWrap
                label.horizontalAlignment: Text.AlignLeft
                text: "Based on Qt 5.15. Copyright 2022-2030 The Heng30 Company Ltd. All rights reserved. The program is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE."
            }

        }

        Item {
            width: parent.width
            height: btn.height + theme.itemSpacing * 2

            Base.TxtButton {
                id: btn

                anchors.rightMargin: theme.itemMargins * 4
                anchors.right: parent.right
                text: translator.tr("关闭")
                onClicked: about.visible = false
            }

        }

    }

    background: Rectangle {
        anchors.fill: parent
        border.width: 2
        border.color: theme.borderColor
        color: theme.bgColor
    }

}
