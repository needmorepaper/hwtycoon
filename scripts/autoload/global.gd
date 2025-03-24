extends Node
## This is where everything that needs to be initialized for launch goes.

@onready var loading_screen_scene = load("res://scenes/loading_screen.tscn") ## Holds the scene used for loading between scenes
var main_menu_scene = "res://scenes/main_menu.tscn" ## Holds the path to the main_menu scene.
var gameplay_scene = "res://scenes/gameplay.tscn" ## Holds the path to the gameplay_scene
var current_scene ## Holds the path to the current scene loaded through load_scene()

var classes = Classes.new()
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

func dev_quick_load(): ## WARNING: A DevTool to quickly load into gameplay. NOTE: Should probably be moved to a DevTool script.
	push_warning("WARNING: A DevTool is Active")
	var new_player_company = PlayerCompany.new()
	
	new_player_company.new_company = false
	new_player_company.company_name = "company_name: string"
	new_player_company.player_first_name = "player_first_name: string"
	new_player_company.player_last_name = "player_last_name: string"
	new_player_company.difficulty = PlayerCompany.Difficulty.EASY
	
	player_company = new_player_company
	call_deferred("load_scene",gameplay_scene)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hardware Tycoon for Godot 4")
	add_child(game_config)
	game_config.fullscreen_changed.connect(_on_game_config_fullscreen_changed)
	dev_quick_load()
	#call_deferred("load_scene",main_menu_scene) # WARNING: Temporarily replaced by dev_quick_load().
