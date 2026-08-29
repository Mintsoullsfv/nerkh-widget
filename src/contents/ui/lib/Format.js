.pragma library
.import "Translations.js" as Tr

var PERSIAN_DIGITS = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"]

function toPersianDigits(s) {
    return String(s).replace(/[0-9]/g, function (d) {
        return PERSIAN_DIGITS[parseInt(d, 10)]
    })
}

function localizeDigits(s, numerals) {
    return numerals === "persian" ? toPersianDigits(s) : String(s)
}

function groupThousands(intPart, numerals) {
    var sep = numerals === "persian" ? "٬" : ","
    return intPart.replace(/\B(?=(\d{3})+(?!\d))/g, sep)
}

function trimDecimals(str, minKeep) {
    if (str.indexOf(".") === -1)
        return str
    var out = str.replace(/0+$/, "")
    var dot = out.indexOf(".")
    var kept = out.length - dot - 1
    while (kept < minKeep) {
        out += "0"
        kept++
    }
    if (out.charAt(out.length - 1) === ".")
        out = out.slice(0, -1)
    return out
}

function formatNumber(value, decimals, numerals) {
    if (value === undefined || value === null || isNaN(value))
        return "—"

    var neg = value < 0
    var abs = Math.abs(value)
    var fixed = abs.toFixed(Math.max(0, decimals))

    if (decimals > 0 && abs >= 1)
        fixed = trimDecimals(fixed, 0)
    else if (decimals > 0)
        fixed = trimDecimals(fixed, 1)

    var parts = fixed.split(".")
    var out = groupThousands(parts[0], numerals)
    if (parts.length > 1) {
        var pointChar = numerals === "persian" ? "٫" : "."
        out += pointChar + parts[1]
    }
    out = localizeDigits(out, numerals)
    return neg ? "−" + out : out
}

function formatPercent(value, numerals) {
    if (value === undefined || value === null || isNaN(value))
        return ""
    var sign = value > 0 ? "+" : (value < 0 ? "−" : "")
    var body = localizeDigits(Math.abs(value).toFixed(2).replace(/\.?0+$/, "") || "0", numerals)
    var pointChar = numerals === "persian" ? "٫" : "."
    body = body.replace(".", pointChar)
    return sign + body + " %"
}

function unitLabel(unit, unitScale, lang) {
    if (unit === "USD")
        return Tr.t(lang, "unitUsd")
    if (unit === "IRR" || unit === "IRT")
        return Tr.t(lang, unitScale === "rial" ? "unitRial" : "unitToman")
    return unit || ""
}

function scalePrice(value, unit, unitScale) {
    if (value === undefined || value === null || isNaN(value))
        return value
    if (unit === "IRR" && unitScale === "toman")
        return value / 10
    if (unit === "IRT" && unitScale === "rial")
        return value * 10
    return value
}

function relativeTime(timestampMs, lang, numerals) {
    if (!timestampMs)
        return Tr.t(lang, "never")

    var secs = Math.max(0, Math.round((Date.now() - timestampMs) / 1000))
    if (secs < 10)
        return Tr.t(lang, "justNow")
    if (secs < 60)
        return Tr.t(lang, "agoSeconds", localizeDigits(secs, numerals))
    var mins = Math.floor(secs / 60)
    if (mins < 60)
        return Tr.t(lang, "agoMinutes", localizeDigits(mins, numerals))
    var hours = Math.floor(mins / 60)
    if (hours < 24)
        return Tr.t(lang, "agoHours", localizeDigits(hours, numerals))
    return Tr.t(lang, "agoDays", localizeDigits(Math.floor(hours / 24), numerals))
}

function countdown(msRemaining, lang, numerals) {
    var secs = Math.max(0, Math.round(msRemaining / 1000))
    var mins = Math.floor(secs / 60)
    var rest = secs % 60
    var pad = rest < 10 ? "0" + rest : String(rest)
    var text = mins + ":" + pad
    return localizeDigits(text, numerals)
}
