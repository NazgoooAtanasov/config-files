local dpi = require("beautiful.xresources").apply_dpi
local theme = {}

theme.font = "sans 8"
theme.fg_normal = "#FFFFFF"
theme.fg_focus  = "#000000"
theme.fg_urgent = "#FF0000"
theme.bg_normal = "#000000"
theme.bg_focus = "#FFFFFF"
theme.bg_systray = theme.bg_normal
theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.border_normal = "#000000"
theme.border_focus = "#FFFFFF"

return theme
