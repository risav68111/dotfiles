MAIN_MOD = "SUPER"
TERMINAL = "kitty"
FILE_MANAGER = "thunar"
MENU = "rofi -show drun -theme ~/.config/rofi/themes/drun-translucent.rasi"

hl.bind("SUPER" .. " + Q", hl.dsp.exec_cmd(TERMINAL))
-- enviroment variables

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

require("module.autostart")
require("module.appearance")
require("module.inputs")
require("module.keybinds")
require("module.display")

hl.config({ cursor = { default_monitor = "HDMI-A-2" } })
