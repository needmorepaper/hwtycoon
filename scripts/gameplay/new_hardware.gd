class_name NewHardware extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene

enum Screen {SELECT_HARDWARE, SELECT_ARCHITECTURE, DESIGN}

# A screen manager for new_hardware's Screens
var active_screen: Screen:
	set(value):
		active_screen = value
		match value:
			Screen.SELECT_HARDWARE:
				%SelectHardwareMarginContainer.show_select_hardware()
			Screen.SELECT_ARCHITECTURE:
				%SelectHardwareMarginContainer.visible = false
			Screen.DESIGN:
				%SelectHardwareMarginContainer.visible = false

func show_new_hardware():
	active_screen = Screen.SELECT_HARDWARE
	self.visible = true
