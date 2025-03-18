extends Node
## This is where everything that needs to be initialized for launch goes.

@onready var loading_screen_scene = load("res://scenes/loading_screen.tscn") ## Holds the scene used for loading between scenes
var current_scene ## Holds the path to the current scene loaded through load_scene()

var game_config = GameConfig.new()
var player_company: PlayerCompany:
	set(value):
		add_child(value)
		player_company = value

# Change window_mode on set game_config.fullscreen
func _on_game_config_fullscreen_changed(value):
	if (value):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## This function loads scene_path via the loading_screen_scene.
func load_scene(scene_path: String):
	current_scene = scene_path
	get_tree().change_scene_to_packed(loading_screen_scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hardware Tycoon for Godot 4")
	add_child(game_config)
	game_config.fullscreen_changed.connect(_on_game_config_fullscreen_changed)
	call_deferred("load_scene","res://scenes/main_menu.tscn")
