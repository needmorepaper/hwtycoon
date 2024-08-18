class_name GlobalInit extends Node
## [b]GlobalInit[/b] is where everything that needs to be initialized for launch goes.

var GameConfig = ConfigFile.new() ## Starts the ConfigFile class

## This function initializes the Game's configuration file.
## It can also be used to set the settings to their defaults.
func initialize_game_config():
	GameConfig.set_value("Audio", "music_volume", 0.95) ## Music volume
	GameConfig.set_value("Audio", "sound_volume", 0.75) ## Sound volume
	GameConfig.set_value("Display", "fullscreen", 0) ## Fullscreen
	GameConfig.set_value("Game", "autosave", 1) ## Autosaves the current game every month
	GameConfig.set_value("Game", "number_rounding", 1) ## Rounds up big numbers
	GameConfig.set_value("Game", "tax_notifs", 1) ## Shows a tax notification when it's paid for
	GameConfig.set_value("Game", "graph_scaling", 1) ## Automatically scales graphs
	GameConfig.set_value("Game", "competitor_news", 1) ## Shows your competitor's latest products
	GameConfig.set_value("Game", "r&d_autoscroll", 1) ## Autoscrolls your R&D tab to the latest tech
	GameConfig.set_value("Game", "text_speed", 29) ## How fast text scrolls
	GameConfig.save("user://gamesettings.cfg")
	print("GameConfig initialized")
	return

## This function returns a value from the GameConfig.
func get_game_config_value(section, key):
	return GameConfig.get_value(section, key)

## This function sets a value in the GameConfig.
func set_game_config_value(section, key, value):
	GameConfig.set_value(section, key, value)
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hardware Tycoon (godot) v0.2.12")
	# var load_bar = get_node("/root/LoadingScreen/ProgressBar")
	var main_menu_scene = preload("res://scenes/main_menu.tscn")
	
	var err = GameConfig.load("user://gamesettings.cfg")
	if err != OK:
		push_warning("Game config failed to load for unknown reason, initializing")
		# TODO: Tell user their config's invalid and has been reset
		# TODO: Check if there are alternate reasons for why a file doesn't load
		initialize_game_config()
		return
	
	print("Game config loaded")
	# Currently does not work.
	# load_bar.set_value(100)
	
	get_tree().call_deferred("change_scene_to_packed", main_menu_scene)
