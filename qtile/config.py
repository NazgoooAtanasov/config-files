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

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "Tab", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "Tab", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "b", lazy.spawn("alacritty -e bashtop")),
    


    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    # Key([mod], "r", lazy.spawncmd()),
    Key([mod], "r", lazy.spawn("rofi -show run")),

    # Switch between groups
    Key([mod], "d", lazy.group["DEV"].toscreen()),
    Key([mod, "shift"], "d", lazy.window.togroup("DEV")),
    Key([mod], "f", lazy.group["FM"].toscreen()),
    Key([mod, "shift"], "f", lazy.window.togroup("FM")),
    Key([mod], "s", lazy.group["SY"].toscreen()),
    Key([mod, "shift"], "s", lazy.window.togroup("SY")),
    Key([mod], "c", lazy.group["CHR"].toscreen()),
    Key([mod, "shift"], "c", lazy.window.togroup("CHR")),
]

group_names = [
        ("DEV", {'layout': 'max'}),
        ("FM", {'layout': 'max'}),
        ("SY", {'layout': 'max'}),
        ("CHR", {'layout': 'max'}),
    ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

layouts = [
    layout.MonadTall(margin=6,border_focus="DCDCDC", border_normal="2F4F4F", border_width=2),
    layout.Max(),
    layout.Floating(margin=6,border_focus="DCDCDC", border_normal="2F4F4F", border_width=2),
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
    font='sans',
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(rounded=False,highlight_method = "line",active = "778899",),
                widget.Prompt(foreground="#778899"),
                widget.WindowName(foreground="#778899"),
                widget.TextBox(text="", foreground="DCDCDC", fontsize=46, padding=0),
                widget.Systray(background="#DCDCDC"),
                widget.TextBox(text="", foreground="2F4F4F",background="#DCDCDC", fontsize=46, padding=0),
                widget.TextBox(text="updates: ", background="2F4F4F"),
                widget.Pacman(background="2F4F4F", update_interval = 1800,),
                widget.TextBox(text="", foreground="#778899", background="2F4F4F",padding=0, fontsize=46),
                widget.Volume(background="#778899"),
                widget.TextBox(text="",background="778899", foreground="#2F4F4F",padding=0, fontsize=46),
                widget.CPU(background="#2F4F4F"),
                widget.TextBox(text="", foreground="#778899",background="2F4F4F",padding=0, fontsize=46),
                widget.Net(background="#778899"),
                widget.TextBox(text="", foreground="#2F4F4F",background="778899",padding=0, fontsize=46),
                widget.KeyboardLayout(background="#2F4F4F",configured_keyboards=['us','bg phonetic']),
                widget.TextBox(text="", foreground="#778899",background="2F4F4F",padding=0, fontsize=46),
                widget.Clock(background="#778899", format='%a %H:%M'),
                widget.TextBox(text="", foreground="#2F4F4F",background="#778899",padding=0, fontsize=46),
                widget.CurrentLayout(background="#2F4F4F"),
            ],
            20,
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
