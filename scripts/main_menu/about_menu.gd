extends MarginContainer
## Script that handles the about menu/prompt

@onready var main_menu: MainMenu = get_tree().current_scene

func _on_back_button_pressed():
	main_menu.active_screen = main_menu.Screen.MAIN_MENU 
