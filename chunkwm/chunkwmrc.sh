#!/bin/bash

#
# NOTE: specify the absolutepath to the directory to use when
#       loading a plugin. '~' expansion is supported.
#
chunkc core::log_file  /tmp/log.txt
chunkc core::plugin_dir /usr/local/opt/chunkwm/share/chunkwm/plugins

#
# NOTE: if enabled, chunkwm will monitor the specified plugin_dir
#       and automatically reload any '.so' file that is changed.
#
chunkc core::hotload 1

# Set tiling by default
chunkc set global_desktop_mode           bsp

# Reduce default offsets and gaps
chunkc set global_desktop_offset_top     1
chunkc set global_desktop_offset_bottom  1
chunkc set global_desktop_offset_left    1
chunkc set global_desktop_offset_right   1
chunkc set global_desktop_offset_gap     2

chunkc set bsp_spawn_left                1
chunkc set bsp_optimal_ratio             1.618
chunkc set bsp_split_mode                optimal
chunkc set bsp_split_ratio               0.5

chunkc set window_focus_cycle            monitor
chunkc set mouse_follows_focus           0
chunkc set window_float_next             0
chunkc set window_float_center           1
chunkc set window_region_locked          1

# Use fn as mouse modifier. You can resize windows by grabbing borders while pressing down fn key.
chunkc set mouse_modifier                fn

# NOTE: these settings require chwm-sa (https://github.com/koekeishiya/chwm-sa)
chunkc set window_float_topmost          0
chunkc set window_fade_inactive          0
chunkc set window_fade_alpha             0.85
chunkc set window_fade_duration          0.5
chunkc set window_use_cgs_move           0

# NOTE: the following are config variables for the chunkwm-border plugin.
# Set green border as prefix visual identifier
chunkc set preselect_border_color        0xff00ff00
chunkc set preselect_border_width        1
chunkc set preselect_border_radius       0
# Set red as current active window
chunkc set focused_border_color          0x99FF0000
chunkc set focused_border_width          4
chunkc set focused_border_radius         0
chunkc set focused_border_skip_floating  0


# NOTE: specify plugins to load when chunkwm starts.
chunkc core::load tiling.so
# Disable focus follow mouse
#chunkc core::load ffm.so
chunkc core::load border.so

# Default recommended rules
# NOTE: shell commands require escaped quotes to pass value containing a whitespace.
chunkc tiling::rule --owner Finder --name Copier --subrole AXStandardWindow --state float --level 15
chunkc tiling::rule --owner Finder --name "Progression iCloud" --subrole AXStandardWindow --state float --level 15
chunkc tiling::rule --owner \"App Store\" --state float

