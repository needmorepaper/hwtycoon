extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene

func show_pause_menu():
	self.visible = true
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
