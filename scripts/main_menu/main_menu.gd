class_name MainMenu extends MarginContainer
## This script handles all Main Menu functions

enum Screen {MAIN_MENU, NEW_GAME, LOAD_GAME, SETTINGS, ABOUT}

var active_screen: Screen:
	set(value):
		active_screen = value
		match value:
			Screen.MAIN_MENU:
				%MainMenuMarginContainer.visible = true
				%NewGameMarginContainer.visible = false
				%SettingsMarginContainer.visible = false
				%AboutMarginContainer.visible = false
			Screen.NEW_GAME:
				%MainMenuMarginContainer.visible = false
				%NewGameMarginContainer.visible = true
				%SettingsMarginContainer.visible = false
				%AboutMarginContainer.visible = false
			Screen.LOAD_GAME:
				push_error("Not implemented")
			Screen.SETTINGS:
				%MainMenuMarginContainer.visible = false
				%NewGameMarginContainer.visible = false
				%SettingsMarginContainer.visible = true
				%AboutMarginContainer.visible = false
			Screen.ABOUT:
				%MainMenuMarginContainer.visible = false
				%NewGameMarginContainer.visible = false
				%SettingsMarginContainer.visible = false
				%AboutMarginContainer.visible = true

func _ready():
	Global.game_config.changed.connect(_on_game_config_changed)
	active_screen = Screen.MAIN_MENU

func _on_new_game_button_pressed():
	active_screen = Screen.NEW_GAME
	return

func _on_load_game_button_pressed():
	push_error("Not implemented")
	# active_screen = Screen.LOAD_GAME
	return

func _on_settings_button_pressed():
	active_screen = Screen.SETTINGS
	return

func _on_about_button_pressed():
	active_screen = Screen.ABOUT
	return

func _on_fullscreen_button_toggled(toggled_on):
	if (toggled_on):
		Global.game_config.fullscreen = true
	else:
		Global.game_config.fullscreen = false

func _on_game_config_changed():
	%FullscreenButton.set_pressed_no_signal(Global.game_config.fullscreen)
