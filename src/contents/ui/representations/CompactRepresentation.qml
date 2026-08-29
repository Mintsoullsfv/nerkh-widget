import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui
import "../lib/Translations.js" as Tr

MouseArea {
    id: compact

    required property var source
    property string symbol: "USD"
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0

    readonly property int iconPx: Ui.iconPx(iconSize, Kirigami.Units.iconSizes)
    readonly property var rate: source.rates[symbol]
    readonly property bool hasRate: rate !== undefined && rate !== null
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property color moveColor: !hasRate
        ? Kirigami.Theme.disabledTextColor
        : (rate.direction === "up" ? Kirigami.Theme.positiveTextColor
          : (rate.direction === "down" ? Kirigami.Theme.negativeTextColor
                                       : Kirigami.Theme.disabledTextColor))

    readonly property string priceText: hasRate
        ? Fmt.formatNumber(Fmt.scalePrice(rate.price, rate.unit, unitScale),
                           rate.decimals, numerals)
        : "—"

    signal toggleRequested()

    activeFocusOnTab: true
    hoverEnabled: true
    Layout.minimumWidth: vertical ? 0 : content.implicitWidth
    Layout.minimumHeight: vertical ? content.implicitHeight : 0
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    onClicked: compact.toggleRequested()

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainText: Assets.nameFor(compact.symbol, compact.lang)
        subText: compact.hasRate
            ? (compact.priceText + " "
               + Fmt.unitLabel(compact.rate.unit, compact.unitScale, compact.lang)
               + "   " + Fmt.formatPercent(compact.rate.changePercent, compact.numerals)
               + "\n" + Fmt.relativeTime(compact.rate.updatedAt, compact.lang, compact.numerals))
            : Tr.t(compact.lang, "loading")
    }

    LayoutMirroring.enabled: compact.lang === "fa"
    LayoutMirroring.childrenInherit: true

    GridLayout {
        id: content
        anchors.centerIn: parent
        columns: compact.vertical ? 1 : 3
        rowSpacing: 0
        columnSpacing: Kirigami.Units.smallSpacing

        Image {
            source: Assets.iconFor(compact.symbol)
            visible: compact.showIcon
            sourceSize.width: compact.iconPx
            sourceSize.height: compact.iconPx
            Layout.preferredWidth: visible ? compact.iconPx : 0
            Layout.preferredHeight: visible ? compact.iconPx : 0
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            cache: true
        }

        PlasmaComponents.Label {
            text: compact.priceText
            font.bold: true
            font.pointSize: (compact.vertical
                ? Kirigami.Theme.smallFont.pointSize
                : Kirigami.Theme.defaultFont.pointSize) + Ui.fontDelta(compact.fontDelta)
            Layout.alignment: Qt.AlignHCenter
        }

        Canvas {
            id: marker
            implicitWidth: compact.iconPx / 2
            implicitHeight: compact.iconPx / 2
            Layout.alignment: Qt.AlignHCenter
            visible: compact.hasRate && compact.rate.direction !== "flat"

            readonly property color tone: compact.moveColor
            readonly property bool up: compact.hasRate && compact.rate.direction === "up"

            onToneChanged: requestPaint()
            onUpChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = tone
                ctx.beginPath()
                if (up) {
                    ctx.moveTo(width / 2, 0)
                    ctx.lineTo(width, height)
                    ctx.lineTo(0, height)
                } else {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width, 0)
                    ctx.lineTo(width / 2, height)
                }
                ctx.closePath()
                ctx.fill()
            }
        }
    }
}
