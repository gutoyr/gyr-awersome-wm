-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/blueish/theme.lua")

-- Import custom widget
local wi = require("wi")
local cal = require("cal")
-- This is used later as the default terminal and editor to run.
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
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
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
    tags[s] = awful.tag(taglist_numbers_sets["japanese"], s, layouts[2])
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
                                    { "Debian", debian.menu.Debian_menu.Debian, beautiful.widget_debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
cal.register(mytextclock, "<span color='red'>%s</span>")

-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", height = 14,  screen = s })
    -- Add widgets to the wibox - order matters
    if s == 1 then
        mywibox[s].widgets = {
            {
                --mpdwidget,
                --debianicon,
                tabiconlf,
                mytaglist[s],
                mypromptbox[s],
                tabiconl,
                --layout = awful.widget.layout.horizontal.leftright
            },
            mylayoutbox[s],
            s == 1 and mytextclock or nil,
            s == 1 and mysystray or nil,
            tabiconr, s == 1 and bar.bat or nil, baticon,
            tabiconr, s == 1 and bar.vol or nil, volicon,
            tabiconr, s == 1 and bar.swap or nil, s == 1 and bar.mem or nil, memicon,
            tabiconr, s == 1 and bar.fshome or nil, s == 1 and bar.fsroot or nil, fsicon,
            --tabicon, tunwidget, spacer, tunicon,
            tabiconr, tupwidget, tupicon, s == 1 and graph.tun or nil, tdownicon, tdownwidget, spacer, tunicon,
            tabiconr, wupwidget, wupicon, s == 1 and graph.wifi or nil, wdownicon, wdownwidget, spacer, s == 1 and bar.wifi or nil, wifiicon,
            tabiconr, upwidget, upicon, s == 1 and graph.wired or nil, downicon, downwidget, spacer, wiredicon,
            tabiconr, tempwidget, s == 1 and graph.cpu or nil, cpuwidget, cpuicon,
            tabiconr, mytasklist[s],
            --layout = awful.widget.layout.horizontal.rightleft
        }
    else
        mywibox[s].widgets = {
            {
                --mpdwidget,
                mytaglist[s],
                mypromptbox[s],
                tabicon,
                layout = awful.widget.layout.horizontal.leftright
            },
            mylayoutbox[s],
            tabicon, baticon,
            tabicon, volicon,
            tabicon, memicon,
            tabicon, fsicon,
            tabicon, tunwidget, spacer, tunicon,
            tabicon, wupwidget, upicon, downicon, wdownwidget, spacer, wifiicon,
            tabicon, upwidget, upicon, downicon, downwidget, spacer, wiredicon,
            tabicon, cpuwidget, cpuicon,
            tabicon, mytasklist[s],
            --layout = awful.widget.layout.horizontal.rightleft
        }
    end
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
-- Quake-like terminal
local quake = require("quake")

local quakeconsole = {}
for s = 1, screen.count() do
    quakeconsole[s] = quake({ terminal = "urxvtcd",
                              argname = "-name %s -e bash -c \"tmux -2 new-session -A -D -s DROPDOWN\"",
                              height = 0.6,
                              width = 0.99,
                              screen = s })
end

local multiscreens = require("multiscreens")

globalkeys = awful.util.table.join(
    awful.key({ modkey }, "`",
                function () quakeconsole[mouse.screen]:toggle() end),
    awful.key({ modkey }, "d", multiscreens.xrandr),
    awful.key({}, "XF86Display", multiscreens.xrandr),
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
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
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    awful.key({ modkey, "Shift"   }, "z", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey,           }, "z", function () awful.util.spawn("/home/gyr/.gyr.d/scripts/gyr-shutdown-dialog") end),
    awful.key({ modkey,           }, "s", function () awful.util.spawn("/home/gyr/.gyr.d/scripts/gyr-switch-window") end),
    --awful.key({ modkey,           }, "v", function () awful.util.spawn_with_shell("urxvtcd -e /home/gyr/.ibm.d/scripts/ibm-openconnect-vpnc.pl -v") end),
    awful.key({ modkey,           }, "v", function () awful.util.spawn("nohup /home/gyr/.ibm.d/scripts/ibm-openconnect-vpnc.pl -v") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

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

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    -- Volume
    awful.key({ }, "XF86AudioLowerVolume", function()
      awful.util.spawn("amixer -q set Master 2%- unmute")
    end),
    awful.key({ }, "XF86AudioRaiseVolume", function()
      awful.util.spawn("amixer -q set Master 2%+ unmute")
    end),
    awful.key({ }, "XF86AudioMute", function()
      awful.util.spawn("amixer -q set Master toggle")
    end),
    awful.key({ }, "XF86AudioMicMute", function()
      awful.util.spawn("amixer -q set Capture toggle")
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
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
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
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     size_hints_honor = false},
      -- http://www.reddit.com/r/awesomewm/comments/1n46d0/does_any_of_you_know_how_configure_awesome_to/
      callback = awful.client.setslave },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp-2.8" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Lotus Notes" },
      properties = { tag = tags[1][1]} },
                     --minimized = true } },
    { rule = { class = "Sylpheed" },
      properties = { tag = tags[1][1],
                     maximized = true } },
    { rule = { class = "Claws-mail" },
      properties = { tag = tags[1][1],
                     maximized = true } },
    { rule_any = { class = { "Iceweasel", "Firefox", "Chromium" } },
      callback = function(c)
        -- All windows should be slaves, except the browser windows.
        if c.role ~= "browser" then awful.client.setslave(c) end
      end },
    { rule_any = { class = { "Iceweasel", "Firefox" } },
      properties = { tag = tags[1][3], } },
    --                 maximized = true } },
    { rule_any = { class = { "Chromium", "Google-chrome-stable" } },
      properties = { tag = tags[1][3], } },
    --                 maximized = true } },
    { rule = { class = "Lotus Notes" , name = "Downloads" },
      properties = { floating = true } },
    { rule = { class = "Chromium" , name = "Hangouts" },
      properties = { floating = true } },
    { rule = { class = "Chromium" , name = "Google+ Hangouts" },
      properties = { floating = true } },
    { rule = { class = "Iceweasel", instance = "Download" },
      properties = { floating = true } },
    -- Fullscreen flash-player plugin
    --{ rule = { instance = "plugin-container" },
    --  properties = { floating = true }, callback = awful.titlebar.add  },
    -- Flash with Chromium
    { rule = { instance = "exe", class="Exe", instance="exe" },
      properties = { floating = true } },
    { rule = { class = "Xchat" },
      properties = { tag = tags[1][2] } },
    { rule_any = { class = { "Empathy", "Sametime", "Skype", "Pidgin"} },
      properties = { tag = tags[1][2],
                     floating = true } },
    --{ rule = { class = "Pidgin" },
    --  properties = { floating = true,
    --                 opacity = 0.85 } },
    -- Pidgin
    { rule = { class = "Pidgin" },
      except = { type = "dialog" },
      properties = {floating = true } },
    { rule = { class = "Pidgin" },
      except = { role = "buddy_list" }, -- buddy_list is the master
      properties = { }, callback = awful.client.setslave },
    { rule = { class = "Vncviewer" },
      properties = { floating = true } },
    { rule = { class = "Ssvnc" },
      properties = { floating = true } },
    { rule = { class = "ssvncviewer" },
      properties = { floating = true } },
    { rule = { class = "VirtualBox" },
      properties = { floating = true } },
    { rule = { class = "Agnclient" },
      properties = { floating = true,
                     minimized = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "Vpnui" },
      properties = { floating = true } },
    { rule = { class = "Volumeicon" },
      properties = { floating = true } },
    { rule = { class = "Pavucontrol" },
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
    { rule = { class = "Wpa_gui" },
      properties = { floating = true } },
    { rule = { class = "ssh-askpass", instance = "SshAskpass" },
      properties = { floating = true,
                     ontop = true } },
    { rule = { class = "Keepassx" },
      properties = { floating = true } },
    --  Should not be master
    { rule_any = { class =
                    { "URxvt",
                      "Transmission-gtk",
                      "Keepassx",
                    }, instance = { "Download" }},
       except = { instance = "QuakeConsoleNeedsUniqueName" },
       properties = { },
       callback = awful.client.setslave },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
        c.opacity = 1
    end)
client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
        c.opacity = 0.80
    end)

client.connect_signal("property::urgent", function(c)
    c.border_color = beautiful.border_urgent
    naughty.notify({text="Urgent: " .. c.name})
    if c.urgent then
        -- Change the border color of the urgent window.
        -- You'll need to define the color in your theme.lua, e.g.
        -- theme.border_urgent = "#FF3737CC"
        -- or you set the color directly to c.border_color
        c.border_color = beautiful.border_urgent

        -- Show a popup notification with the window title
        naughty.notify({text="Urgent: " .. c.name})
    end
end)
-- }}}

-- {{{ Autostart
function run_once(prg)
    if not prg then
        do return nil end
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

-- {{{ Daemons
function start_daemon(dae)
    daeCheck = os.execute("ps -eF | grep -v grep | grep -w " .. "\"" .. dae .. "\"")
    if (daeCheck ~= 0) then
        os.execute(dae .. " &")
    end
end

procs =
{
--    "/usr/bin/gnome-keyring-daemon --start --components=gpg",
--    "/usr/bin/gnome-keyring-daemon --start --components=pkcs11",
--    "/usr/bin/gnome-keyring-daemon --start --components=ssh",
--    "/usr/bin/gnome-keyring-daemon --start --components=secrets",
--    OR
--    "/usr/bin/gnome-keyring-daemon",
--    "/usr/lib/notification-daemon/notification-daemon",
--    "git annex assistant --autostart",
--    "wicd-client -t",
--    "xfce4-power-manager",
--    "fdpowermon",
    "xscreensaver -nosplash",
--    "volumeicon",
    "zeitgeist-datahub",
    "xcompmgr",
--    "unagi",
--    "devilspie -a",
    "urxvtd -q -f -o",
--    "tmux -2 new-session -A -D -d -s DROPDOWN",
    "/home/gyr/.gyr.d/scripts/gyr-redshift",
    "syndaemon -i 1 -d",
--    "conky -d -p 2 -c /home/gyr/.gyr.d/dotfiles/conkyrc-2cpu-awesome",
--    "/opt/ibm/ibmsam/bin/ibmsaml -q",
--    "/opt/ibm/c4eb/wst/bin/wst-applet",
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
--    "nm-applet --sm-disable",
--    "nm-applet",
    "synapse --startup",
    "keepassx -min -lock",
}

for k = 1, #procs do
    start_daemon(procs[k])
end

-- }}}
-- vim: set ff=unix fdm=marker:
