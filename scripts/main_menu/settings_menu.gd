extends MarginContainer

@onready var main_menu: MainMenu = get_tree().current_scene

func _ready():
	Global.game_config.changed.connect(_on_game_config_changed)


func _on_fullscreen_setting_check_button_toggled(toggled_on):
	if (toggled_on):
		Global.game_config.fullscreen = true
	else:
		Global.game_config.fullscreen = false


func _on_game_config_changed():
	%FullscreenSettingCheckButton.set_pressed_no_signal(Global.game_config.fullscreen)


func _on_back_button_pressed():
	main_menu.active_screen = main_menu.Screen.MAIN_MENU 
