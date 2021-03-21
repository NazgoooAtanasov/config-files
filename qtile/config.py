import os
import re
import subprocess
from libqtile import qtile
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

mod = 'mod4'

keys = [
    # Switch between windows in current stack pane
    Key([mod], 'k', lazy.layout.down()),
    Key([mod], 'j', lazy.layout.up()),

    # Keybinds for basic desktop management
    Key([mod], 'c', lazy.window.kill()),
    Key([mod], 'Tab', lazy.next_layout()),
    Key([mod, 'control'], 'r', lazy.restart()),
    Key([mod, 'control'], 'q', lazy.shutdown()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_up()),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_down()),
    Key([mod], 'h', lazy.layout.grow()),
    Key([mod], 'l', lazy.layout.shrink()),
    Key([mod, 'shift'], 'q', lazy.shutdown()),
    Key([mod], 'space', lazy.widget['keyboardlayout'].next_keyboard()),


    # Keybinds for opening programs
    Key([mod], 'Return', lazy.spawn('alacritty')),
    Key([mod], 'b', lazy.spawn('alacritty -e bashtop')),
    Key([mod], 'r', lazy.spawn('dmenu_run')),

    # Switch between groups
    Key([mod], '1', lazy.group['1'].toscreen()),
    Key([mod, 'shift'], '1', lazy.window.togroup('1')),
    Key([mod], '2', lazy.group['2'].toscreen()),
    Key([mod, 'shift'], '2', lazy.window.togroup('2')),
    Key([mod], '3', lazy.group['3'].toscreen()),
    Key([mod, 'shift'], '3', lazy.window.togroup('3')),
    Key([mod], '4', lazy.group['4'].toscreen()),
    Key([mod, 'shift'], '4', lazy.window.togroup('4')),
    Key([mod], '5', lazy.group['5'].toscreen()),
    Key([mod, 'shift'], '5', lazy.window.togroup('5')),
]

group_names = [
        ('1', {'layout': 'monadtall'}),
        ('2', {'layout': 'monadtall'}),
        ('3', {'layout': 'monadtall'}),
        ('4', {'layout': 'monadtall'}),
        ('5', {'layout': 'monadtall'}),
    ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

main_color='cc7000'

layouts = [
    layout.MonadTall(margin=7, border_focus=main_color),
    layout.Max()
]

font_size=14

widget_defaults = dict(
    font='mononoki Nerd Font Bold',
    fontsize=font_size,
    padding=3,
)

extension_defaults = widget_defaults.copy()


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    padding = 6, 
                    linewidth = 0,
                ),

                widget.Image(
                    filename='~/.config/qtile/python.png', 
                    scale='False', 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e code /home/nazgo/.config/qtile')}
                ),

                widget.Sep(
                    padding = 6, 
                    linewidth = 0
                ),

                widget.GroupBox(
                    rounded=False, 
                    highlight_method='block', 
                    active='ffdab9', 
                    inactive=main_color,
                    padding=4, 
                    fontsize=12
                ),

                widget.Prompt(),
                
                widget.WindowName(
                    fontsize=font_size, 
                    background='ffdab9',
                    foreground='000000',
                    format='[focused] [ {state}{name} ]',
                ),

                widget.Systray(
                    background='ffdab9'
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='net:', 
                ),

                widget.Net(
                    foreground=main_color,
                    format='{down} ↓↑ {up}',
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='memory:', 
                ),

                widget.Memory(
                    foreground=main_color
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='cpu:', 
                ),

                widget.CPU(
                    format='{freq_current}GHz {load_percent}%',
                    foreground=main_color
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='volume: ', 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e alsamixer')}
                ),
                
                widget.Volume(
                    fontsize=font_size, 
                    foreground=main_color, 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e alsamixer')}
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='clock:', 
                ),

                widget.Clock(
                    fontsize=font_size, 
                    format = '%a, %b %d [ %H:%M ]', 
                    foreground=main_color
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='kb:', 
                ),

                widget.KeyboardLayout(
                    fontsize=font_size,
                    foreground=main_color,
                    configured_keyboards=['us', 'bg phonetic'],
                    display_map={
                        'us': 'US',
                        'bg phonetic': 'BG'
                    }
                ),

                widget.TextBox(
                    fontsize=font_size, 
                    text='[]=:', 
                ),

                widget.CurrentLayout(
                    fontsize=font_size, 
                    foreground=main_color
                ),

                widget.Image(
                    filename='~/.config/qtile/pacman.png', 
                    scale='False', 
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e sudo pacman -Syyu')}
                ),

                widget.CheckUpdates(
                    distro='Arch',
                    display_format='{updates}',
                    colour_have_updates=main_color,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e sudo pacman -Syyu')}
                ),

                widget.Sep(
                    padding = 6, 
                    linewidth = 0
                ),
            ],
            20,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.toggle_fullscreen())
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
focus_on_window_activation = 'smart'


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
wmname = 'LG3D'
