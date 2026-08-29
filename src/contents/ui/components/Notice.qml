import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Item {
    id: notice

    property string severity: "info"      // "info" | "error"
    property string iconName: "documentinfo-symbolic"
    property string title: ""
    property string body: ""
    property string actionText: ""

    signal actionTriggered()

    readonly property color tone: severity === "error"
        ? Kirigami.Theme.negativeTextColor
        : Kirigami.Theme.highlightColor

    implicitHeight: visible ? content.implicitHeight + Kirigami.Units.smallSpacing * 2 : 0

    Rectangle {
        anchors.fill: parent
        radius: Kirigami.Units.smallSpacing
        color: Qt.alpha(notice.tone, 0.10)
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        radius: 1
        color: notice.tone
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        anchors.leftMargin: Kirigami.Units.smallSpacing * 2
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            source: notice.iconName
            color: notice.tone
            implicitWidth: Kirigami.Units.iconSizes.small
            implicitHeight: Kirigami.Units.iconSizes.small
            Layout.alignment: Qt.AlignTop
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: notice.title
                font.family: Kirigami.Theme.smallFont.family
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: notice.body
                font: Kirigami.Theme.smallFont
                opacity: 0.7
                wrapMode: Text.WordWrap
                visible: text.length > 0
            }
        }

        PlasmaComponents.ToolButton {
            text: notice.actionText
            visible: notice.actionText.length > 0
            font: Kirigami.Theme.smallFont
            Layout.alignment: Qt.AlignVCenter
            onClicked: notice.actionTriggered()
        }
    }
}
