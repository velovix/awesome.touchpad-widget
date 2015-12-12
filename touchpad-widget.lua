local wibox = require("wibox")
local awful = require("awful")
require("string")

local Touchpad = { mt = {}, wmt = {} }
Touchpad.wmt.__index = Touchpad
Touchpad.__index = Touchpad

config = awful.util.getdir("config")

local function run(command)
	local prog = io.popen(command)
	local result = prog:read('*all')
	prog:close()
	return result
end

function Touchpad:new(args)
	local obj = setmetatable({}, Touchpad)

	obj.vendor = args.vendor or "Logitech"
	obj.mode = args.mode or "auto"

	-- Create imagebox widget and make it a button
	obj.widget = wibox.widget.imagebox()
	obj.widget:set_resize(false)
	obj.widget:set_image(config.."/awesome.touchpad-widget/icons/auto.png")
	obj.widget:buttons(awful.util.table.join(
		awful.button({}, 1, function()
			obj:switchMode()
			obj:update()
		end) ) )

	-- Create a tooltip for the imagebox
	obj.tooltip = awful.tooltip({ objects = { K },
		timer_function = function() return obj:tooltipText() end } )
	obj.tooltip:add_to_object(obj.widget)

	-- Check for a mouse every 5 seconds
	obj.timer = timer({ timeout = 5 })
	obj.timer:connect_signal("timeout", function() obj:update() end)
	obj.timer:start()

	return obj
end

function Touchpad:tooltipText()
	if self.mode == "auto" then
		return "Touchpad off if mouse is plugged in"
	elseif self.mode == "touchpadOn" then
		return "Touchpad enabled"
	elseif self.mode == "touchpadOff" then
		return "Touchpad disabled"
	end
end

function Touchpad:switchMode()
	if self.mode == "auto" then
		self.mode = "touchpadOn"
	elseif self.mode == "touchpadOn" then
		self.mode = "touchpadOff"
	elseif self.mode == "touchpadOff" then
		self.mode = "auto"
	end
end

function Touchpad:update()
	if self.mode == "auto" then
		result = run("lsusb")
		if string.find(result, self.vendor) then
			run("synclient touchpadoff=1")
		else
			run("synclient touchpadoff=0")
		end
		self.widget:set_image(config.."/awesome.touchpad-widget/icons/auto.png")
	elseif self.mode == "touchpadOn" then
		run("synclient touchpadoff=0")
		self.widget:set_image(config.."/awesome.touchpad-widget/icons/touchpad.png")
	elseif self.mode == "touchpadOff" then
		run("synclient touchpadoff=1")
		self.widget:set_image(config.."/awesome.touchpad-widget/icons/external.png")
	end
end

function Touchpad.mt:__call(...)
	return Touchpad.new(...)
end

return Touchpad
