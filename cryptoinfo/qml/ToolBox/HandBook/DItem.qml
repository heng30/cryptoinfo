import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/res/qml/Base" as Base

Rectangle {
    id: dItem

    property alias _showSItem: sItem.visible

    function updateStats(itemIndex) {
        var stats = handbook_model.stats_qml(itemIndex);
        var statsList = stats.split(",");
        if (statsList.length !== 3)
            return ;

        var payment = Number(statsList[0]);
        var income = Number(statsList[1]);
        var count_diff = Number(statsList[2]);
        var backPrice = (count_diff >= 0 || payment <= income) ? 0 : Math.abs((payment - income) / count_diff);
        statsInfo.text = modelData.name + utilityFn.paddingSpace(2) + translator.tr("支出") + ": " + payment.toFixed(0) + utilityFn.paddingSpace(2) + translator.tr("收入") + ": " + income.toFixed(0) + utilityFn.paddingSpace(2) + (payment > income ? translator.tr("亏损") : translator.tr("盈利")) + ": " + Math.abs(payment - income).toFixed(0) + "(" + Math.abs((payment - income) * 100 / (payment <= 0 ? income : payment)).toFixed(0) + "%)" + utilityFn.paddingSpace(2) + translator.tr("数量差") + ": " + count_diff.toFixed(0) + utilityFn.paddingSpace(2) + translator.tr("回本价") + ": " + utilityFn.toFixedPrice(backPrice);
        statsInfo.textColor = payment > income ? theme.priceDownFontColor : theme.priceUpFontColor;
    }

    width: ListView.view.width
    height: column.height + theme.itemMargins * 2
    color: _showSItem ? theme.itemEnterColor : (mouseArea._isEntered ? theme.itemEnterColor : "transparent")
    border.width: 1
    border.color: theme.borderColor
    radius: theme.itemRadius
    Component.onCompleted: {
        handbook.addItemSig.connect(sItem.reload);
        handbook.upItemOrderSig.connect(function(upItemIndex) {
            if (upItemIndex > 0 && index === upItemIndex - 1)
                sItem.reload();

        });
        handbook.downItemOrderSig.connect(function(downItemIndex) {
            if (downItemIndex >= 0 && index === downItemIndex + 1)
                sItem.reload();

        });
    }

    Column {
        id: column

        spacing: theme.itemSpacing
        anchors.centerIn: parent
        width: parent.width - anchors.margins * 2

        Row {
            id: row

            spacing: theme.itemSpacing
            width: parent.width

            Base.ItemLabel {
                id: statsInfo

                text: modelData.name
                anchors.verticalCenter: parent.verticalCenter
                label.width: parent.width - btnRow.width - parent.spacing
                wrapMode: Text.Wrap

                MouseArea {
                    id: mouseArea

                    property bool _isEntered: false

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: _isEntered = true
                    onExited: _isEntered = false
                    onDoubleClicked: _showSItem = !_showSItem
                }

            }

            Row {
                id: btnRow

                property list<QtObject> imageModel

                anchors.verticalCenter: parent.verticalCenter
                spacing: theme.itemSpacing
                imageModel: [
                    QtObject {
                        property string source: "qrc:/res/image/up.png"
                        property string tipText: translator.tr("上移")
                        property var clicked: function() {
                            handbook_model.up_item_qml(index);
                            handbook.upItemOrderSig(index);
                            handbook_model.save_qml();
                            sItem.reload();
                        }
                    },
                    QtObject {
                        property string source: "qrc:/res/image/down.png"
                        property string tipText: translator.tr("下移")
                        property var clicked: function() {
                            handbook_model.down_item_qml(index);
                            handbook.downItemOrderSig(index);
                            handbook_model.save_qml();
                            sItem.reload();
                        }
                    },
                    QtObject {
                        property string source: "qrc:/res/image/add.png"
                        property string tipText: translator.tr("添加")
                        property var clicked: function() {
                            sItem.add(false, "", 0, 0);
                        }
                    },
                    QtObject {
                        property string source: "qrc:/res/image/open.png"
                        property string tipText: translator.tr("展开")
                        property var clicked: function() {
                            _showSItem = !_showSItem;
                        }
                    },
                    QtObject {
                        property string source: "qrc:/res/image/edit.png"
                        property string tipText: translator.tr("编辑")
                        property var clicked: function() {
                            footer.edit(index, modelData.name);
                        }
                    },
                    QtObject {
                        property string source: "qrc:/res/image/clear.png"
                        property string tipText: translator.tr("删除")
                        property var clicked: function() {
                            msgBox.add(translator.tr("是否删除"), true, function() {
                                handbook_model.remove_item_qml(index);
                                handbook_model.save_qml();
                                footer.updateBalance();
                            }, function() {
                            });
                        }
                    }
                ]

                Repeater {
                    model: parent.imageModel

                    delegate: Base.ImageButton {
                        anchors.margins: theme.itemMargins
                        anchors.verticalCenter: parent.verticalCenter
                        height: 32 - anchors.margins * 2
                        width: height
                        source: modelData.source
                        tipText: modelData.tipText
                        onClicked: modelData.clicked()
                    }

                }

            }

        }

        SItem {
            id: sItem

            width: column.width - theme.itemMargins * 2
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }

    }

}
