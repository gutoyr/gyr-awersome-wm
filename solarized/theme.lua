-----------------------------
-- Solarized awesome theme --
-----------------------------

theme = {}

theme.font           = "terminus 8"
theme.default_themes_path = "/usr/share/awesome/themes"
theme.solarized_theme_path = "/home/gyr/.config/awesome/solarized"

theme.colors = {}
-- dark
theme.colors.base03  = "#002b36"
theme.colors.base02  = "#073642"
theme.colors.base01  = "#586e75"
theme.colors.base00  = "#657b83"
theme.colors.base0   = "#839496"
theme.colors.base1   = "#93a1a1"
theme.colors.base2   = "#eee8d5"
theme.colors.base3   = "#fdf6e3"
-- light
--theme.colors.base3   = "#002b36"
--theme.colors.base2   = "#073642"
--theme.colors.base1   = "#586e75"
--theme.colors.base0   = "#657b83"
--theme.colors.base00  = "#839496"
--theme.colors.base01  = "#93a1a1"
--theme.colors.base02  = "#eee8d5"
--theme.colors.base03  = "#fdf6e3"

theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = "#268bd2"
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"

theme.bg_normal      = theme.colors.base03
theme.bg_focus       = theme.colors.base0
theme.bg_urgent      = theme.colors.red
theme.bg_minimize    = "#444444"
theme.bg_systray     = theme.bg_normal

theme.fg_normal      = theme.colors.base0
theme.fg_focus       = theme.colors.base03
theme.fg_urgent      = theme.colors.base03
theme.fg_minimize    = "#ffffff"

theme.border_normal  = theme.colors.base0
theme.border_focus   = theme.colors.red
theme.border_marked  = "#91231c"
theme.border_urgent  = theme.colors.yellow

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.solarized_theme_path.."/taglist/sel.png"
theme.taglist_squares_unsel = theme.solarized_theme_path.."/taglist/unsel.png"

--theme.tasklist_floating_icon = theme.default_themes_path.."/default/tasklist/floatingw.png"
--theme.tasklist_floating_icon = theme.default_themes_path.."/default/tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.default_themes_path.."/default/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

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

theme.wallpaper = "/home/gyr/.config/awesome/dragon_twins_paper_black_1600x900.png"

-- You can use your own layout icons like this:
theme.layout_floating   = theme.solarized_theme_path.."/layouts/floating.png"
theme.layout_tile       = theme.solarized_theme_path.."/layouts/tile.png"
theme.layout_tilebottom = theme.solarized_theme_path.."/layouts/tilebottom.png"
theme.layout_fairv      = theme.solarized_theme_path.."/layouts/fairv.png"
theme.layout_fairh      = theme.solarized_theme_path.."/layouts/fairh.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- {{{ Widget icons
theme.widget_debian = theme.solarized_theme_path.."/icons/debian.png"
theme.widget_cpu    = theme.solarized_theme_path.."/icons/cpu.png"
theme.widget_bat    = theme.solarized_theme_path.."/icons/bat_full.png"
theme.widget_batc   = theme.solarized_theme_path.."/icons/bat_charge.png"
theme.widget_batd   = theme.solarized_theme_path.."/icons/bat_discharge.png"
theme.widget_mem    = theme.solarized_theme_path.."/icons/mem.png"
theme.widget_fs     = theme.solarized_theme_path.."/icons/disk.png"
theme.widget_net    = theme.solarized_theme_path.."/icons/down.png"
theme.widget_netup  = theme.solarized_theme_path.."/icons/up.png"
theme.widget_wired  = theme.solarized_theme_path.."/icons/wired.png"
theme.widget_wifi   = theme.solarized_theme_path.."/icons/wifi.png"
theme.widget_mail   = theme.solarized_theme_path.."/icons/mail.png"
theme.widget_vol    = theme.solarized_theme_path.."/icons/vol.png"
theme.widget_mute   = theme.solarized_theme_path.."/icons/vol_mute.png"
theme.widget_crypto = theme.solarized_theme_path.."/icons/crypto.png"
theme.widget_sep    = theme.solarized_theme_path.."/icons/separator.png"
-- }}}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
