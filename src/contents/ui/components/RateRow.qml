import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui

MouseArea {
    id: row

    required property string symbol
    property var rate: undefined
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property string labelStyle: "name"      // name | symbol | both
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0
    property bool showChange: true
    property bool showDeltaBar: true
    property real saturationPercent: 3.0
    property int priceColumnWidth: 0

    readonly property int iconPx: Ui.iconPx(iconSize, Kirigami.Units.iconSizes)
    readonly property int basePt: Kirigami.Theme.defaultFont.pointSize + Ui.fontDelta(fontDelta)

    readonly property bool hasRate: rate !== undefined && rate !== null
    readonly property real pct: hasRate && !isNaN(rate.changePercent) ? rate.changePercent : 0
    readonly property string direction: hasRate ? rate.direction : "flat"
    readonly property color moveColor: direction === "up"
        ? Kirigami.Theme.positiveTextColor
        : (direction === "down" ? Kirigami.Theme.negativeTextColor
                                : Kirigami.Theme.disabledTextColor)

    readonly property real displayPrice: hasRate
        ? Fmt.scalePrice(rate.price, rate.unit, unitScale) : NaN
    readonly property string priceText: hasRate
        ? Fmt.formatNumber(displayPrice, rate.decimals, numerals) : "—"
    readonly property string unitText: hasRate
        ? Fmt.unitLabel(rate.unit, unitScale, lang) : ""

    implicitHeight: Math.max(Kirigami.Units.gridUnit * 2,
                             iconPx + Kirigami.Units.smallSpacing * 2)
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    readonly property real naturalPriceWidth: priceLabel.implicitWidth

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainText: Assets.nameFor(row.symbol, row.lang) + "  ·  " + row.symbol
        subText: row.hasRate
            ? (row.priceText + " " + row.unitText
               + (isNaN(row.pct) ? "" : "   " + Fmt.formatPercent(row.pct, row.numerals))
               + "\n" + Fmt.relativeTime(row.rate.updatedAt, row.lang, row.numerals))
            : ""
    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: -Kirigami.Units.smallSpacing
        anchors.rightMargin: -Kirigami.Units.smallSpacing
        radius: Kirigami.Units.smallSpacing
        color: Kirigami.Theme.highlightColor
        opacity: row.containsMouse ? 0.10 : 0
        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        Item {
            Layout.preferredWidth: row.showDeltaBar ? 3 : 0
            Layout.fillHeight: true
            visible: row.showDeltaBar

            Rectangle {
                width: 3
                radius: 1.5
                color: row.moveColor
                opacity: row.hasRate ? 0.9 : 0.25
                anchors.horizontalCenter: parent.horizontalCenter

                readonly property real half: parent.height / 2 - 3
                readonly property real magnitude: Math.min(1,
                    Math.abs(row.pct) / row.saturationPercent)

                height: Math.max(2, magnitude * half)
                y: row.direction === "down"
                    ? parent.height / 2
                    : parent.height / 2 - height

                Behavior on height {
                    NumberAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Image {
            source: Assets.iconFor(row.symbol)
            visible: row.showIcon
            sourceSize.width: row.iconPx
            sourceSize.height: row.iconPx
            Layout.preferredWidth: visible ? row.iconPx : 0
            Layout.preferredHeight: row.iconPx
            Layout.leftMargin: visible ? Kirigami.Units.smallSpacing : 0
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            cache: true
            mirror: false
            opacity: row.hasRate ? 1 : 0.4
        }

        PlasmaComponents.Label {
            text: Assets.labelFor(row.symbol, row.lang, row.labelStyle)
            font.pointSize: row.basePt
            elide: Text.ElideRight
            maximumLineCount: 1
            Layout.fillWidth: true
            Layout.leftMargin: row.showIcon ? 0 : Kirigami.Units.smallSpacing
            opacity: row.hasRate && !row.rate.stale ? 1 : 0.55
        }

        PlasmaComponents.Label {
            id: priceLabel
            text: row.priceText
            font.bold: true
            font.pointSize: row.basePt + 1
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: row.priceColumnWidth > 0
                ? row.priceColumnWidth : implicitWidth
            opacity: row.hasRate && !row.rate.stale ? 1 : 0.55
        }

        PlasmaComponents.Label {
            text: row.unitText
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.5
            visible: text.length > 0
        }

        PlasmaComponents.Label {
            text: row.hasRate ? Fmt.formatPercent(row.pct, row.numerals) : ""
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            color: row.moveColor
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: Kirigami.Units.gridUnit * 3
            Layout.leftMargin: Kirigami.Units.smallSpacing
            visible: row.showChange
        }
    }
}
