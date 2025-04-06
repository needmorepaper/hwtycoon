extends MarginContainer
## Pause menu controls

@onready var gameplay: Gameplay = get_tree().current_scene

# Add setter for "visible" property
func _set(property, _value):
	match property:
		"visible":
			if (_value == true):
				%ResumeTextureButton.button_pressed = false
				%SaveTextureButton.button_pressed = false
				%LoadTextureButton.button_pressed = false
				%SettingsTextureButton.button_pressed = false
				%ExitTextureButton.button_pressed = false


func _on_resume_texture_button_toggled(toggled_on):
	if (toggled_on):
		gameplay.active_screen = gameplay.Screens.OFFICE


func _on_save_texture_button_toggled(toggled_on):
	push_error("Not implemented")
	pass # Replace with function body.


func _on_load_texture_button_toggled(toggled_on):
	push_error("Not implemented")
	pass # Replace with function body.


func _on_settings_texture_button_toggled(toggled_on):
	push_error("Not implemented")
	pass # Replace with function body.


func _on_exit_texture_button_pressed():
	Global.load_scene(Global.main_menu_scene)


func _on_backdrop_button_pressed():
	gameplay.active_screen = gameplay.Screens.OFFICE
