import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import PanelType 1.0
import "qrc:/res/qml/Price" as Price
import "qrc:/res/qml/Setting" as Setting
import "qrc:/res/qml/Base" as Base
import "qrc:/res/qml/Header" as Header
import "qrc:/res/qml/ToolBox" as ToolBox

Item {
    id: homepage

    property bool _settingIsChecked: config.panel_type === PanelType.Setting
    property bool _toolBoxIsChecked: config.panel_type === PanelType.ToolBox
    property bool _homeIsChecked: config.panel_type === PanelType.Price
    property bool _accountIsChecked: config.panel_type == PanelType.Account
    property real _bodyHeight: theme.panelHeight - header.height - footer.height

    width: content.width
    height: content.height

    About {
        id: about

        anchors.centerIn: parent
    }

    Base.MsgBox {
        id: msgBox

        anchors.centerIn: parent
    }

    Rectangle {
        id: bgField

        anchors.fill: parent
        focus: true
        radius: 5
        color: theme.bgColor

        Shortcut {
            sequence: shortKey.homepageHide
            onActivated: main.showMinimized()
        }

        Shortcut {
            sequence: shortKey.panelViewAtBeginning
            onActivated: {
                if (_homeIsChecked)
                    pricePanel.viewAtBeginning();

            }
        }

        Shortcut {
            sequence: shortKey.panelViewAtEnd
            onActivated: {
                if (_homeIsChecked)
                    pricePanel.viewAtEnd();

            }
        }

        Column {
            id: content

            width: theme.panelWidth

            Header.Field {
                id: header

                onSearchEditingFinished: {
                    if (_homeIsChecked)
                        pricePanel.viewAtBeginning();

                }
            }

            Price.Panel {
                id: pricePanel

                height: _bodyHeight
                visible: _homeIsChecked
            }

            Setting.Panel {
                id: settingPanel

                height: _bodyHeight
                visible: _settingIsChecked
            }

            ToolBox.Panel {
                id: toolBoxPanel

                height: _bodyHeight
                visible: _toolBoxIsChecked
            }

            Footer {
                id: footer
            }

        }

    }

}
