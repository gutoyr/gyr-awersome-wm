-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

---- Load Debian menu entries
--require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/gyr/.config/awesome/theme.lua")

-- Import custom widget
require("wi")
require("scratch")
require("cal")
-- This is used later as the default terminal and editor to run.
-- terminal = "x-terminal-emulator"
terminal = "urxvtcd -pe tabbed"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
taglist_numbers_sets = {
    japanese={"一", "二", "三", "四", "五", "六", "七", "八", "九"},
    roman={"Ⅰ","Ⅱ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅸ"},
    arabic={1, 2, 3, 4, 5, 6, 7, 8, 9 },
}
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(taglist_numbers_sets["japanese"], s, layouts[3])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "lock", "xscreensaver-command -lock" },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    --{ "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

--mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
--                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
cal.register(mytextclock, "<span color='black'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mygraphbox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height ="14", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        --{
        --    layout = awful.widget.layout.horizontal.leftright
        --},
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    -- Create the graphbox
    mygraphbox[s] = awful.wibox({ position = "bottom", height ="13", screen = s })
    mygraphbox[s].widgets = {
        {
            mpdwidget,
            mytaglist[s],
            mypromptbox[s],
            tabicon,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        s == 1 and mytextclock or nil,
        s == 1 and mysystray or nil,
        tabicon, s == 1 and bar.bat or nil, baticon,
        tabicon, s == 1 and bar.vol or nil, volicon,
        tabicon, s == 1 and bar.swap or nil, s == 1 and bar.mem or nil, memicon,
        tabicon, s == 1 and bar.fswork or nil, s == 1 and bar.fsroot or nil, fsicon,
        tabicon, tunwidget, spacer, tunicon,
        tabicon, wupwidget, upicon, s == 1 and graph.wifi or nil, downicon, wdownwidget, spacer, s == 1 and bar.wifi or nil, wifiicon,
        tabicon, upwidget, upicon, s == 1 and graph.wired or nil, downicon, downwidget, spacer, wiredicon,
        tabicon, s == 1 and graph.cpu or nil, cpuwidget, cpuicon,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "p",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    --awful.key({ modkey, "Shift"   }, "r", function () awful.util.spawn("dmenu_run -b") end),
    --awful.key({ modkey,           }, "z", function () awful.util.spawn("slock") end),
    awful.key({ modkey, "Shift"   }, "z", function () awful.util.spawn("xscreensaver-command -lock") end),
    --awful.key({ modkey, "Shift"   }, "z", function () awful.util.spawn("gnome-screensaver-command --lock") end),
    awful.key({ modkey,           }, "z", function () awful.util.spawn("/work/gyr/.gyr.d/scripts/gyr-shutdown-dialog") end),
    awful.key({ modkey,           }, "s", function () awful.util.spawn("/work/gyr/.gyr.d/scripts/gyr-switch-window") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    ---- Run or raise applications with dmenu
    --awful.key({ modkey }, "r",
    --    function ()
    --        local f_reader = io.popen( "dmenu_path | dmenu -b")
    --        local f_reader = io.popen( "dmenu_run -b")
    --        local command = assert(f_reader:read('*a'))
    --        f_reader:close()
    --        if command == "" then return end

    --        -- Check throught the clients if the class match the command
    --        local lower_command=string.lower(command)
    --        for k, c in pairs(client.get()) do
    --            local class=string.lower(c.class)
    --            if string.match(class, lower_command) then
    --                for i, v in ipairs(c:tags()) do
    --                    awful.tag.viewonly(v)
    --                    c:raise()
    --                    c.minimized = false
    --                    return
    --                end
    --            end
    --        end
    --        awful.util.spawn(command)
    --    end),
    --awful.key({ }, "F1", function () scratch.drop("xterm -e /work/gyr/.gyr.d/scripts/gyr-screen -z", "top", "center", 1, 0.60) end),
    --awful.key({ modkey }, "space", function () scratch.drop("xterm -e screen -t \"$ |bash\" -s /bin/bash -dR DROPDOWN", "top", nil, nil, 0.60) end),
    awful.key({ modkey }, "space", function () scratch.drop("urxvtcd -tn xterm-256color -e screen -t \"$ |bash\" -s /bin/bash -a -A -U -D -R DROPDOWN", "top", nil, nil, 0.60) end),
    --awful.key({ modkey }, "space", function () scratch.drop("urxvtc -pe tabbed", "top", nil, nil, 0.60) end),

    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/ 2>/dev/null'") end),
    -- Hide/Show wibox
    awful.key({ modkey }, "b", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),
    -- Calculator
    awful.key({ modkey }, "c", function ()
        awful.prompt.run({ prompt = "Calculate: " }, mypromptbox[mouse.screen].widget,
        function (expr)
            local result = awful.util.eval("return (" .. expr .. ")")
            naughty.notify({ text = expr .. " = " .. result, timeout = 10 })
        end
        )
    end),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end),
        -- Volume
    --awful.key({ }, "XF86AudioLowerVolume", function()
    --  awful.util.spawn("amixer -q set Master 2-% unmute")
    --end),
    --awful.key({ }, "XF86AudioRaiseVolume", function()
    --  awful.util.spawn("amixer -q set Master 2+% unmute")
    --end),
    awful.key({ }, "XF86AudioLowerVolume", function()
      awful.util.spawn("amixer -q set Master 2%- unmute")
    end),
    awful.key({ }, "XF86AudioRaiseVolume", function()
      awful.util.spawn("amixer -q set Master 2%+ unmute")
    end),
    awful.key({ }, "XF86AudioMute", function()
      awful.util.spawn("amixer -q set Master toggle")
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp-2.6" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    --{ rule = { class = "Lotus Notes" },
    --  properties = { maximized = true } },
    --  properties = { tag = tags[1][1],
    --                 maximized = true } },
    --{ rule = { class = "Firefox" },
    --  properties = { maximized = true } },
    --{ rule = { class = "Chromium-browser" },
    --  properties = { maximized = true } },
    --{ rule = { class = "Xchat"},
    --  properties = { maximized = true } },
    { rule = { class = "Iceweasel", instance = "Download" },
      properties = { floating = true } },
    -- Fullscreen flash-player plugin
    --{ rule = { instance = "plugin-container" },
    --  properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { class = "Vncviewer" },
      properties = { floating = true } },
    { rule = { class = "VirtualBox" },
      properties = { floating = true } },
    { rule = { class = "Empathy" },
      properties = { floating = true } },
    { rule = { class = "Agnclient" },
      properties = { floating = true } },
    { rule = { class = "Sametime" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { floating = true } },
    { rule = { class = "Pidgin" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "Vpnui" },
      properties = { floating = true } },
    { rule = { class = "Volumeicon" },
      properties = { floating = true } },
    { rule = { class = "Galculator" },
      properties = { floating = true } },
    { rule = { class = "Ibmsaml" },
      properties = { floating = true } },
    { rule = { class = "-c" },
      properties = { floating = true } },
    { rule = { class = "Wicd-client.py" },
      properties = { floating = true } },
    { rule = { class = "Polkit-gnome-authentication-agent-1" },
      properties = { floating = true } },
    { rule = { class = "SshAskpass" },
      properties = { floating = true } },
    { rule = { class = "Wpa_gui" },
      properties = { floating = true } },
    { rule = { class = "ssh-askpass" },
      properties = { floating = true } },
    --{ rule = { class = "Xfce4-mixer" },
    --  properties = { floating = true } },
    --{ rule = { class = "Nm-connection-editor" },
    --  properties = { floating = true } },
    --{ rule = { class = "Sylpheed" },
    --  properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
function run_once(prg)
    if not prg then
        do return nil end
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")")
end
--
--progs =
--{
--    "~/.gyr.d/scripts/gyr-awesome-startup",
--}
--
--for k = 1, #progs do
--    run_once(progs[k])
--end
-- }}}

-- {{{ Daemons
function start_daemon(dae)
    daeCheck = os.execute("ps -eF | grep -v grep | grep -w " .. "\"" .. dae .. "\"")
    if (daeCheck ~= 0) then
        os.execute(dae .. " &")
    end
end

procs =
{
    "/usr/bin/gnome-keyring-daemon --start --components=gpg",
    "/usr/bin/gnome-keyring-daemon --start --components=pkcs11",
--    "/usr/bin/gnome-keyring-daemon --start --components=ssh",
    "/usr/bin/gnome-keyring-daemon --start --components=secrets",
--    "/usr/lib/notification-daemon/notification-daemon",
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
--    "nm-applet --sm-disable",
--    "nm-applet",
--    "wicd-client -t",
--    "xfce4-power-manager",
--    "fdpowermon",
    "xscreensaver -nosplash",
--    "volumeicon",
    "synapse --startup",
    "zeitgeist-datahub",
    "xcompmgr",
    "devilspie -a",
    "/opt/ibm/ibmsam/bin/ibmsaml -q",
    "/opt/ibm/c4eb/wst/bin/wst-applet",
--    "urxvtd -q -f -o",
--    "conky -d -p 2 -c /home/gyr/.gyr.d/dotfiles/conkyrc-2cpu-awesome",
}

for k = 1, #procs do
    start_daemon(procs[k])
end
-- }}}
-- vim: set ff=unix fdm=marker:
