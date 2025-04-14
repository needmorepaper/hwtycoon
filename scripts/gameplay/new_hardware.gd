class_name NewHardware extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene

var selected_hardware: Classes.Hardware
var selected_architecture: Classes.Architecture
var selected_process_node: Classes.ProcessMode

# Add setter for "visible" property
func _set(property, _value):
	match property:
		"visible":
			if (_value == true):
				active_screen = Screens.SELECT_HARDWARE

enum Screens {SELECT_HARDWARE, SELECT_ARCHITECTURE, DESIGN}

## A screen manager for new_hardware's Screens
var active_screen: Screens:
	set(value):
		active_screen = value
		match value:
			Screens.SELECT_HARDWARE:
				%SelectHardwareMarginContainer.visible = true
				%SelectArchitectureMarginContainer.visible = false
			Screens.SELECT_ARCHITECTURE:
				%SelectHardwareMarginContainer.visible = false
				%SelectArchitectureMarginContainer.visible = true
			Screens.DESIGN: # TODO: Define Screen.DESIGN
				push_error("Not implemented")
				%SelectHardwareMarginContainer.visible = false
				%SelectArchitectureMarginContainer.visible = true


func _on_backdrop_button_pressed():
	gameplay.active_screen = gameplay.Screens.OFFICE
