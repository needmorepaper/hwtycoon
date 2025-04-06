extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var dropdown_button = preload("res://scenes/gameplay/dropdown_button.tscn")

# Add setter for "visible" property
func _set(property, _value):
	match property:
		"visible":
			if (_value == true):
				if (update_dropdown_list() > 0):
					self.position = get_viewport().get_mouse_position()
				else:
					gameplay.active_screen = gameplay.Screens.OFFICE

## Updates the dropdown list
func update_dropdown_list(): 
	var button_count = 0
	
	for child in %DropdownBoxContainer.get_children(): # Clear the list.
		%DropdownBoxContainer.remove_child(child)
	
	for key in gameplay.Screens: # Populate the list with buttons for unlocked screens
		var screen: Classes.Screen = gameplay.Screens[key]
		if (screen.unlocked):
			button_count += 1
			var button: DropdownButton = dropdown_button.instantiate()
			
			button.text = screen.button_text
			button.screen = screen
			
			%DropdownBoxContainer.add_child(button)
	return button_count
