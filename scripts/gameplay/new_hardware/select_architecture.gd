extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var new_hardware: NewHardware = %NewHardwareMarginContainer
@onready var select_architecture_button = preload("res://scenes/gameplay/select_architecture_button.tscn")

# Add setter for "visible" property
func _set(property, _value):
	match property:
		"visible":
			if (_value == true):
				if (update_select_architecture_list() < 1): # return to Screens.OFFICE if theres nothing to display
					gameplay.active_screen = gameplay.Screens.OFFICE
				elif(update_process_node_list() < 1):
					gameplay.active_screen = gameplay.Screens.OFFICE

## Updates the process node list
func update_process_node_list():
	var button_count = 0
	
	%ProcessNodeOptionButton.clear()
	
	for process_node in gameplay.ProcessNodes:
		if (process_node is Classes.ProcessNode):
			%ProcessNodeOptionButton.add_item(process_node.button_text, process_node.scale_nm)
			button_count += 1
	return button_count

## Updates the architecture list
func update_select_architecture_list():
	var button_count = 0
	
	for child in %SelectArchitectureFlowContainer.get_children(): # Clear the list.
		%SelectArchitectureFlowContainer.remove_child(child)
	
	for key in gameplay.Architectures: # Populate the list with buttons for each Architecture in Architectures
		var architecture: Classes.Architecture = gameplay.Architectures[key]
		if (architecture.hardware == new_hardware.selected_hardware):
			button_count += 1
			var button: SelectArchitectureButton = select_architecture_button.instantiate()
			
			button.new_hardware = new_hardware
			button.button_text = "%s\n[b]-Placeholder-[/b]" % [architecture.button_text] # TODO: alter once not placeholder
			button.architecture = architecture
			%SelectArchitectureFlowContainer.add_child(button)
	return button_count

func _on_close_button_pressed():
	gameplay.active_screen = gameplay.Screens.OFFICE


func _on_back_button_pressed():
	new_hardware.active_screen = new_hardware.Screens.SELECT_HARDWARE


func _on_done_button_pressed():
	pass # Replace with function body.
