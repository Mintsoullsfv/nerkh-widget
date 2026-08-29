.pragma library


function iconPx(name, sizes) {
    if (name === "large")
        return sizes.medium        // 32-ish:
    if (name === "medium")
        return sizes.smallMedium   // 22-ish
    return sizes.small             // 16-ish (default)
}

function fontDelta(v) {
    var n = Number(v)
    if (isNaN(n))
        return 0
    return Math.max(-2, Math.min(6, Math.round(n)))
}
