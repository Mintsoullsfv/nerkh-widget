import QtQuick
import QtQuick.Shapes
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

QQC.AbstractButton {
    id: control

    property real progress: 1.0        // 1 = just updated, 0 = due now
    property bool busy: false
    property bool showTrack: true
    property string tooltip: ""
    property string tooltipSub: ""

    implicitWidth: Kirigami.Units.gridUnit * 2
    implicitHeight: Kirigami.Units.gridUnit * 2
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Button
    Accessible.name: tooltip

    readonly property real ringRadius: Math.min(width, height) / 2 - 2
    readonly property color accent: Kirigami.Theme.highlightColor

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainText: control.tooltip
        subText: control.tooltipSub
    }

    background: Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: control.accent
        opacity: control.pressed ? 0.22 : (control.hovered ? 0.12 : 0)
        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }

        border.width: control.visualFocus ? 2 : 0
        border.color: control.accent
    }

    Shape {
        id: ring
        anchors.fill: parent
        antialiasing: true
        opacity: control.busy ? 0 : (control.showTrack ? 1 : 0.35)
        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }

        ShapePath {
            strokeWidth: 1.5
            strokeColor: Qt.alpha(Kirigami.Theme.textColor, 0.18)
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: ring.width / 2
                centerY: ring.height / 2
                radiusX: control.ringRadius
                radiusY: control.ringRadius
                startAngle: -90
                sweepAngle: 360
            }
        }

        ShapePath {
            strokeWidth: 1.5
            strokeColor: control.accent
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: ring.width / 2
                centerY: ring.height / 2
                radiusX: control.ringRadius
                radiusY: control.ringRadius
                startAngle: -90
                sweepAngle: Math.max(0, Math.min(1, control.progress)) * 360
            }
        }
    }

    Shape {
        id: spinner
        anchors.fill: parent
        antialiasing: true
        visible: control.busy
        transformOrigin: Item.Center

        ShapePath {
            strokeWidth: 1.5
            strokeColor: control.accent
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: spinner.width / 2
                centerY: spinner.height / 2
                radiusX: control.ringRadius
                radiusY: control.ringRadius
                startAngle: -90
                sweepAngle: 90
            }
        }

        RotationAnimator {
            target: spinner
            running: control.busy
            from: 0
            to: 360
            duration: 900
            loops: Animation.Infinite
        }
    }

    contentItem: Item {
        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.small
            height: Kirigami.Units.iconSizes.small
            source: "view-refresh-symbolic"
            color: Kirigami.Theme.textColor
            opacity: control.hovered || control.busy ? 1 : 0.75
        }
    }
}
