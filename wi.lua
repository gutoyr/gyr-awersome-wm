-------------------
-- tdy's widgets --
-- awesome 3.4.9 --
-- <tdy@gmx.com> --
-------------------

require("vicious")
require("awful.tooltip")
require("naughty")

-- {{{ SETTINGS
graphwidth  = 30
graphheight = 14
vgraphwidth  = 6
vgraphheight = 14

-- Solarized / dark
require("beautiful")
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
colordark    = theme.colors.dark
colorlight   = theme.colors.light
upcolor      = colordark
downcolor    = colorblue
bordercolor  = colorred

--cpuinterval = 2
--netinterval = 2
--volinterval = 3
--meminterval = 5
--diskinterval = 7
--batinterval = 11
netinterval  = 2
volinterval  = 3
meminterval  = 5
diskinterval = 7
batinterval  = 11
tempinterval  = 13
pkginterval  = 997

-- }}}

-- {{{ SPACERS
spacer = widget({ type = "textbox" })
spacer.width = 1
tab = widget({ type = "textbox" })
tab.text = " | "
volspacer = widget({ type = "textbox" })
volspacer.text = " "
tabiconlf = widget({ type = "textbox" })
tabiconlf.text = '⮀'
tabiconl = widget({ type = "textbox" })
tabiconl.text = '⮁'
tabiconr = widget({ type = "textbox" })
tabiconr.text = '⮃'
tabicon = widget({ type = "imagebox" })
tabicon.image = image(beautiful.widget_sep)
debianicon = widget({ type = "imagebox" })
debianicon.image = image(beautiful.widget_debian)
-- }}}

--local function get_output(cmd)
--    cmdout = io.popen(cmd)
--    for c in cmdout:lines() do
--        co = c
--    end
--    return co
--end

-- {{{ GRAPH WIDGET
graph = {
    wired = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft }),
    wifi  = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft }),
    cpu   = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft }),
    tun   = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft }),
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
    mem    = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    swap   = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    fsroot = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    fshome = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    vol    = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    bat    = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
    wifi   = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft }),
}

for _, b in pairs(bar) do
    b:set_vertical(true):set_width(vgraphwidth):set_height(vgraphheight)
    b:set_ticks(true):set_ticks_size(1)
    b:set_background_color(colorblack):set_border_color(colorblack)
    b:set_gradient_colors({ colorlight, colordark, colorblue })
    b:set_max_value(100)
end

-- }}}

-- {{{ MEMORY
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
memtooltip = awful.tooltip({})
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
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
fstooltip = awful.tooltip({})
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
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
voltooltip = awful.tooltip({})
voltooltip:add_to_object(volicon)

-- cache
vicious.cache(vicious.widgets.volume)

-- register
vicious.register(volicon, vicious.widgets.volume,
    function(widget, args)
        voltooltip:set_text(args[2] .. args[1] .. "%")
        if args[2] == "♩" then
            --value = 0
            volicon.image = image(beautiful.widget_mute)
        else
            --value = args[1]
            volicon.image = image(beautiful.widget_vol)
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
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
battooltip = awful.tooltip({})
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
            baticon.image = image(beautiful.widget_batd)
        elseif args[1] == "+" then
            baticon.image = image(beautiful.widget_batc)
        else
            baticon.image = image(beautiful.widget_bat)
        end
        bar.bat:set_value(args[2])
    end, batinterval, "BAT0")

-- }}}

-- {{{ WIFI
wifiicon = widget({ type = "imagebox" })
wifiicon.image = image(beautiful.widget_wifi)
wifitooltip = awful.tooltip({})
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
wiredicon = widget({ type = "imagebox" })
wiredicon.image = image(beautiful.widget_wired)
upicon = widget({ type = "imagebox" })
upicon.image = image(beautiful.widget_netup)
downicon = widget({ type = "imagebox" })
downicon.image = image(beautiful.widget_net)
wiredtooltip = awful.tooltip({})
wiredtooltip:add_to_object(wiredicon)
upwidget = widget({ type = "textbox" })
upwidget.width = 50
downwidget = widget({ type = "textbox" })
downwidget.width = 50

-- wifi
wupicon = widget({ type = "imagebox" })
wupicon.image = image(beautiful.widget_netup)
wdownicon = widget({ type = "imagebox" })
wdownicon.image = image(beautiful.widget_net)
wupwidget = widget({ type = "textbox" })
wupwidget.width = 50
wdownwidget = widget({ type = "textbox" })
wdownwidget.width = 50

-- vpn
tunicon = widget({ type = "imagebox" })
tunicon.image = image(beautiful.widget_crypto)
tupicon = widget({ type = "imagebox" })
tupicon.image = image(beautiful.widget_netup)
tdownicon = widget({ type = "imagebox" })
tdownicon.image = image(beautiful.widget_net)
tuntooltip = awful.tooltip({})
tuntooltip:add_to_object(tunicon)
--tunwidget = widget({ type = "textbox" })
--tunwidget.width = 120
tupwidget = widget({ type = "textbox" })
tupwidget.width = 50
tdownwidget = widget({ type = "textbox" })
tdownwidget.width = 50

-- cache
vicious.cache(vicious.widgets.net)

-- register
vicious.register(wiredicon, vicious.widgets.net,
    function(widget, args)
        -- wired
        graph.wired:add_value(args["{eth0 up_kb}"], 1)
        graph.wired:add_value(args["{eth0 down_kb}"], 2)
        wiredtooltip:set_text("Total UP: " .. args["{eth0 tx_mb}"] .. "MB\nTotal DOWN:" .. args["{eth0 rx_mb}"] .. "MB")
        upwidget.text =  "<span color='" .. upcolor .. "'>" .. args["{eth0 up_kb}"] .. "k/s</span>"
        downwidget.text = "<span color='" .. downcolor .. "'>" .. args["{eth0 down_kb}"] .. "k/s</span>"

        -- wifi
        if wifitext ~= "N/A" then
            graph.wifi:add_value(args["{wlan0 up_kb}"], 1)
            graph.wifi:add_value(args["{wlan0 down_kb}"], 2)
            graph.wifi:set_width(graphwidth)
            wupicon.image = image(beautiful.widget_netup)
            wdownicon.image = image(beautiful.widget_net)
            wupwidget.text =  "<span color='" .. upcolor .. "'>" .. args["{wlan0 up_kb}"] .. "k/s</span>"
            wdownwidget.text = "<span color='" .. downcolor .. "'>" .. args["{wlan0 down_kb}"] .. "k/s</span>"
            wupwidget.width = 50
            wdownwidget.width = 50
            wifitooltip:set_text("Total UP: " .. args["{wlan0 tx_mb}"] .. "MB\nTotal DOWN: " .. args["{wlan0 rx_mb}"] .. "MB\n" .. wifitext)
        else
            graph.wifi:set_width(5)
            wupicon.image = image(nil)
            wdownicon.image = image(nil)
            wupwidget.text = ""
            wdownwidget.text = "<span color='" .. downcolor .. "'>✗</span>"
            wupwidget.width = 1
            wdownwidget.width = 10
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
            tupicon.image = image(nil)
            tdownicon.image = image(nil)
            tupwidget.text = ""
            tdownwidget.text = "<span color='" .. downcolor .. "'>✗</span>"
            tupwidget.width = 1
            tdownwidget.width = 10
            tuntooltip:set_text("VPN DISCONNECTED")
        else
            graph.tun:add_value(args["{" .. vpn_tp .. " up_kb}"], 1)
            graph.tun:add_value(args["{" .. vpn_tp .. " down_kb}"], 2)
            graph.tun:set_width(graphwidth)
            tupicon.image = image(beautiful.widget_netup)
            tdownicon.image = image(beautiful.widget_net)
            tupwidget.text =  "<span color='" .. upcolor .. "'>" .. args["{" .. vpn_tp .. " up_kb}"] .. "k/s</span>"
            tdownwidget.text = "<span color='" .. downcolor .. "'>" .. args["{" .. vpn_tp .. " down_kb}"] .. "k/s</span>"
            tupwidget.width = 50
            tdownwidget.width = 50
            tuntooltip:set_text("Interface: " .. vpn_tp .. "\nTotal UP:   " .. args["{" .. vpn_tp .. " tx_mb}"] .. "MB\nTotal DOWN: " .. args["{" .. vpn_tp .. " rx_mb}"] .. "MB")
        end
    end, netinterval)

-- }}}

-- {{{ CPU
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
cpuwidget = widget({ type = "textbox" })
cpuwidget.width = 20
graph.cpu:set_stack_colors({ colorlight , colorblue, colorcyan, colorgray })

-- cache
vicious.cache(vicious.widgets.cpu)

-- register
vicious.register(cpuicon, vicious.widgets.cpu,
    function (widget, args)
        graph.cpu:add_value(args[2], 1)
        graph.cpu:add_value(args[3], 2)
        graph.cpu:add_value(args[4], 3)
        graph.cpu:add_value(args[5], 4)
        cpuwidget.text = "<span color='" .. upcolor .. "'>".. args[1] .. "%</span>"
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
--cpupct0 = widget({ type = "textbox" })
--vicious.register(cpupct0, vicious.widgets.cpu, "$2%")
--
---- core 1 graph
--cpugraph1 = awful.widget.graph()
--cpugraph1:set_width(graphwidth):set_height(graphheight)
--cpugraph1:set_background_color(colorblack):set_color(colorcyan)
--vicious.register(cpugraph1, vicious.widgets.cpu, "$3")
--
---- core 1 %
--cpupct1 = widget({ type = "textbox" })
--vicious.register(cpupct1, vicious.widgets.cpu, "$3%")
--
---- core 2 graph
--cpugraph2 = awful.widget.graph()
--cpugraph2:set_width(graphwidth):set_height(graphheight)
--vicious.register(cpugraph2, vicious.widgets.cpu, "$4")
--
---- core 2 %
--cpupct2 = widget({ type = "textbox" })
--vicious.register(cpupct2, vicious.widgets.cpu, "$4%")
--
---- core 3 graph
--cpugraph3 = awful.widget.graph()
--cpugraph3:set_width(graphwidth):set_height(graphheight)
--vicious.register(cpugraph3, vicious.widgets.cpu, "$5")
--
---- core 3 %
--cpupct3 = widget({ type = "textbox" })
--vicious.register(cpupct3, vicious.widgets.cpu, "$5%")
---- }}}

-- {{{ MPD
---- cache
--vicious.cache(vicious.widgets.mpd)
--
---- common
--mpdwidget = widget({ type = "textbox" })
--mpdtooltip = awful.tooltip({})
--mpdtooltip:add_to_object(mpdwidget)
--
---- register
--vicious.register(mpdwidget, vicious.widgets.mpd, function(widget, args)
--    local info = ""
--    local info_text= ""
--    if args["{state}"] == "N/A" or args["{state}"] == "Stop" then
--        info = "□ "
--        info_text = ""
--    else
--        if args["{state}"] == "Play" then
--            info = "➲ "
--        elseif args["{state}"] == "Pause" then
--            info = "▯▯ "
--        end
--        info_text = args["{Artist}"] .. " - " .. args["{Title}"]
--    end
--    mpdtooltip:set_text(info_text)
--
--    return info
--end, volinterval)
--
---- buttons
--mpdwidget:buttons(awful.util.table.join(
--awful.button({ }, 1, function() awful.util.spawn("ncmpcpp toggle", false) end),
--awful.button({ "Shift" }, 1, function() awful.util.spawn("urxvtcd -e gyr-ncmpcpp", false) end),
--awful.button({ }, 3, function() awful.util.spawn("ncmpcpp stop", false) end),
--awful.button({ "Control" }, 1, function() awful.util.spawn("ncmpcpp next", false) end),
--awful.button({ }, 4, function() awful.util.spawn("ncmpcpp next", false) end),
--awful.button({ "Control" }, 3, function() awful.util.spawn("ncmpcpp prev", false) end),
--awful.button({ }, 5, function() awful.util.spawn("ncmpcpp prev", false) end)
--))

-- }}}

-- {{{ PACKAGES
---- cache
--vicious.cache(vicious.widgets.pkg)
--
--pkgwidget = widget({ type = "textbox" } )
--dist = get_output("lsb_release -si 2> /dev/null || echo 'Arch'")
--vicious.register(pkgwidget, vicious.widgets.pkg, "$1" , pkginterval, dist)
-- }}}

-- {{{ THERMAL
-- common
--tempicon = widget({ type = "imagebox" })
--tempicon.image = image(beautiful.widget_bat)
tempwidget = widget({ type = "textbox" })
tempwidget.width = 35 
--temptooltip = awful.tooltip({})
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
--        --    tempicon.image = image(beautiful.widget_tempd)
--        --elseif args[1] == "+" then
--        --    tempicon.image = image(beautiful.widget_tempc)
--        --else
--        --    tempicon.image = image(beautiful.widget_temp)
--        --end
--        --bar.temp:set_value(args[2])
--    end, tempinterval)

-- }}}

-- vim: set ff=unix fdm=marker:
