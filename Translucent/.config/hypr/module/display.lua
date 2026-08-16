local externaldisplay = "HDMI-A-2"
local laptopdisplay = "eDP-1"

local rotationVal = 0
local rotate = {
  [0] = "2560x300", [1] = "1440x900"
}


hl.config({ cursor = { default_monitor = externaldisplay } })

hl.monitor({
  output = externaldisplay,
  mode = "modeline 542.25 2560 2776 3056 3552 1440 1443 1448 1527 -hsync +vsync",
  position = "0x0",
  scale = 1,
  transform = rotationVal -- rotation
})

hl.monitor({
  output = laptopdisplay,
  mode = "1920x1080",
  position = rotate[rotationVal],
  scale = 1,
  transform = 0
})

hl.workspace_rule({ workspace = "1", monitor = externaldisplay })
hl.workspace_rule({ workspace = "2", monitor = externaldisplay })
hl.workspace_rule({ workspace = "3", monitor = externaldisplay })
hl.workspace_rule({ workspace = "4", monitor = externaldisplay })
hl.workspace_rule({ workspace = "5", monitor = externaldisplay })
hl.workspace_rule({ workspace = "6", monitor = laptopdisplay })
hl.workspace_rule({ workspace = "7", monitor = laptopdisplay })
hl.workspace_rule({ workspace = "8", monitor = laptopdisplay })
hl.workspace_rule({ workspace = "9", monitor = laptopdisplay })
hl.workspace_rule({ workspace = "10", monitor = laptopdisplay })
-- hl.workspace_rule({ workspace = "2", no_rounding = true, decorate = false, gaps_in = 0, gaps_out = 0, no_border = true, monitor = externaldisplay })
