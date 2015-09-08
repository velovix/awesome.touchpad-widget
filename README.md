# Touchpad Widget
Provides a simple touchpad widget for the Awesome window manager. It allows you to enable and disable the touchpad,
as well as enable it only when a USB mouse is connected. This seems to be a real problem for desktop managers. Even
Unity doesn't allow you to auto-disable the touchpad like on Windows. But with this extension, we can achieve the
seemingly impossible!

###Dependencies
No extra Awesome libraries are required, but you have to have the `synclient` and `lsusb` commands available.

###Setup
1. Navigate to your Awesome config directory (usually `~/.config/awesome`) and clone this repository with the following
command:

	```
	git clone https://github.com/velovix/awesome.touchpad-widget
	```
2. Create a symlink for the touchpad-widget.lua file. This is done so that your rc.lua can find the code, and so you can
update the widget by simply pulling in changes from this repository later. While still in the Awesome config directory,
run the following:

	```
	ln -s awesome.touchpad-widget/touchpad-widget.lua touchpad-widget.lua
	```
3. In your rc.lua, add the following near the beginning of the file. This loads up the library and has you access it
through the new touchpad_widget table we're creating.

	```
	local touchpad_widget = require("touchpad-widget")
	```
4. Add the following line near the beginning of your rc.lua, but after the line in the previous step. You probably will
have to provide a vendor string unless you use a Logitech mouse, which is the default. To get a fitting vendor string,
run `lsusb` and find the name of your mouse from the list. Any section of the name that is unique enough to that device
will be fine. All the widget does is run `lsusb` and check to see if your vendor string is in the results. You can also
set the default mode with the `mode` option. Acceptable values are "touchpadOn", "touchpadOff", and "auto". The default
is "auto".

	```
	touchpad = touchpad_widget:new({vendor="your vendor")
	```
5. Finally, to add your widget to the bar, you'll have to add the following line somewhere after the `right_layout`
table is created.

	```
	right_layout:add(touchpad.widget)
	```
6. Restart Awesome WM and you're finished! You should see a white touchpad icon on the top right of the screen! You can
click it to change between touchpad enabled, touchpad disabled, and automatic mode.
