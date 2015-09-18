-------------------
-- tdy's widgets --
-- awesome 3.4.9 --
-- <tdy@gmx.com> --
-------------------

local vicious = require("vicious")
local awful = require("awful")
local awful_tooltip = require("awful.tooltip")
local naughty = require("naughty")
local wibox = require("wibox")

-- {{{ SETTINGS
graphwidth  = 30
graphheight = 14
vgraphwidth  = 6
vgraphheight = 14

-- Solarized / dark
local beautiful = require("beautiful")
--colorblack   = theme.colors.base02
--colorwhite   = theme.colors.base3
colorblack   = theme.colors.black
colorwhite   = theme.colors.white
colorred     = theme.colors.red
colorgreen   = theme.colors.green
colorblue    = theme.colors.blue
coloryellow  = theme.colors.yellow
colorcyan    = theme.colors.cyan
colormagenta = theme.colors.magenta
colorgray    = theme.colors.gray
colororange = theme.colors.orange
colordark    = theme.colors.dark
colorlight   = theme.colors.light
-- blueish
--upcolor      = colordark
--downcolor    = colorblue
--bordercolor  = colorred
-- whitred
upcolor      = colorwhite
downcolor    = colorred
bordercolor  = colorwhite

--cpuinterval = 2
netinterval  = 2
volinterval  = 3
meminterval  = 5
diskinterval = 7
batinterval  = 11
tempinterval  = 13
pkginterval  = 997

-- }}}

-- {{{ FUNCTION
local string = string
local function set_text_width(txt, width)
    local txtlen = string.len(txt)
    if txtlen < width then
        for count = 1, width - txtlen, 1 do
            txt = " " .. txt
        end
    end
    return txt
end

--local function get_output(cmd)
--    cmdout = io.popen(cmd)
--    for c in cmdout:lines() do
--        co = c
--    end
--    return co
--end

-- }}}

-- {{{ SPACERS
spacer = wibox.widget.textbox()
spacer:set_text(" ")
tab = wibox.widget.textbox()
tab:set_text(" | ")
tabiconlf = wibox.widget.textbox()
tabiconlf:set_text('⮀')
tabiconl = wibox.widget.textbox()
tabiconl:set_text('⮁')
tabiconr = wibox.widget.textbox()
tabiconr:set_text('⮃')
tabicon = wibox.widget.imagebox()
tabicon:set_image(beautiful.widget_sep)
debianicon = wibox.widget.imagebox()
debianicon:set_image(beautiful.widget_debian)
-- }}}

-- {{{ GRAPH WIDGET
graph = {
    wired = awful.widget.graph(),
    wifi  = awful.widget.graph(),
    cpu   = awful.widget.graph(),
    tun   = awful.widget.graph(),
}

for _, g in pairs(graph) do
    g:set_width(graphwidth):set_height(graphheight)
    g:set_background_color(colorblack):set_color(colorcyan)
    g:set_stack(true):set_max_value(100)
    g:set_background_color(colorblack)
    g:set_stack_colors({ upcolor , downcolor })
end

-- }}}

-- {{{ BAR WIDGET
bar = {
    mem    = awful.widget.progressbar(),
    swap   = awful.widget.progressbar(),
    fsroot = awful.widget.progressbar(),
    fshome = awful.widget.progressbar(),
    vol    = awful.widget.progressbar(),
    bat    = awful.widget.progressbar(),
    wifi   = awful.widget.progressbar(),
}

for _, b in pairs(bar) do
    b:set_vertical(true):set_width(vgraphwidth):set_height(vgraphheight)
    b:set_ticks(true):set_ticks_size(1)
    b:set_background_color(colorblack):set_border_color(colorblack)
    -- blueish
    --b:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, colorlight }, { 0.5, colordark }, { 1, colorblue } }})
    -- whitred
    b:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, colorred }, { 0.5, colorgray }, { 1, colorwhite } }})
    b:set_max_value(100)
end

-- }}}

-- {{{ MEMORY
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memtooltip = awful_tooltip({})
memtooltip:add_to_object(memicon)

-- cache memory
vicious.cache(vicious.widgets.mem)

-- register memory
vicious.register(memicon, vicious.widgets.mem,
    function(widget, args)
        memtooltip:set_text("MEMORY:\t" .. args[2] .. "MB/" .. args[4] .. "MB (" .. args[1] .. "%)\t" .. args[3] .. "MB\nSWAP:\t" .. args[6] .. "MB/" .. args[8] .. "MB (" .. args[5] .. "%)\t" .. args[7] .. "MB")
        bar.mem:set_value(args[1])
        bar.swap:set_value(args[5])
    end, meminterval)

-- }}}

-- {{{ FILESYSTEM
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
fstooltip = awful_tooltip({})
fstooltip:add_to_object(fsicon)

-- cache fs
vicious.cache(vicious.widgets.fs)

-- register fs
vicious.register(fsicon, vicious.widgets.fs,
    function(widget, args)
        fstooltip:set_text("/:\t" .. args["{/ used_gb}"] .. "GB/" .. args["{/ avail_gb}"] .. "GB (" .. args["{/ used_p}"] .. "%)\t" .. args["{/ size_gb}"] .. "GB\nhome:\t" .. args["{/home used_gb}"] .. "GB/" .. args["{/home avail_gb}"] .. "GB (" .. args["{/home used_p}"] .. "%)\t" .. args["{/home size_gb}"] .. "GB")
        bar.fsroot:set_value(args["{/ used_p}"])
        bar.fshome:set_value(args["{/home used_p}"])
    end, diskinterval)

-- }}}

-- {{{ VOLUME
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
voltooltip = awful_tooltip({})
voltooltip:add_to_object(volicon)

-- cache
vicious.cache(vicious.widgets.volume)

-- register
vicious.register(volicon, vicious.widgets.volume,
    function(widget, args)
        voltooltip:set_text(args[2] .. args[1] .. "%")
        if args[2] == "♩" then
            --value = 0
            volicon:set_image(beautiful.widget_mute)
        else
            --value = args[1]
            volicon:set_image(beautiful.widget_vol)
        end
        bar.vol:set_value(args[1])
    end, volinterval, "-c 0 Master")

-- buttons
volicon:buttons(awful.util.table.join(
--awful.button({ }, 1, function() awful.util.spawn("amixer -c 0 -q set Master toggle", false) end),
awful.button({ }, 1, function() awful.util.spawn("amixer -q set Master toggle", false) end),
--awful.button({ }, 1, function() awful.util.spawn("pactl set-sink-mute 0 -- toggle", false) end),
--awful.button({ }, 3, function() awful.util.spawn("xfce4-mixer", false) end),
awful.button({ }, 3, function() awful.util.spawn("pavucontrol", false) end),
awful.button({ }, 4, function() awful.util.spawn("amixer -c 0 -q set Master 3%+ unmute", false) end),
awful.button({ }, 4, function() awful.util.spawn("amixer -c 0 -q set Master 3%+ unmute", false) end),
awful.button({ "Control" }, 1, function() awful.util.spawn("amixer -c 0 -q set Master 3%+ unmute", false) end),
--awful.button({ "Control" }, 1, function() awful.util.spawn("pactl set-sink-volume 1 -- +10%", false) end),
awful.button({ }, 5, function() awful.util.spawn("amixer -c 0 -q set Master 3%- unmute", false) end),
--awful.button({ }, 5, function() awful.util.spawn("pactl set-sink-volume 0 -- -10%", false) end),
awful.button({ "Control" }, 3, function() awful.util.spawn("amixer -c 0 -q set Master 3%- unmute", false) end)
--awful.button({ "Control" }, 3, function() awful.util.spawn("pactl set-sink-volume 0 -- -10%", false) end)
))

-- }}}

-- {{{ BATTERY
-- common
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_bat)
battooltip = awful_tooltip({})
battooltip:add_to_object(baticon)

---- cache
vicious.cache(vicious.widgets.bat)

-- register
vicious.register(baticon, vicious.widgets.bat,
    function(widget, args)
        battooltip:set_text(args[1] .. args[2] .. "% " .. args [3])
        if args[2] < 10 then
            naughty.notify { text = "Critical batery level!!!\n\n>>>>>" ..  args[2] .. "\n", timeout = 10 }
        end
        if args[1] == "-" then
            baticon:set_image(beautiful.widget_batd)
        elseif args[1] == "+" then
            baticon:set_image(beautiful.widget_batc)
        else
            baticon:set_image(beautiful.widget_bat)
        end
        bar.bat:set_value(args[2])
    end, batinterval, "BAT0")

-- }}}

-- {{{ WIFI
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
wifitooltip = awful_tooltip({})
wifitooltip:add_to_object(wifiicon)
wifitext = "N/A"

-- cache
vicious.cache(vicious.widgets.wifi)

-- register
vicious.register(wifiicon, vicious.widgets.wifi,
    function(widget, args)
        if args["{ssid}"] ~= "N/A" then
        --if false then
            wifitext = "SSID: " .. args["{ssid}"] .. "\nRATE: " .. args ["{rate}"] .. "Mb/s\nLINK: " .. args["{link}"] .. "\nLINK %: " .. args["{linp}"] .. "%\nSIGNAL: " .. args["{sign}"] .. "dBm"
            bar.wifi:set_value(args["{linp}"])
        else
            wifitext = "N/A"
        end
    end, netinterval, "wlan0")

-- buttons
wifiicon:buttons(awful.util.table.join(
awful.button({ }, 1, function() awful.util.spawn("nm-connection-editor", false) end)
))

-- }}}

-- {{{ NETWORK

-- buttons
--tunicon:buttons(awful.util.table.join(
--awful.button({ }, 1, function() awful.util.spawn("urxvtcd -e gyr-ibm-openconnect-vpnc", false) end)
--))

-- wired
wiredicon = wibox.widget.imagebox()
wiredicon:set_image(beautiful.widget_wired)
upicon = wibox.widget.imagebox()
upicon:set_image(beautiful.widget_netup)
downicon = wibox.widget.imagebox()
downicon:set_image(beautiful.widget_net)
wiredtooltip = awful_tooltip({})
wiredtooltip:add_to_object(wiredicon)
upwidget = wibox.widget.textbox()
--upwidget.width = 50
downwidget = wibox.widget.textbox()
--downwidget.width = 50

-- wifi
wupicon = wibox.widget.imagebox()
wupicon:set_image(beautiful.widget_netup)
wdownicon = wibox.widget.imagebox()
wdownicon:set_image(beautiful.widget_net)
wupwidget = wibox.widget.textbox()
--wupwidget.width = 50
wdownwidget = wibox.widget.textbox()
--wdownwidget.width = 50

-- vpn
tunicon = wibox.widget.imagebox()
tunicon:set_image(beautiful.widget_crypto)
tupicon = wibox.widget.imagebox()
tupicon:set_image(beautiful.widget_netup)
tdownicon = wibox.widget.imagebox()
tdownicon:set_image(beautiful.widget_net)
tuntooltip = awful_tooltip({})
tuntooltip:add_to_object(tunicon)
--tunwidget = wibox.widget.textbox()
--tunwidget.width = 120
tupwidget = wibox.widget.textbox()
--tupwidget.width = 50
tdownwidget = wibox.widget.textbox()
--tdownwidget.width = 50

-- cache
vicious.cache(vicious.widgets.net)

-- register
vicious.register(wiredicon, vicious.widgets.net,
    function(widget, args)
        -- wired
        graph.wired:add_value(args["{eth0 up_kb}"], 1)
        graph.wired:add_value(args["{eth0 down_kb}"], 2)
        wiredtooltip:set_text("Total UP: " .. args["{eth0 tx_mb}"] .. "MB\nTotal DOWN:" .. args["{eth0 rx_mb}"] .. "MB")
        upwidget:set_markup("<span color='" .. upcolor .. "'>" .. args["{eth0 up_kb}"] .. "k/s</span>")
        downwidget:set_markup("<span color='" .. downcolor .. "'>" .. args["{eth0 down_kb}"] .. "k/s</span>")

        -- wifi
        if wifitext ~= "N/A" then
            graph.wifi:add_value(args["{wlan0 up_kb}"], 1)
            graph.wifi:add_value(args["{wlan0 down_kb}"], 2)
            graph.wifi:set_width(graphwidth)
            wupicon:set_image(beautiful.widget_netup)
            wdownicon:set_image(beautiful.widget_net)
            wupwidget:set_markup("<span color='" .. upcolor .. "'>" .. args["{wlan0 up_kb}"] .. "k/s</span>")
            wdownwidget:set_markup("<span color='" .. downcolor .. "'>" .. args["{wlan0 down_kb}"] .. "k/s</span>")
            --wupwidget.width = 50
            --wdownwidget.width = 50
            wifitooltip:set_text("Total UP: " .. args["{wlan0 tx_mb}"] .. "MB\nTotal DOWN: " .. args["{wlan0 rx_mb}"] .. "MB\n" .. wifitext)
        else
            graph.wifi:set_width(5)
            wupicon:set_image(nil)
            wdownicon:set_image(nil)
            wupwidget:set_text("")
            wdownwidget:set_markup("<span color='" .. downcolor .. "'>✗</span>")
            --wupwidget.width = 1
            --wdownwidget.width = 10
        end

        -- vpn
        --local info = ""
        --local info_text = ""
        --local tunwidth = 120
        local vpn_tp = ""
        if args["{tun0 tx_mb}"] then
            --info_text = "Interface: tun0\nTotal UP:   " .. args["{tun0 tx_mb}"] .. "MB\nTotal DOWN: " .. args["{tun0 rx_mb}"] .. "MB"
            --info = "<span color='" .. downcolor .. "'>"..args["{tun0 down_kb}"].."k/s ▼</span> <span color='" .. upcolor .. "'>▲ "..args["{tun0 up_kb}"].."k/s</span>"
            vpn_tp = "tun0"
        elseif args["{cscotun0 tx_mb}"] then
            --info_text = "Interface: cscotun0\nTotal UP:   " .. args["{cscotun0 tx_mb}"] .. "MB\nTotal DOWN: " .. args["{cscotun0 rx_mb}"] .. "MB"
            --info = "<span color='" .. upcolor .. "'>▲ "..args["{cscotun0 up_kb}"].."k/s</span> <span color='" .. downcolor .. "'>▼ "..args["{cscotun0 down_kb}"].."k/s</span>"
            vpn_tp = "cscotun0"
        elseif args["{vpn0 tx_mb}"] then
            --info_text = "Interface: vpn0\nTotal UP:   " .. args["{vpn0 tx_mb}"] .. "MB\nTotal DOWN: " .. args["{vpn0 rx_mb}"] .. "MB"
            --info = "<span color='" .. upcolor .. "'>▲ "..args["{vpn0 up_kb}"].."k/s</span> <span color='" .. downcolor .. "'>▼ "..args["{vpn0 down_kb}"].."k/s</span>"
            vpn_tp = "vpn0"
        --else
            --info_text = "VPN DISCONNECTED"
            --info = "<span color='" .. downcolor .. "'>✗</span>"
            --tunwidth = 10
        end
        --tuntooltip:set_text(info_text)
        --tunwidget.text = info
        --tunwidget.width = tunwidth
        if vpn_tp == "" then
            graph.tun:set_width(5)
            tupicon:set_image(nil)
            tdownicon:set_image(nil)
            tupwidget:set_text("")
            tdownwidget:set_markup("<span color='" .. downcolor .. "'>✗</span>")
            --tupwidget.width = 1
            --tdownwidget.width = 10
            tuntooltip:set_text("VPN DISCONNECTED")
        else
            graph.tun:add_value(args["{" .. vpn_tp .. " up_kb}"], 1)
            graph.tun:add_value(args["{" .. vpn_tp .. " down_kb}"], 2)
            graph.tun:set_width(graphwidth)
            tupicon:set_image(beautiful.widget_netup)
            tdownicon:set_image(beautiful.widget_net)
            tupwidget:set_markup("<span color='" .. upcolor .. "'>" .. args["{" .. vpn_tp .. " up_kb}"] .. "k/s</span>")
            tdownwidget:set_markup("<span color='" .. downcolor .. "'>" .. args["{" .. vpn_tp .. " down_kb}"] .. "k/s</span>")
            --tupwidget.width = 50
            --tdownwidget.width = 50
            tuntooltip:set_text("Interface: " .. vpn_tp .. "\nTotal UP:   " .. args["{" .. vpn_tp .. " tx_mb}"] .. "MB\nTotal DOWN: " .. args["{" .. vpn_tp .. " rx_mb}"] .. "MB")
        end
    end, netinterval)

-- }}}

-- {{{ CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
--cpuwidget.width = 20
-- blueish
graph.cpu:set_stack_colors({ colorlight , colorblue, colorcyan, colorgray })
graph.cpu:set_stack_colors({ colorwhite , colorgray, coloryellow, colorred })

-- cache
vicious.cache(vicious.widgets.cpu)

-- register
vicious.register(cpuicon, vicious.widgets.cpu,
    function (widget, args)
        graph.cpu:add_value(args[2], 1)
        graph.cpu:add_value(args[3], 2)
        graph.cpu:add_value(args[4], 3)
        graph.cpu:add_value(args[5], 4)
        local cputxt = set_text_width(args[1], 2)
        cpuwidget:set_markup("<span color='" .. upcolor .. "'>".. cputxt .. "%</span>")
    end)

-- core %
--vicious.register(cpupct, vicious.widgets.cpu, "$1%")

---- core 0 graph
--cpugraph0 = awful.widget.graph()
--cpugraph0:set_width(graphwidth):set_height(graphheight)
--cpugraph0:set_background_color(colorblack):set_color(colorcyan)
--vicious.register(cpugraph0, vicious.widgets.cpu, "$2")
--
---- core 0 %
--cpupct0 = wibox.widget.textbox()
--vicious.register(cpupct0, vicious.widgets.cpu, "$2%")
--
---- core 1 graph
--cpugraph1 = awful.widget.graph()
--cpugraph1:set_width(graphwidth):set_height(graphheight)
--cpugraph1:set_background_color(colorblack):set_color(colorcyan)
--vicious.register(cpugraph1, vicious.widgets.cpu, "$3")
--
---- core 1 %
--cpupct1 = wibox.widget.textbox()
--vicious.register(cpupct1, vicious.widgets.cpu, "$3%")
--
---- core 2 graph
--cpugraph2 = awful.widget.graph()
--cpugraph2:set_width(graphwidth):set_height(graphheight)
--vicious.register(cpugraph2, vicious.widgets.cpu, "$4")
--
---- core 2 %
--cpupct2 = wibox.widget.textbox()
--vicious.register(cpupct2, vicious.widgets.cpu, "$4%")
--
---- core 3 graph
--cpugraph3 = awful.widget.graph()
--cpugraph3:set_width(graphwidth):set_height(graphheight)
--vicious.register(cpugraph3, vicious.widgets.cpu, "$5")
--
---- core 3 %
--cpupct3 = wibox.widget.textbox()
--vicious.register(cpupct3, vicious.widgets.cpu, "$5%")
---- }}}

-- {{{ MPD
mpdwidget = wibox.widget.textbox()
mpdtooltip = awful_tooltip({})
mpdtooltip:add_to_object(mpdwidget)

-- cache
vicious.cache(vicious.widgets.mpd)

-- register
vicious.register(mpdwidget, vicious.widgets.mpd, function(widget, args)
    local info = ""
    local info_text= ""
    if args["{state}"] == "N/A" or args["{state}"] == "Stop" then
        info = "□ "
        info_text = ""
    else
        if args["{state}"] == "Play" then
            info = "➲ "
        elseif args["{state}"] == "Pause" then
            info = "▯▯ "
        end
        info_text = args["{Artist}"] .. " - " .. args["{Title}"]
    end
    mpdtooltip:set_text(info_text)

    return info
end, volinterval)

-- buttons
mpdwidget:buttons(awful.util.table.join(
awful.button({ }, 1, function() awful.util.spawn("mpc prev", false) end),
awful.button({ }, 2, function() awful.util.spawn("mpc toggle", false) end),
awful.button({ "Shift" }, 2, function() awful.util.spawn("mpc stop", false) end),
awful.button({ }, 3, function() awful.util.spawn("mpc next", false) end)
))

-- }}}

-- {{{ PACKAGES
---- cache
--vicious.cache(vicious.widgets.pkg)
--
--pkgwidget = wibox.widget.textbox()
--dist = get_output("lsb_release -si 2> /dev/null || echo 'Arch'")
--vicious.register(pkgwidget, vicious.widgets.pkg, "$1" , pkginterval, dist)
-- }}}

-- {{{ THERMAL
-- common
--tempicon = wibox.widget.imagebox()
--tempicon:set_image(beautiful.widget_bat))
tempwidget = wibox.widget.textbox()
--tempwidget.width = 35 
--temptooltip = awful_tooltip({})
--temptooltip:add_to_object(tempicon)

---- cache
vicious.cache(vicious.widgets.thermal)

--vicious.register(tempwidget, vicious.widgets.thermal, " $1°C", 13, { "coretemp.0/hwmon/hwmon1", "core"} )
vicious.register(tempwidget, vicious.widgets.thermal, " $1°C", 13, { "thermal_zone0", "sys" } )
-- register
--vicious.register(tempicon, vicious.widgets.thermal,
--    function(widget, args)
--        --tempwidget.text = "<span color='" .. upcolor .. "'>".. args[2] .. "%</span>"
--        tempwidget.text = "teste"
--        temptooltip:set_text(args[1] .. args[2] .. "% " .. args [3])
--        --if args[1] == "-" then
--        --    tempicon:set_image(beautiful.widget_tempd)
--        --elseif args[1] == "+" then
--        --    tempicon:set_image(beautiful.widget_tempc)
--        --else
--        --    tempicon:set_image(beautiful.widget_temp)
--        --end
--        --bar.temp:set_value(args[2])
--    end, tempinterval)

-- }}}

-- vim: set ff=unix fdm=marker:
