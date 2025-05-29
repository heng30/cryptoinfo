import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects

// import Qt5Compat.QtGraphicalEffects

Rectangle {
    id: root

    property alias source: image.source
    property alias tipText: tip.text
    property bool checked: false
    property bool enableColorOverlay: true
    property bool enableMouseArea: true

    signal clicked(var mouse)

    implicitWidth: 32
    implicitHeight: 32
    color: "transparent"

    Image {
        id: image

        property bool _entered: false

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit

        Rectangle {
            anchors.fill: parent
            color: parent._entered || root.checked ? theme.imageEnteredColor : "transparent"
            radius: width / 3
            opacity: root.checked ? 0.2 : 0.3
        }
    }

    MultiEffect {
        source: image
        anchors.fill: image
        brightness: 1
        colorization: 1
        colorizationColor: theme.imageColor
    }

    Tip {
        id: tip

        visible: image._entered && text.length > 0
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: mouse => root.clicked(mouse)
        onEntered: image._entered = true
        onExited: image._entered = false
        visible: root.enableMouseArea
    }
}
