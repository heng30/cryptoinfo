import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import PanelType 1.0
import "qrc:/res/qml/Base" as Base
import "qrc:/res/qml/Header/LeftBtnField" as LeftBtnField

Rectangle {
    id: root

    signal searchEditingFinished()

    width: parent.width
    height: theme.panelHeaderHeight
    color: theme.headerBG
    radius: theme.itemRadius

    Component {
        id: dItem

        Item {
            height: parent.height
            width: height
            visible: modelData.visible

            Base.ImageButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: theme.itemMargins + 1
                height: parent.height - anchors.margins * 2
                width: height
                onClicked: !!modelData.clicked && modelData.clicked()
                source: modelData.source
                tipText: modelData.tipText
                checked: !!modelData.checked
                enableColorOverlay: modelData.enableColorOverlay === undefined ? true : !!modelData.enableColorOverlay
            }

        }

    }

    Shortcut {
        sequence: shortKey.search
        onActivated: {
            if (_homeIsChecked)
                leftPrice.showSearchBar();

        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: theme.itemMargins
        spacing: theme.itemSpacing
        height: parent.height

        Left {
        }

        LeftBtnField.Price {
        }
    }

    Right {
    }

}
