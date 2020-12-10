# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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

    # Keybinds for opening programs
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "b", lazy.spawn("alacritty -e bashtop")),
    Key([mod], "r", lazy.spawn("rofi -show run")),

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
    layout.MonadTall(margin=6),
    layout.Max(),
    layout.Floating(margin=6),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # 'layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Ubuntu Mono',
    fontsize=17,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(rounded=False,highlight_method = "text", active="696969", padding=4, fontsize=18),
                widget.Prompt(),
                widget.TextBox(text="[", foreground="696969"),
                widget.WindowName(foreground="696969", width=bar.CALCULATED),
                widget.TextBox(text="]", foreground="696969"),
                widget.TextBox(width=bar.STRETCH),

                widget.Systray(),
                widget.TextBox(text='|'),

                widget.CPU(),
                widget.TextBox(text='|'),
                
                widget.TextBox(text="volume: "),
                widget.Volume(),
                widget.TextBox(text='|'),

                widget.Clock(format = "%a, %b %d [ %H:%M ]"),
                widget.TextBox(text='|'),

                widget.TextBox(text="layout: "),
                widget.CurrentLayout(),
            ],
            26,
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
