import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "../lib/Assets.js" as Assets
import "../lib/Translations.js" as Tr

KCM.SimpleKCM {
    id: page

    property alias cfg_refreshInterval: intervalSpin.value
    property int cfg_refreshIntervalDefault: 5
    property alias cfg_autoRefresh: autoCheck.checked
    property bool cfg_autoRefreshDefault: true
    property alias cfg_apiBaseUrl: urlField.text
    property string cfg_apiBaseUrlDefault: ""
    property alias cfg_apiKey: keyField.text
    property string cfg_apiKeyDefault: ""
    property string cfg_authMethod: "auto"
    property string cfg_authMethodDefault: "auto"
    property string cfg_language: "auto"
    property string cfg_enabledAssets: ""

    readonly property string lang: {
        if (cfg_language === "fa" || cfg_language === "en")
            return cfg_language
        return Qt.locale().name.indexOf("fa") === 0 ? "fa" : "en"
    }

    function tr(key, args) { return Tr.t(lang, key, args) }

    property string testResult: ""
    property bool testOk: false
    property bool testing: false

    function testConnection() {
        var typed = urlField.text.trim().replace(/\/+$/, "")
        var base = typed.length > 0 ? typed : Assets.DEFAULT_API
        var key = keyField.text.trim()
        var method = cfg_authMethod

        var symbols = Assets.parseList(cfg_enabledAssets)
        if (symbols.length === 0)
            symbols = ["USD"]

        var url = base + "/v1/rates?symbols=" + encodeURIComponent(symbols.join(","))
                + "&base=IRT&crypto_base=USD&lang=" + lang
        if (key.length > 0 && method === "query")
            url += "&api_key=" + encodeURIComponent(key)

        testing = true
        testResult = ""

        var xhr = new XMLHttpRequest()
        xhr.open("GET", url)
        xhr.setRequestHeader("Accept", "application/json")
        if (key.length > 0 && method !== "none" && method !== "query") {
            if (method === "bearer" || method === "auto")
                xhr.setRequestHeader("Authorization", "Bearer " + key)
            if (method === "header" || method === "auto")
                xhr.setRequestHeader("X-API-Key", key)
        }

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            page.testing = false

            if (xhr.status === 0) {
                page.testOk = false
                page.testResult = page.tr("cfgTestFail", "no connection")
                return
            }

            var payload = null
            try {
                payload = JSON.parse(xhr.responseText)
            } catch (e) {
                payload = null
            }

            if (xhr.status >= 400 || !payload || payload.ok === false || !payload.rates) {
                page.testOk = false
                var msg = payload && payload.error ? payload.error.message
                                                   : ("HTTP " + xhr.status)
                page.testResult = page.tr("cfgTestFail", msg)
                return
            }

            page.testOk = true
            page.testResult = page.tr("cfgTestOk", payload.rates.length)
        }

        xhr.send()
    }

    LayoutMirroring.enabled: page.lang === "fa"
    LayoutMirroring.childrenInherit: true

    Kirigami.FormLayout {
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgUpdates")
        }

        QQC.CheckBox {
            id: autoCheck
            text: page.tr("cfgAutoRefresh")
        }

        RowLayout {
            Kirigami.FormData.label: page.tr("cfgInterval")
            spacing: Kirigami.Units.smallSpacing
            enabled: autoCheck.checked

            QQC.SpinBox {
                id: intervalSpin
                from: 1
                to: 1440
                stepSize: 1
                editable: true
            }

            QQC.Label {
                text: page.tr("cfgIntervalUnit")
            }
        }

        QQC.Label {
            Layout.fillWidth: true
            text: autoCheck.checked ? page.tr("cfgIntervalHint")
                                    : page.tr("cfgManualHint")
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
        }

        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgApi")
        }

        QQC.Label {
            Layout.fillWidth: true
            text: page.tr("cfgApiIntro")
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
        }

        QQC.TextField {
            id: urlField
            Kirigami.FormData.label: page.tr("cfgApiUrl")
            Layout.minimumWidth: Kirigami.Units.gridUnit * 20
            placeholderText: Assets.DEFAULT_API
            inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase
            LayoutMirroring.enabled: false
            horizontalAlignment: Text.AlignLeft
        }

        QQC.Label {
            text: page.tr("cfgApiUrlHint")
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgAuthMethod")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "auto",   label: page.tr("cfgAuthAuto") },
                { value: "bearer", label: page.tr("cfgAuthBearer") },
                { value: "header", label: page.tr("cfgAuthHeader") },
                { value: "query",  label: page.tr("cfgAuthQuery") },
                { value: "none",   label: page.tr("cfgAuthNone") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_authMethod)
            onActivated: page.cfg_authMethod = currentValue
        }

        Kirigami.PasswordField {
            id: keyField
            Kirigami.FormData.label: page.tr("cfgApiKey")
            Layout.minimumWidth: Kirigami.Units.gridUnit * 20
            enabled: page.cfg_authMethod !== "none"
            LayoutMirroring.enabled: false
            horizontalAlignment: Text.AlignLeft
        }

        QQC.Label {
            text: page.tr("cfgApiKeyHint")
            wrapMode: Text.WordWrap
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing

            QQC.Button {
                text: page.tr("cfgTest")
                icon.name: "network-connect"
                enabled: !page.testing
                onClicked: page.testConnection()
            }

            QQC.BusyIndicator {
                running: page.testing
                visible: page.testing
                implicitWidth: Kirigami.Units.iconSizes.small
                implicitHeight: Kirigami.Units.iconSizes.small
            }
        }

        RowLayout {
            visible: page.testResult.length > 0
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: page.testOk ? "dialog-ok" : "dialog-error"
                implicitWidth: Kirigami.Units.iconSizes.small
                implicitHeight: Kirigami.Units.iconSizes.small
            }

            QQC.Label {
                text: page.testResult
                color: page.testOk ? Kirigami.Theme.positiveTextColor
                                   : Kirigami.Theme.negativeTextColor
                wrapMode: Text.WordWrap
            }
        }
    }
}
