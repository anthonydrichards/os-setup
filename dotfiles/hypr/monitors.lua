-- =============================================================================
-- monitors.lua – Single monitor 2560x1440 @ 165Hz
-- =============================================================================

-- monitor = name, resolution@hz, position, scale
hl.monitor({
    output = "",
    mode = "2560x1440@165",
    position = "0x0",
    scale = "1",
})

-- Enforce 10-bit output for HDR-capable panels (optional – remove if issues)
-- monitor = ,2560x1440@165,0x0,1,bitdepth,10
