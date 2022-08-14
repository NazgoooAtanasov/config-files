local dpi = require("beautiful.xresources").apply_dpi
local theme = {}

theme.font = "sans 8"
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#F0DFAF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#134A43"
theme.bg_focus = "#1E2320"
theme.bg_urgent = "#3F3F3F"
theme.bg_systray = theme.bg_normal
theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.border_normal = "#134A43"
theme.border_focus = "#ECB5BC"
theme.border_marked = "#CC9393"

return theme
