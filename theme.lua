-----------------------
-- GYR awesome theme --
-----------------------

require("awful")

theme = {}

theme.default_themes_path = "/usr/share/awesome/themes"
theme.gyr_theme_path = awful.util.getdir("config")

--theme.font          = "sans 8"
theme.font          = "terminus 8"

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
-- default
--theme.bg_normal     = "#222222"
--theme.bg_focus      = "#535d6c"
--theme.bg_urgent     = "#ff0000"
--theme.bg_minimize   = "#444444"
--
--theme.fg_normal     = "#aaaaaa"
--theme.fg_focus      = "#ffffff"
--theme.fg_urgent     = "#ffffff"
--theme.fg_minimize   = "#ffffff"
--
--theme.border_width  = "1"
--theme.border_normal = "#000000"
--theme.border_focus  = "#535d6c"
--theme.border_marked = "#91231c"

-- Solarized

theme.bg_normal     = theme.colors.black
theme.bg_focus      = theme.colors.white
theme.bg_urgent     = theme.colors.red
theme.bg_minimize   = "#444444"

theme.fg_normal     = theme.colors.white
theme.fg_focus      = theme.colors.black
theme.fg_urgent     = theme.colors.black
theme.fg_minimize   = "#ffffff"

theme.bg_systray    = theme.bg_normal

-- black/paleturquoise
--theme.bg_normal     = "#222222"
--theme.bg_focus      = "#668b8b"
--theme.bg_urgent     = "#ff0000"
--theme.bg_minimize   = "#444444"
--
----theme.fg_normal     = "#6495ed"
--theme.fg_normal     = "#bbffff"
--theme.fg_focus      = "#bbffff"
--theme.fg_urgent     = "#bbffff"
--theme.fg_minimize   = "#bbffff"
--
--theme.border_width  = "1"
--theme.border_normal = "#000000"
--theme.border_focus  = "#bbffff"
--theme.border_marked = "#91231c"

-- white/red
--theme.bg_normal     = "#ff0000"
--theme.bg_focus      = "#000000"
--theme.bg_urgent     = "#ffffff"
--theme.bg_minimize   = "#444444"
--
--theme.fg_normal     = "#ffffff"
--theme.fg_focus      = "#ffffff"
--theme.fg_urgent     = "#000000"
--theme.fg_minimize   = "#ffffff"
--
--theme.border_width  = "1"
--theme.border_normal = "#000000"
--theme.border_focus  = "#ff0000"
--theme.border_marked = "#91231c"

-- black/white
--theme.bg_normal     = "#000000"
--theme.bg_focus      = "#ffffff"
--theme.bg_urgent     = "#ff0000"
--theme.bg_minimize   = "#444444"
--
--theme.fg_normal     = "#ffffff"
--theme.fg_focus      = "#000000"
--theme.fg_urgent     = "#000000"
--theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = theme.colors.white
theme.border_focus  = theme.colors.red
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
theme.taglist_squares_sel   = theme.gyr_theme_path.."/icons/taglist/sel.png"
theme.taglist_squares_unsel = theme.gyr_theme_path.."/icons/taglist/unsel.png"

--theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
--theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_twins_paper_white_1600x900.png" }
theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_twins_paper_black_1600x900.png" }
--theme.wallpaper_cmd = { "awsetbg -f /home/gyr/.config/awesome/dragon_paper_black_1600x900.png" }

-- You can use your own layout icons like this:
theme.layout_floating   = theme.gyr_theme_path.."/icons/layouts/floating.png"
theme.layout_tile       = theme.gyr_theme_path.."/icons/layouts/tile.png"
theme.layout_tilebottom = theme.gyr_theme_path.."/icons/layouts/tilebottom.png"
theme.layout_fairv      = theme.gyr_theme_path.."/icons/layouts/fairv.png"
theme.layout_fairh      = theme.gyr_theme_path.."/icons/layouts/fairh.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- {{{ Widget icons
theme.widget_debian = theme.gyr_theme_path.."/icons/debian.png"
theme.widget_cpu    = theme.gyr_theme_path.."/icons/cpu_white.png"
theme.widget_bat    = theme.gyr_theme_path.."/icons/bat_full_white.png"
theme.widget_batc   = theme.gyr_theme_path.."/icons/bat_charge_white.png"
theme.widget_batd   = theme.gyr_theme_path.."/icons/bat_battery_white.png"
theme.widget_mem    = theme.gyr_theme_path.."/icons/mem_white.png"
theme.widget_fs     = theme.gyr_theme_path.."/icons/disk_white.png"
theme.widget_net    = theme.gyr_theme_path.."/icons/down_white.png"
theme.widget_netup  = theme.gyr_theme_path.."/icons/up_white.png"
theme.widget_wired  = theme.gyr_theme_path.."/icons/wired_white.png"
theme.widget_wifi   = theme.gyr_theme_path.."/icons/wifi_white.png"
theme.widget_mail   = theme.gyr_theme_path.."/icons/mail.png"
theme.widget_vol    = theme.gyr_theme_path.."/icons/vol_white.png"
theme.widget_mute   = theme.gyr_theme_path.."/icons/volmute_white.png"
theme.widget_org    = theme.gyr_theme_path.."/icons/cal.png"
theme.widget_date   = theme.gyr_theme_path.."/icons/time.png"
theme.widget_crypto = theme.gyr_theme_path.."/icons/crypto_white.png"
theme.widget_sep    = theme.gyr_theme_path.."/icons/separator_white.png"
-- }}}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
