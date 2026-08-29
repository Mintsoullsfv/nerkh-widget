.pragma library


var DEFAULT_API = "http://nerkh.dns-dynamic.net"

var CATALOG = [
    { symbol: "USD", type: "fiat",   icon: "USD.svg", en: "US Dollar",       fa: "دلار آمریکا",     decimals: 0 },
    { symbol: "EUR", type: "fiat",   icon: "EUR.svg", en: "Euro",            fa: "یورو",             decimals: 0 },
    { symbol: "GBP", type: "fiat",   icon: "GBP.svg", en: "British Pound",   fa: "پوند انگلیس",      decimals: 0 },
    { symbol: "AED", type: "fiat",   icon: "AED.svg", en: "UAE Dirham",      fa: "درهم امارات",      decimals: 0 },
    { symbol: "JPY", type: "fiat",   icon: "JPY.svg", en: "Japanese Yen",    fa: "ین ژاپن",          decimals: 0 },
    { symbol: "KWD", type: "fiat",   icon: "KWD.svg", en: "Kuwaiti Dinar",   fa: "دینار کویت",       decimals: 0 },
    { symbol: "AUD", type: "fiat",   icon: "AUD.svg", en: "Australian Dollar", fa: "دلار استرالیا",  decimals: 0 },
    { symbol: "CAD", type: "fiat",   icon: "CAD.svg", en: "Canadian Dollar", fa: "دلار کانادا",      decimals: 0 },
    { symbol: "CNY", type: "fiat",   icon: "CNY.svg", en: "Chinese Yuan",    fa: "یوان چین",         decimals: 0 },
    { symbol: "TRY", type: "fiat",   icon: "TRY.svg", en: "Turkish Lira",    fa: "لیر ترکیه",        decimals: 0 },
    { symbol: "SAR", type: "fiat",   icon: "SAR.svg", en: "Saudi Riyal",     fa: "ریال عربستان",     decimals: 0 },
    { symbol: "CHF", type: "fiat",   icon: "CHF.svg", en: "Swiss Franc",     fa: "فرانک سوئیس",      decimals: 0 },
    { symbol: "INR", type: "fiat",   icon: "INR.svg", en: "Indian Rupee",    fa: "روپیه هند",        decimals: 0 },
    { symbol: "PKR", type: "fiat",   icon: "PKR.svg", en: "Pakistani Rupee", fa: "روپیه پاکستان",    decimals: 0 },
    { symbol: "IQD", type: "fiat",   icon: "IQD.svg", en: "Iraqi Dinar",     fa: "دینار عراق",       decimals: 0 },
    { symbol: "SYP", type: "fiat",   icon: "SYP.svg", en: "Syrian Pound",    fa: "لیر سوریه",        decimals: 0 },
    { symbol: "SEK", type: "fiat",   icon: "SEK.svg", en: "Swedish Krona",   fa: "کرون سوئد",        decimals: 0 },
    { symbol: "QAR", type: "fiat",   icon: "QAR.svg", en: "Qatari Riyal",    fa: "ریال قطر",         decimals: 0 },
    { symbol: "OMR", type: "fiat",   icon: "OMR.svg", en: "Omani Rial",      fa: "ریال عمان",        decimals: 0 },
    { symbol: "BHD", type: "fiat",   icon: "BHD.svg", en: "Bahraini Dinar",  fa: "دینار بحرین",      decimals: 0 },
    { symbol: "AFN", type: "fiat",   icon: "AFN.svg", en: "Afghan Afghani",  fa: "افغانی افغانستان", decimals: 0 },
    { symbol: "MYR", type: "fiat",   icon: "MYR.svg", en: "Malaysian Ringgit", fa: "رینگیت مالزی",   decimals: 0 },
    { symbol: "THB", type: "fiat",   icon: "THB.svg", en: "Thai Baht",       fa: "بات تایلند",       decimals: 0 },
    { symbol: "RUB", type: "fiat",   icon: "RUB.svg", en: "Russian Ruble",   fa: "روبل روسیه",       decimals: 0 },
    { symbol: "AZN", type: "fiat",   icon: "AZN.svg", en: "Azerbaijani Manat", fa: "منات آذربایجان", decimals: 0 },
    { symbol: "AMD", type: "fiat",   icon: "AMD.svg", en: "Armenian Dram",   fa: "درام ارمنستان",    decimals: 0 },
    { symbol: "GEL", type: "fiat",   icon: "GEL.svg", en: "Georgian Lari",   fa: "لاری گرجستان",     decimals: 0 },

    { symbol: "IR_GOLD_18K",    type: "metal", icon: "IR_GOLD_18K.svg",    en: "Gold 18K / gram",  fa: "طلای ۱۸ عیار",     decimals: 0 },
    { symbol: "IR_GOLD_24K",    type: "metal", icon: "IR_GOLD_24K.svg",    en: "Gold 24K / gram",  fa: "طلای ۲۴ عیار",     decimals: 0 },
    { symbol: "IR_GOLD_MELTED", type: "metal", icon: "IR_GOLD_MELTED.svg", en: "Melted gold",      fa: "طلای آب‌شده",       decimals: 0 },
    { symbol: "XAUUSD",         type: "metal", icon: "XAUUSD.svg",         en: "Gold ounce (XAU/USD)", fa: "انس جهانی طلا", decimals: 2 },
    { symbol: "IR_COIN_1G",     type: "metal", icon: "IR_COIN_1G.svg",     en: "1g coin",          fa: "سکهٔ یک گرمی",      decimals: 0 },
    { symbol: "IR_COIN_QUARTER",type: "metal", icon: "IR_COIN_QUARTER.svg",en: "Quarter coin",     fa: "ربع سکه",           decimals: 0 },
    { symbol: "IR_COIN_HALF",   type: "metal", icon: "IR_COIN_HALF.svg",   en: "Half coin",        fa: "نیم سکه",           decimals: 0 },
    { symbol: "IR_COIN_EMAMI",  type: "metal", icon: "IR_COIN_EMAMI.svg",  en: "Emami coin",       fa: "سکهٔ امامی",        decimals: 0 },
    { symbol: "IR_COIN_BAHAR",  type: "metal", icon: "IR_COIN_BAHAR.svg",  en: "Bahar Azadi coin", fa: "سکهٔ بهار آزادی",   decimals: 0 },
    { symbol: "USDT_IRT",       type: "crypto",icon: "USDT_IRT.svg",       en: "Tether / Toman",   fa: "تتر / تومان",       decimals: 0 },

    { symbol: "BTC",  type: "crypto", icon: "BTC.svg",  en: "Bitcoin",     fa: "بیت‌کوین",   decimals: 2 },
    { symbol: "ETH",  type: "crypto", icon: "ETH.svg",  en: "Ethereum",    fa: "اتریوم",     decimals: 2 },
    { symbol: "USDT", type: "crypto", icon: "USDT.svg", en: "Tether",      fa: "تتر",        decimals: 3 },
    { symbol: "XRP",  type: "crypto", icon: "XRP.svg",  en: "XRP",         fa: "ریپل",       decimals: 4 },
    { symbol: "BNB",  type: "crypto", icon: "BNB.svg",  en: "BNB",         fa: "بی‌ان‌بی",   decimals: 2 },
    { symbol: "SOL",  type: "crypto", icon: "SOL.svg",  en: "Solana",      fa: "سولانا",     decimals: 2 },
    { symbol: "USDC", type: "crypto", icon: "USDC.svg", en: "USD Coin",    fa: "یو‌اس‌دی‌کوین", decimals: 3 },
    { symbol: "TRX",  type: "crypto", icon: "TRX.svg",  en: "TRON",        fa: "ترون",       decimals: 4 },
    { symbol: "DOGE", type: "crypto", icon: "DOGE.svg", en: "Dogecoin",    fa: "دوج‌کوین",   decimals: 4 },
    { symbol: "ADA",  type: "crypto", icon: "ADA.svg",  en: "Cardano",     fa: "کاردانو",    decimals: 4 },
    { symbol: "LINK", type: "crypto", icon: "LINK.svg", en: "Chainlink",   fa: "چین‌لینک",   decimals: 3 },
    { symbol: "XLM",  type: "crypto", icon: "XLM.svg",  en: "Stellar",     fa: "استلار",     decimals: 4 },
    { symbol: "AVAX", type: "crypto", icon: "AVAX.svg", en: "Avalanche",   fa: "آوالانچ",    decimals: 2 },
    { symbol: "SHIB", type: "crypto", icon: "SHIB.svg", en: "Shiba Inu",   fa: "شیبا اینو",  decimals: 6 },
    { symbol: "LTC",  type: "crypto", icon: "LTC.svg",  en: "Litecoin",    fa: "لایت‌کوین",  decimals: 2 },
    { symbol: "DOT",  type: "crypto", icon: "DOT.svg",  en: "Polkadot",    fa: "پولکادات",   decimals: 3 },
    { symbol: "UNI",  type: "crypto", icon: "UNI.svg",  en: "Uniswap",     fa: "یونی‌سواپ",  decimals: 3 },
    { symbol: "ATOM", type: "crypto", icon: "ATOM.svg", en: "Cosmos",      fa: "کازموس",     decimals: 3 },
    { symbol: "FIL",  type: "crypto", icon: "FIL.svg",  en: "Filecoin",    fa: "فایل‌کوین",  decimals: 3 }
]

var DEFAULT_GROUP_ORDER = ["fiat", "metal", "crypto"]


var GROUP_ORDER = DEFAULT_GROUP_ORDER

var _index = null

function _byIndex() {
    if (_index === null) {
        _index = {}
        for (var i = 0; i < CATALOG.length; ++i)
            _index[CATALOG[i].symbol] = CATALOG[i]
    }
    return _index
}

function bySymbol(symbol) {
    if (!symbol)
        return null
    var s = String(symbol).toUpperCase()
    var hit = _byIndex()[s]
    return hit === undefined ? null : hit
}

function iconFor(symbol) {
    var a = bySymbol(symbol)
    return "../../icons/" + (a ? a.icon : "generic.svg")
}

function nameFor(symbol, lang) {
    var a = bySymbol(symbol)
    if (!a)
        return String(symbol)
    return lang === "fa" ? a.fa : a.en
}

function labelFor(symbol, lang, style) {
    var sym = String(symbol).toUpperCase()
    if (style === "symbol")
        return sym
    var name = nameFor(sym, lang)
    if (style === "both" && name !== sym)
        return name + "  ·  " + sym
    return name
}

function typeFor(symbol) {
    var a = bySymbol(symbol)
    return a ? a.type : "fiat"
}

function decimalsFor(symbol) {
    var a = bySymbol(symbol)
    return a ? a.decimals : 0
}

function ofType(type) {
    return CATALOG.filter(function (a) { return a.type === type })
}

function parseList(s) {
    if (!s)
        return []
    return String(s).split(",")
        .map(function (x) { return x.trim().toUpperCase() })
        .filter(function (x) { return x.length > 0 })
}

function parseGroupOrder(s) {
    var out = []
    var list = parseList(s).map(function (x) { return x.toLowerCase() })
    for (var i = 0; i < list.length; ++i)
        if (DEFAULT_GROUP_ORDER.indexOf(list[i]) !== -1 && out.indexOf(list[i]) === -1)
            out.push(list[i])
    // Append any groups the saved string forgot, so nothing ever disappears.
    for (var j = 0; j < DEFAULT_GROUP_ORDER.length; ++j)
        if (out.indexOf(DEFAULT_GROUP_ORDER[j]) === -1)
            out.push(DEFAULT_GROUP_ORDER[j])
    return out
}


function sortedBy(symbols, groupOrderStr) {
    var groups = parseGroupOrder(groupOrderStr)
    var rank = {}
    for (var i = 0; i < groups.length; ++i)
        rank[groups[i]] = i

    var indexed = symbols.map(function (s, i) { return { s: s, i: i } })
    indexed.sort(function (a, b) {
        var ga = rank[typeFor(a.s)]
        var gb = rank[typeFor(b.s)]
        if (ga === undefined) ga = 99
        if (gb === undefined) gb = 99
        if (ga !== gb)
            return ga - gb
        return a.i - b.i
    })
    return indexed.map(function (x) { return x.s })
}

function sorted(symbols) {
    return sortedBy(symbols, "")
}
