extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene

func _on_resume_texture_button_toggled(toggled_on):
	gameplay.active_screen = gameplay.Screen.OFFICE
	gameplay.game_speed = gameplay.game_speed_previous


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
