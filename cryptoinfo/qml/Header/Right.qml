import QtQuick 2.15
import QtQuick.Controls 2.15
import PanelType 1.0
import "qrc:/res/qml/Base" as Base

Row {
    id: right

    property list<QtObject> imageModel

    anchors.right: parent.right
    height: parent.height
    spacing: theme.itemSpacing
    imageModel: [
        QtObject {
            property string source: "qrc:/res/image/setting.png"
            property string tipText: translator.tr("设置")
            property bool visible: true
            property bool checked: _settingIsChecked
            property var clicked: function() {
                config.panel_type = PanelType.Setting;
            }
        },
        QtObject {
            property string source: "qrc:/res/image/about.png"
            property string tipText: translator.tr("关于")
            property bool visible: true
            property var clicked: function() {
                about.open();
            }
        },
        QtObject {
            property string source: "qrc:/res/image/theme.png"
            property string tipText: translator.tr("切换主题")
            property bool visible: true
            property var clicked: function() {
                config.is_dark_theme = !config.is_dark_theme;
                config.save_qml();
            }
        },
        QtObject {
            property string source: "qrc:/res/image/minus.png"
            property string tipText: translator.tr("最小化")
            property bool visible: true
            property var clicked: function() {
                main.showMinimized();
            }
        },
        QtObject {
            property string source: "qrc:/res/image/exit.png"
            property string tipText: translator.tr("关闭")
            property bool visible: true
            property var clicked: function() {
                utilityFn.quit();
            }
        }
    ]

    Repeater {
        model: parent.imageModel
        delegate: dItem
    }

}
