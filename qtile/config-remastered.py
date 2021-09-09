# COMPLETELY RESTRUCTURE THE ENTIRE CONFIG FILE PLEASE.

import os
import re
import subprocess
from libqtile import qtile
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook
from libqtile.log_utils import logger

from typing import List  # noqa: F401

mod = 'mod4'

current_group = '1'

# Auto assign windows to groups on auto-start -- WIP

auto_assign_windows = {
    'slack': '3',
    'skype': '4',
    'spotify': '4',
    'brave': '5',
    'copyq': current_group
}

auto_assign_windows_keys = auto_assign_windows.keys()

@hook.subscribe.client_new
def window_opened(window):
    if window and window.name:
        window_name = window.name.lower()

        for auto_assign_window in auto_assign_windows_keys:
            is_contained = auto_assign_window in window_name

            if is_contained:
                group_number = auto_assign_windows[auto_assign_window]

                window.togroup(group_number)
                break

# Auto assign windows to groups on auto-start

def update_current_group(qtile):
    current_group = qtile.current_group.name
    auto_assign_windows['copyq'] = current_group

keys = [
    # Switch between windows in current stack pane
    Key([mod], 'period', lazy.next_screen()),
    Key([mod], 'k', lazy.layout.down()),
    Key([mod], 'j', lazy.layout.up()),

    # Keybinds for basic desktop management
    Key([mod], 'c', lazy.window.kill()),
    Key([mod], 'x', lazy.spawn('flameshot gui')),
    Key([mod], 'z', lazy.spawn('copyq toggle'), lazy.window.togroup('1')),
    Key([mod], 'Tab', lazy.next_layout()),
    Key([mod, 'control'], 'r', lazy.restart()),
    Key([mod, 'control'], 'q', lazy.shutdown()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_up()),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_down()),
    Key([mod], 'h', lazy.layout.grow()),
    Key([mod], 'l', lazy.layout.shrink()),
    Key([mod, 'shift'], 'q', lazy.shutdown()),
    Key([mod], 'space', lazy.widget['keyboardlayout'].next_keyboard()),
    Key([mod, 'shift'], 'b', lazy.hide_show_bar('all')),

    # Keybinds for opening programs
    Key([mod], 'Return', lazy.spawn('alacritty')),
    Key([mod, 'shift'], 's', lazy.spawn('slack')),
    Key([mod], 'r', lazy.spawn('rofi -show run')),
    Key([mod], 'b', lazy.spawn('chromium')), # swap to the correct browser
    Key([mod], 's', lazy.spawn('spotify')),
]

is_two_monitors = False
groups = []

groups_sample_one_monitor = [
    (0, '1', None),
    (0, '2', None),
    (0, '3', ['slack', 'slack']),
    (0, '4', ['skype', 'spotify']),
    (0, '5', ['brave'])
]

groups_sample_two_monitors = [
    (0, '1', None),
    (0, '2', None),
    (0, '3', ['slack', 'slack']),
    (1, '4', ['skype', 'spotify']),
    (1, '5', ['brave'])
]

def append_groups_keys(array):
    for monitor_index, group_name, spawn in array:
        group_object = Group(name = group_name)

        if spawn is not None:
            group_object.spawn = spawn

        groups.append(group_object)

        keys.append(
            Key(
                [mod],
                group_name,
                lazy.group[group_name].toscreen(
                    monitor_index,
                    toggle=False
                ),
                lazy.to_screen(monitor_index))
        )

        keys.append(
            Key([mod, "shift"], group_name, lazy.window.togroup(group_name))
        )

if is_two_monitors:
    append_groups_keys(groups_sample_two_monitors)
else:
    append_groups_keys(groups_sample_one_monitor)

main_color = 'cc7000'
font_size = 14

layouts = [
    layout.MonadTall(margin = 7, border_focus = main_color),
    layout.Max()
]

widget_defaults = dict(
    font = 'mononoki Nerd Font Bold',
    fontsize = font_size,
    padding = 3,
)

extension_defaults = widget_defaults.copy()

def get_lamda_callbacks(lamda_func_trigger, lamda_func, params):
    if lamda_func_trigger and lamda_func and params:
        return {
            lamda_func_trigger: lambda: lamda_func(params)
        }

    return {}

def put_separator():
    separator = widget.Sep(
        padding = 6,
        linewidth = 0
    )

    return separator

def put_text_box(text, lamda_func_trigger = None, lamda_func = None, params = None):
    text_box = widget.TextBox(
        text = text,
        mouse_callbacks = get_lamda_callbacks(lamda_func_trigger, lamda_func, params)
    )

    return text_box

def put_image(path, lamda_func_trigger = None, lamda_func = None, params = None):
    image = widget.Image(
        filename = path,
        scale = 'False',
        mouse_callbacks = get_lamda_callbacks(lamda_func_trigger, lamda_func, params)
    )

    return image

def put_keyboard_indicator():
    keyboard = widget.KeyboardLayout(
        foreground = main_color,
        configured_keyboards = ['us', 'bg phonetic'],
        display_map = {
            'us': 'US',
            'bg phonetic': 'BG'
        }
    )

    return keyboard

def put_clock():
    clock = widget.Clock(
        format = '%a, %b %d [ %H:%M ]',
        foreground = main_color
    )

    return clock

def put_current_layout():
    layout = widget.CurrentLayout(
        foreground = main_color
    )

    return layout

def put_current_window_name():
    window_name = widget.WindowName(
        fontsize = font_size,
        background = 'ffdab9',
        foreground = '000000',
        format = '[focused] [ {state}{name} ]',
    )

    return window_name

def put_group_layout():
    group_layout = widget.GroupBox(
        rounded = False,
        highlight_method = 'block',
        active = 'ffdab9',
        inactive = main_color,
        padding = 4,
        fontsize = 12
    )

    return group_layout

def get_widgets(start_range = None, end_range = None):
    widgets_list = [
        put_separator(),

        put_image(
            '~/.config/qtile/python.png',
            'Button1', qtile.cmd_spawn,
            'alacritty -e code /home/nazgo/.config/qtile'
        ),

        put_separator(),

        put_group_layout(),

        widget.Prompt(),

        put_current_window_name(),

        widget.Systray(
            background='ffdab9'
        ),

        put_text_box('volume: ', 'Button1', qtile.cmd_spawn, 'alacritty -e alsamixer'),

        widget.Volume(
            foreground=main_color,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e alsamixer')}
        ),

        put_text_box('clock: '),

        put_clock(),

        put_text_box('kb: '),

        put_keyboard_indicator(),

        put_text_box('[]=:'),

        put_current_layout(),

        put_image(
            '~/.config/qtile/pacman.png',
            'Button1', qtile.cmd_spawn,
            'alacritty -e sudo pacman -Syyu'
        ),

        widget.CheckUpdates(
            distro='Arch',
            display_format='{updates}',
            colour_have_updates=main_color,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty -e sudo pacman -Syyu')}
        ),

        put_separator(),
    ]

    if start_range is not None and end_range is not None:
        return widgets_list[start_range:end_range]

    return widgets_list


screens = [
    Screen(
        top=bar.Bar(
            # Here we want all of the widgets
            get_widgets(),
            20,
        ),
    ),
]

# When there are two monitors insert the second screen object
# to the list of screens
if is_two_monitors:
    screen_two = Screen(
        top=bar.Bar(
            [
                put_group_layout(),

                put_current_window_name(),

                put_keyboard_indicator(),

                put_text_box('[]=:'),

                put_current_layout(),
            ],
            20,
        ),
    )

    screens.insert(0, screen_two)

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
