extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var new_hardware: NewHardware = %NewHardwareMarginContainer
@onready var select_hardware_button = preload("res://scenes/gameplay/select_hardware_button.tscn")

# Add setter for "visible" property
func _set(property, _value):
	match property:
		"visible":
			if (_value == true):
				if (update_select_hardware_list() < 1):
					gameplay.active_screen = gameplay.Screens.OFFICE

## Updates the hardware list
func update_select_hardware_list():
	var button_count = 0
	
	for child in %SelectHardwareFlowContainer.get_children(): # Clear the list.
		%SelectHardwareFlowContainer.remove_child(child)
	
	for key in gameplay.Hardwares: # Populate the list with buttons for each Hardware in Hardwares
		var hardware: Classes.Hardware = gameplay.Hardwares[key]
		if (hardware.unlocked):
			button_count += 1
			var button: SelectHardwareButton = select_hardware_button.instantiate()
			
			button.new_hardware = new_hardware
			button.button_text = "%s | lv.%d" % [hardware.button_text, hardware.level]
			button.button_progress = hardware.level_progress
			button.button_texture_normal = hardware.button_texture_normal
			button.button_texture_hover = hardware.button_texture_hover
			button.hardware = hardware
			%SelectHardwareFlowContainer.add_child(button)
	return button_count

func _on_close_button_pressed():
	gameplay.active_screen = gameplay.Screens.OFFICE
