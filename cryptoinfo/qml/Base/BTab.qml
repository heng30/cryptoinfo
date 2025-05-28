import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/res/qml/Base" as Base

// model: [
//     QtObject {
//         property string tabText: "tab1"
//         property Component sourceComponent
//         sourceComponent: Rectangle {
//             color: "red"
//         }
//     },
//     QtObject {
//         property string tabText: "tab2"
//         property Component sourceComponent
//         sourceComponent: Rectangle {
//             color: "green"
//         }
//     }
// ]
Item {
    id: bTab

    property list<QtObject> model
    property int clickedTab: 0
    property bool enableBGColor: false
    property alias rows: grid.rows
    property alias columns: grid.columns

    signal clicked(int index)

    implicitWidth: 100
    implicitHeight: 100
    model: []

    Rectangle {
        id: tabBG

        anchors.fill: grid
        color: enableBGColor ? theme.itemEnteredBG : "transparent"
    }

    Grid {
        id: grid

        width: parent.width
        rows: 1
        spacing: 1

        Repeater {
            model: bTab.model

            Base.TxtButton {
                id: tabBtn
                text: modelData.tabText
                radius: 0
                checked: index === bTab.clickedTab
                onClicked: {
                    bTab.clickedTab = index;
                    bTab.clicked(index);
                }
            }

        }

    }

    Item {
        id: sepItem

        anchors.top: grid.bottom
        width: parent.width
        height: theme.itemSpacing
    }

    Repeater {
        model: bTab.model

        Loader {
            id: loader

            anchors.top: sepItem.bottom
            anchors.bottom: parent.bottom
            visible: index === bTab.clickedTab
            width: parent.width
            sourceComponent: modelData.sourceComponent
        }

    }

}
