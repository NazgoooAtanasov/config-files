import os
import re
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "j", lazy.layout.up()),

    # Keybinds for basic desktop management
    Key([mod], "c", lazy.window.kill()),
    Key([mod], "space", lazy.next_layout()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_down()),
    Key([mod], "h", lazy.layout.grow()),
    Key([mod], "l", lazy.layout.shrink()),
    Key([mod, "shift"], "q", lazy.shutdown()),


    # Keybinds for opening programs
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "b", lazy.spawn("alacritty -e bashtop")),
    Key([mod], "r", lazy.spawn("dmenu_run")),
    Key([mod], "x", lazy.spawn("flameshot gui")),

    # Switch between groups
    Key([mod], "d", lazy.group["dev"].toscreen()),
    Key([mod, "shift"], "d", lazy.window.togroup("dev")),
    Key([mod], "f", lazy.group["fm"].toscreen()),
    Key([mod, "shift"], "f", lazy.window.togroup("fm")),
    Key([mod], "s", lazy.group["sy"].toscreen()),
    Key([mod, "shift"], "s", lazy.window.togroup("SY")),
    Key([mod], "w", lazy.group["www"].toscreen()),
    Key([mod, "shift"], "w", lazy.window.togroup("www")),
]

group_names = [
        ("dev", {'layout': 'monadtall'}),
        ("fm", {'layout': 'monadtall'}),
        ("sy", {'layout': 'monadtall'}),
        ("www", {'layout': 'monadtall'}),
    ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

layouts = [
    layout.MonadTall(margin=6, border_focus="cc7000"),
    layout.Max(),
    layout.Floating(margin=6)
]

widget_defaults = dict(
    font='Ubuntu Mono',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(rounded=False, highlight_method = "line", active="cc7000", inactive="cc7000", padding=4, fontsize=12),
                widget.Prompt(),
                widget.TextBox(text="[", foreground="cc7000"),
                widget.WindowName(foreground="cc7000", width=bar.CALCULATED),
                widget.TextBox(text="]", foreground="cc7000"),
                widget.TextBox(width=bar.STRETCH),

                widget.Systray(),
                widget.TextBox(text='|'),

                widget.CPU(foreground="cc7000"),
                widget.TextBox(text='|'),
                
                widget.TextBox(text="volume: ", foreground="cc7000"),
                widget.Volume(foreground="cc7000"),
                widget.TextBox(text='|'),

                widget.Clock(format = "%a, %b %d [ %H:%M ]", foreground="cc7000"),
                widget.TextBox(text='|'),

                widget.KeyboardLayout(foreground="cc7000", 
                    configured_keyboards=['us', 'bg phonetic'],
                    display_map={
                        'us': 'US',
                        'bg phonetic': 'BG'
                    }),
                widget.TextBox(text='|'),
                
                widget.TextBox(text="layout: ", foreground="cc7000"),
                widget.CurrentLayout(foreground="cc7000"),
            ],
            19,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
