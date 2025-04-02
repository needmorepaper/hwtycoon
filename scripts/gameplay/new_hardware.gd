class_name NewHardware extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene

enum Screen {SELECT_HARDWARE, SELECT_ARCHITECTURE, DESIGN}

## A screen manager for new_hardware's Screens
## TODO: Implement architecture and design screens
var active_screen: Screen:
	set(value):
		active_screen = value
		match value:
			Screen.SELECT_HARDWARE:
				%SelectHardwareMarginContainer.show_select_hardware()
			Screen.SELECT_ARCHITECTURE:
				push_error("Not implemented")
				%SelectHardwareMarginContainer.visible = false
			Screen.DESIGN:
				push_error("Not implemented")
				%SelectHardwareMarginContainer.visible = false

func show_new_hardware():
	active_screen = Screen.SELECT_HARDWARE
	self.visible = true
