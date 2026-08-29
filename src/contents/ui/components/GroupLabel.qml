import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: label

    property string title: ""
    property bool uppercase: false

    spacing: Kirigami.Units.smallSpacing

    PlasmaComponents.Label {
        text: label.uppercase ? label.title.toUpperCase() : label.title
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        font.family: Kirigami.Theme.smallFont.family
        font.weight: Font.DemiBold
        font.letterSpacing: label.uppercase ? 1.1 : 0.2
        opacity: 0.55
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        implicitHeight: 1
        color: Qt.alpha(Kirigami.Theme.textColor, 0.12)
    }
}
