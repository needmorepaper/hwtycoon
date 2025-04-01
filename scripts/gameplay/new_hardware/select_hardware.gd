extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var select_hardware_button = preload("res://scenes/gameplay/select_hardware_button.tscn")

func update_select_hardware_list(): ## Updates the hardware list
	var button_count = 0
	
	for child in %SelectHardwareFlowContainer.get_children(): # Clear the list.
		%SelectHardwareFlowContainer.remove_child(child)
	
	for key in gameplay.Hardwares: # Populate the list with buttons for unlocked screens
		var hardware: Classes.Hardware = gameplay.Hardwares[key]
		if (hardware.unlocked):
			button_count += 1
			var button: SelectHardwareButton = select_hardware_button.instantiate()
			
			button.new_hardware = %NewHardwareMarginContainer
			button.button_text = "%s | lv.%d" % [hardware.button_text, hardware.level]
			button.button_progress = hardware.level_progress
			button.button_texture_normal = hardware.button_texture_normal
			button.button_texture_hover = hardware.button_texture_hover
			
			%SelectHardwareFlowContainer.add_child(button)
	print(button_count)
	return button_count

func show_select_hardware():
	if (update_select_hardware_list() > 0):
		self.visible = true
	else:
		gameplay.active_screen = gameplay.Screens.OFFICE

func _on_close_button_pressed():
	gameplay.active_screen = gameplay.Screens.OFFICE
