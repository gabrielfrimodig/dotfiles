-- Required libraries
local watch = require("awful.widget.watch")

-- This watch function periodically executes the command 'xbacklight -get' to retrieve
-- the current screen brightness level. It runs this command every 2 seconds.
-- The output (stdout) from the command is the brightness level, which is then
-- converted to a number, rounded, and emitted as a signal.
-- The signal 'signal::brightness' is emitted with the brightness level as its parameter.
watch([[bash -c "xbacklight -get"]], 2, function(_, stdout)
    local brightness_level = math.floor(stdout + 0.5)

    awesome.emit_signal("signal::brightness", brightness_level)
end)
