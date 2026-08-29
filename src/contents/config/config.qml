import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Assets")
        icon: "view-financial-list"
        source: "config/configAssets.qml"
    }

    ConfigCategory {
        name: i18n("Display")
        icon: "preferences-desktop-theme"
        source: "config/configAppearance.qml"
    }

    ConfigCategory {
        name: i18n("Data source")
        icon: "network-server-database"
        source: "config/configApi.qml"
    }
}
