import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../components"
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui
import "../lib/Translations.js" as Tr

Item {
    id: view

    required property var source
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property string labelStyle: "name"
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0
    property bool showChange: true
    property bool showDeltaBar: true
    property bool showGroupLabels: true
    property bool autoRefresh: true
    property var symbols: []
    property string groupOrder: "fiat,metal,crypto"
    property double clockTick: 0

    function tr(key, args) { return Tr.t(lang, key, args) }

    readonly property bool empty: symbols.length === 0

    property var entries: []

    function rebuild() {
        var out = []
        var lastGroup = ""
        var ordered = Assets.sortedBy(symbols, groupOrder)

        for (var i = 0; i < ordered.length; ++i) {
            var sym = ordered[i]
            var group = Assets.typeFor(sym)
            var opensGroup = showGroupLabels && group !== lastGroup
            lastGroup = group
            out.push({
                symbol: sym,
                group: opensGroup ? group : "",
                first: i === 0
            })
        }
        entries = out
    }

    function groupTitle(group) {
        if (group === "metal")
            return tr("groupMetal")
        if (group === "crypto")
            return tr("groupCrypto")
        return tr("groupFiat")
    }

    TextMetrics {
        id: metrics
        font.bold: true
        font.family: Kirigami.Theme.defaultFont.family
        font.pointSize: Kirigami.Theme.defaultFont.pointSize + Ui.fontDelta(view.fontDelta) + 1
    }

    property real priceColumn: 0

    function measure() {
        var widest = 0
        var map = source.rates
        for (var i = 0; i < symbols.length; ++i) {
            var r = map[symbols[i]]
            if (!r)
                continue
            metrics.text = Fmt.formatNumber(
                Fmt.scalePrice(r.price, r.unit, unitScale), r.decimals, numerals)
            widest = Math.max(widest, metrics.advanceWidth)
        }
        priceColumn = widest > 0 ? Math.ceil(widest) + 2 : 0
    }

    onSymbolsChanged: { rebuild(); measure() }
    onGroupOrderChanged: rebuild()
    onShowGroupLabelsChanged: rebuild()
    onLangChanged: { rebuild(); measure() }
    onNumeralsChanged: measure()
    onUnitScaleChanged: measure()
    onFontDeltaChanged: measure()
    Component.onCompleted: { rebuild(); measure() }

    Connections {
        target: view.source
        function onRatesChanged() { view.measure() }
    }

    implicitWidth: Kirigami.Units.gridUnit * 20
    implicitHeight: Math.min(Kirigami.Units.gridUnit * 26,
                             layout.implicitHeight + Kirigami.Units.largeSpacing * 2)

    LayoutMirroring.enabled: view.lang === "fa"
    LayoutMirroring.childrenInherit: true

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                text: view.tr("appName")
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 3
                font.weight: Font.Bold
                font.letterSpacing: view.lang === "fa" ? 0 : 0.6
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.Label {
                text: {
                    view.clockTick
                    if (view.source.loading)
                        return view.tr("refreshing")
                    if (view.source.lastUpdated === 0)
                        return view.tr("never")
                    return view.tr("updated", Fmt.relativeTime(
                        view.source.lastUpdated, view.lang, view.numerals))
                }
                font: Kirigami.Theme.smallFont
                opacity: 0.6
                elide: Text.ElideRight
                Layout.maximumWidth: Kirigami.Units.gridUnit * 9
            }

            RefreshControl {
                busy: view.source.loading
                progress: {
                    view.clockTick
                    if (!view.autoRefresh || view.source.nextRefreshAt === 0)
                        return 0
                    var total = Math.max(1, view.source.intervalMinutes) * 60000
                    return (view.source.nextRefreshAt - Date.now()) / total
                }
                showTrack: view.autoRefresh
                tooltip: view.tr("refresh")
                tooltipSub: {
                    view.clockTick
                    if (!view.autoRefresh)
                        return view.tr("manualOnly")
                    if (view.source.nextRefreshAt === 0)
                        return ""
                    return view.tr("nextIn", Fmt.countdown(
                        view.source.nextRefreshAt - Date.now(), view.lang, view.numerals))
                }
                onClicked: view.source.refresh()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Qt.alpha(Kirigami.Theme.textColor, 0.12)
        }

        QQC.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: rateList.contentHeight
            visible: !view.empty

            ListView {
                id: rateList
                model: view.entries
                spacing: 0
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                reuseItems: true
                cacheBuffer: 0

                delegate: ColumnLayout {
                    required property var modelData

                    width: rateList.width
                    spacing: 0

                    GroupLabel {
                        Layout.fillWidth: true
                        Layout.topMargin: modelData.first
                            ? 0 : Kirigami.Units.largeSpacing
                        Layout.bottomMargin: Kirigami.Units.smallSpacing / 2
                        visible: modelData.group.length > 0
                        title: visible ? view.groupTitle(modelData.group) : ""
                        uppercase: view.lang !== "fa"
                    }

                    RateRow {
                        Layout.fillWidth: true
                        symbol: modelData.symbol
                        rate: view.source.rates[modelData.symbol]
                        lang: view.lang
                        numerals: view.numerals
                        unitScale: view.unitScale
                        labelStyle: view.labelStyle
                        showIcon: view.showIcon
                        iconSize: view.iconSize
                        fontDelta: view.fontDelta
                        showChange: view.showChange
                        showDeltaBar: view.showDeltaBar
                        priceColumnWidth: view.priceColumn
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: view.empty
            spacing: Kirigami.Units.smallSpacing

            Item { Layout.fillHeight: true }

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                source: "view-financial-list"
                implicitWidth: Kirigami.Units.iconSizes.large
                implicitHeight: Kirigami.Units.iconSizes.large
                opacity: 0.45
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
                text: view.tr("emptyTitle")
                font.weight: Font.DemiBold
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.gridUnit
                Layout.rightMargin: Kirigami.Units.gridUnit
                text: view.tr("emptyBody")
                font: Kirigami.Theme.smallFont
                opacity: 0.7
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
                text: view.tr("openSettings")
                icon.name: "configure"
                onClicked: Plasmoid.internalAction("configure").trigger()
            }

            Item { Layout.fillHeight: true }
        }

        Notice {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing
            visible: view.source.errorText.length > 0
            severity: "error"
            iconName: "network-disconnect-symbolic"
            title: view.tr("errorTitle")
            body: view.source.errorText
            actionText: view.tr("retry")
            onActionTriggered: view.source.refresh()
        }
    }
}
