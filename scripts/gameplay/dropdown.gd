extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var dropdown_button = preload("res://scenes/gameplay/dropdown_button.tscn")

func update_dropdown_list(): ## Updates the dropdown list
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

## Shows the dropdown menu if the menu has buttons to show.
func show_dropdown():
	if (update_dropdown_list() > 0):
		self.position = get_viewport().get_mouse_position()
		self.visible = true
	else:
		gameplay.active_screen = gameplay.Screens.OFFICE
