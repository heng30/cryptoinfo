import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "qrc:/res/qml/Base" as Base

Base.SettingField {
    id: ui

    width: parent.width
    headerText: translator.tr("界面设置")
    spacing: theme.itemSpacing

    contentItem: Column {
        spacing: theme.itemSpacing

        Row {
            width: parent.width

            Base.NumInput {
                id: fontSizeSetting

                width: parent.width / 2
                text: theme.fontPixelNormal
                labelText: translator.tr("字体大小") + ":"
                readOnly: true
                onInc: {
                    config.font_pixel_size_normal += 1;
                    config.save_qml();
                }
                onDec: {
                    config.font_pixel_size_normal -= 1;
                    config.save_qml();
                }
            }

            Base.NumInput {
                id: opacitySetting

                width: parent.width / 2
                text: theme.windowOpacity.toFixed(1)
                labelText: translator.tr("透明度") + ":"
                readOnly: true
                onInc: {
                    var opacity = config.window_opacity + 0.1;
                    config.window_opacity = Math.min(opacity, 1);
                    config.save_qml();
                }
                onDec: {
                    var opacity = config.window_opacity - 0.1;
                    config.window_opacity = Math.max(opacity, 0.5);
                    config.save_qml();
                }
            }

        }

        Row {
            width: parent.width

            Row {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 2
                spacing: theme.itemSpacing

                Base.SelectBox {
                    anchors.verticalCenter: parent.verticalCenter
                    txtFieldWidth: theme.fontPixelNormal * 3 + itemSpacing
                    boxWidth: theme.fontPixelNormal * 3
                    labelText: translator.tr("窗口(宽x高)") + ":"
                    text: config.window_width
                    model: [translator.tr("像素")]
                    onTextAccepted: {
                        if (text.length <= 0)
                            return ;

                        var width = Number(text);
                        config.window_width = Math.min(Math.max(width, 840), Screen.desktopAvailableWidth);
                        config.save_qml();
                        msgTip.add(translator.tr("设置成功!"), false);
                    }
                }

                Base.ItemLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "  X  "
                }

                Base.SelectBox {
                    anchors.verticalCenter: parent.verticalCenter
                    boxWidth: theme.fontPixelNormal * 3
                    text: config.window_height
                    model: [translator.tr("像素")]
                    onTextAccepted: {
                        if (text.length <= 0)
                            return ;

                        var height = Number(text);
                        config.window_height = Math.min(Math.max(height, 680), Screen.desktopAvailableHeight);
                        config.save_qml();
                        msgTip.add(translator.tr("设置成功!"), false);
                    }
                }
            }
        }
    }
}
