-----------------------
-- GYR awesome theme --
-----------------------

theme = {}
theme.default_themes_path = "/usr/share/awesome/themes"
theme.blueish_theme_path = "/home/gyr/.config/awesome/blueish"
theme.font           = "terminus 8"

theme.colors = {}

theme.colors.black   = "#000000"
theme.colors.red     = "#ff0000"
theme.colors.green   = "#00ff00"
theme.colors.yellow  = "#ffff00"
theme.colors.blue    = "#4169e1"
theme.colors.magenta = "#ff00ff"
theme.colors.cyan    = "#00ffff"
theme.colors.gray    = "#bebebe"
theme.colors.white   = "#ffffff"
theme.colors.orange  = "#ffa500"
theme.colors.dark    = "#b0e0e6"
theme.colors.light   = "#e6faff"

theme.bg_normal     = "#121212"
theme.bg_focus      = theme.colors.dark
theme.bg_urgent     = theme.colors.orange
theme.bg_minimize   = "#444444"

theme.fg_normal     = theme.colors.dark
theme.fg_focus      = theme.colors.black
theme.fg_urgent     = theme.colors.black
theme.fg_minimize   = "#ffffff"

theme.bg_systray    = theme.bg_normal


theme.border_width  = "1"
theme.border_normal = theme.colors.gray
theme.border_focus  = theme.colors.blue
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.blueish_theme_path.."/taglist/sel.png"
theme.taglist_squares_unsel = theme.blueish_theme_path.."/taglist/unsel.png"

--theme.tasklist_floating_icon = theme.default_themes_path.."/default/tasklist/floatingw.png"
theme.tasklist_floating_icon = theme.default_themes_path.."/default/tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.default_themes_path.."/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.default_themes_path.."/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.default_themes_path.."/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.default_themes_path.."/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.default_themes_path.."/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.default_themes_path.."/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.default_themes_path.."/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.default_themes_path.."/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.default_themes_path.."/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.default_themes_path.."/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.default_themes_path.."/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.default_themes_path.."/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.default_themes_path.."/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.default_themes_path.."/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.default_themes_path.."/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.default_themes_path.."/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.default_themes_path.."/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.default_themes_path.."/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.default_themes_path.."/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
--theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_twins_paper_white_1600x900.png" }
--theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_twins_paper_blue_1600x900.png" }
theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_twins_paper_blue_1600x900_dark.png" }
--theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_paper_black_1600x900.png" }

-- You can use your own layout icons like this:
theme.layout_floating   = theme.blueish_theme_path.."/layouts/floating.png"
theme.layout_tile       = theme.blueish_theme_path.."/layouts/tile.png"
theme.layout_tilebottom = theme.blueish_theme_path.."/layouts/tilebottom.png"
theme.layout_fairv      = theme.blueish_theme_path.."/layouts/fairv.png"
theme.layout_fairh      = theme.blueish_theme_path.."/layouts/fairh.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- {{{ Widget icons
theme.widget_debian = theme.blueish_theme_path.."/icons/debian.png"
theme.widget_cpu    = theme.blueish_theme_path.."/icons/cpu.png"
theme.widget_bat    = theme.blueish_theme_path.."/icons/bat_full.png"
theme.widget_batc   = theme.blueish_theme_path.."/icons/bat_charge.png"
theme.widget_batd   = theme.blueish_theme_path.."/icons/bat_battery.png"
theme.widget_mem    = theme.blueish_theme_path.."/icons/mem.png"
theme.widget_fs     = theme.blueish_theme_path.."/icons/disk.png"
theme.widget_net    = theme.blueish_theme_path.."/icons/down.png"
theme.widget_netup  = theme.blueish_theme_path.."/icons/up.png"
theme.widget_wired  = theme.blueish_theme_path.."/icons/wired.png"
theme.widget_wifi   = theme.blueish_theme_path.."/icons/wifi.png"
theme.widget_vol    = theme.blueish_theme_path.."/icons/vol.png"
theme.widget_mute   = theme.blueish_theme_path.."/icons/volmute.png"
theme.widget_crypto = theme.blueish_theme_path.."/icons/crypto.png"
theme.widget_sep    = theme.blueish_theme_path.."/icons/separator.png"
-- }}}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
