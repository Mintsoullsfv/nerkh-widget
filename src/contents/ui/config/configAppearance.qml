import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "../lib/Assets.js" as Assets
import "../lib/Translations.js" as Tr

KCM.SimpleKCM {
    id: page

    property string cfg_language: "auto"
    property string cfg_languageDefault: "auto"
    property string cfg_numerals: "auto"
    property string cfg_numeralsDefault: "auto"
    property string cfg_unitScale: "toman"
    property string cfg_unitScaleDefault: "toman"
    property string cfg_cryptoBase: "USD"
    property string cfg_cryptoBaseDefault: "USD"
    property string cfg_labelStyle: "name"
    property string cfg_labelStyleDefault: "name"
    property alias cfg_showIcon: showIcon.checked
    property bool cfg_showIconDefault: true
    property string cfg_iconSize: "small"
    property string cfg_iconSizeDefault: "small"
    property int cfg_fontDelta: 0
    property int cfg_fontDeltaDefault: 0
    property alias cfg_showChange: showChange.checked
    property alias cfg_showDeltaBar: showDeltaBar.checked
    property alias cfg_showGroupLabels: showGroupLabels.checked
    property string cfg_compactSymbol: "USD"
    property string cfg_compactSymbolDefault: "USD"
    property string cfg_enabledAssets: ""

    readonly property string lang: {
        if (cfg_language === "fa" || cfg_language === "en")
            return cfg_language
        return Qt.locale().name.indexOf("fa") === 0 ? "fa" : "en"
    }

    function tr(key, args) { return Tr.t(lang, key, args) }

    LayoutMirroring.enabled: page.lang === "fa"
    LayoutMirroring.childrenInherit: true

    Kirigami.FormLayout {

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgLanguage")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "auto", label: page.tr("cfgLangAuto") },
                { value: "fa",   label: page.tr("cfgLangFa") },
                { value: "en",   label: page.tr("cfgLangEn") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_language)
            onActivated: page.cfg_language = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgNumerals")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "auto",    label: page.tr("cfgNumAuto") },
                { value: "latin",   label: page.tr("cfgNumLatin") },
                { value: "persian", label: page.tr("cfgNumPersian") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_numerals)
            onActivated: page.cfg_numerals = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgUnitScale")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "toman", label: page.tr("cfgToman") },
                { value: "rial",  label: page.tr("cfgRial") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_unitScale)
            onActivated: page.cfg_unitScale = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgCryptoBase")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "USD", label: "USD" },
                { value: "IRT", label: page.tr("cfgToman") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_cryptoBase)
            onActivated: page.cfg_cryptoBase = currentValue
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgAppearance")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgLabelStyle")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "name",   label: page.tr("cfgLabelName") },
                { value: "symbol", label: page.tr("cfgLabelSymbol") },
                { value: "both",   label: page.tr("cfgLabelBoth") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_labelStyle)
            onActivated: page.cfg_labelStyle = currentValue
        }

        QQC.CheckBox {
            id: showIcon
            text: page.tr("cfgShowIcon")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgIconSize")
            enabled: showIcon.checked
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "small",  label: page.tr("cfgSizeSmall") },
                { value: "medium", label: page.tr("cfgSizeMedium") },
                { value: "large",  label: page.tr("cfgSizeLarge") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_iconSize)
            onActivated: page.cfg_iconSize = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgFontSize")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: -1, label: page.tr("cfgSizeSmall") },
                { value: 0,  label: page.tr("cfgSizeNormal") },
                { value: 2,  label: page.tr("cfgSizeLarge") },
                { value: 4,  label: page.tr("cfgSizeHuge") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_fontDelta))
            onActivated: page.cfg_fontDelta = currentValue
        }

        Kirigami.Separator { Kirigami.FormData.isSection: true }

        QQC.CheckBox {
            id: showChange
            text: page.tr("cfgShowChange")
        }

        QQC.CheckBox {
            id: showDeltaBar
            text: page.tr("cfgShowDeltaBar")
        }

        QQC.CheckBox {
            id: showGroupLabels
            text: page.tr("cfgShowGroupLabels")
        }

        QQC.ComboBox {
            id: compactCombo
            Kirigami.FormData.label: page.tr("cfgCompactSymbol")

            readonly property var options: {
                var list = Assets.parseList(page.cfg_enabledAssets)
                if (list.length === 0)
                    list = ["USD"]
                return Assets.sorted(list)
            }

            model: options
            displayText: currentIndex >= 0
                ? Assets.nameFor(options[currentIndex], page.lang) : ""

            delegate: QQC.ItemDelegate {
                required property int index
                required property string modelData
                width: compactCombo.width
                text: Assets.nameFor(modelData, page.lang)
                icon.source: Assets.iconFor(modelData)
                highlighted: compactCombo.highlightedIndex === index
            }

            function sync() {
                var i = options.indexOf(page.cfg_compactSymbol)
                currentIndex = i >= 0 ? i : 0
                if (i < 0 && options.length > 0)
                    page.cfg_compactSymbol = options[0]
            }

            Component.onCompleted: sync()
            onOptionsChanged: sync()
            onActivated: page.cfg_compactSymbol = options[currentIndex]
        }
    }
}
