class_name GameConfig extends Node
## This node initializes the Game's configuration file.
## It can also be used to set the settings to their defaults.

signal changed
signal fullscreen_changed

var game_config = ConfigFile.new()


@export_category("Audio Settings") # Audio Settings
@export var music_volume: float = 0.95: ## Music volume
	set(value): 
		game_config.set_value("Audio", "music_volume", value) # Update ConfigFile
		music_volume = value # Change value
		changed.emit() # Update anything using this setting
		
@export var sound_volume: float = 0.75: ## Sound volume
	set(value): 
		game_config.set_value("Audio", "sound_volume", value) # Update ConfigFile
		sound_volume = value # Change value
		changed.emit() # Update anything using this setting


@export_category("Display Settings") # Display Settings
@export var fullscreen: bool = false: ## Fullscreen
	set(value):
		game_config.set_value("Display", "fullscreen", value) # Update ConfigFile
		fullscreen = value # Change value
		fullscreen_changed.emit(value) # Apply physical change
		changed.emit() # Update anything using this setting


@export_category("Gameplay Settings") # Gameplay Settings
@export var autosave: bool = true: ## Autosaves the current game every month
	set(value):
		game_config.set_value("Gameplay", "autosave", value) # Update ConfigFile
		autosave = value # Change value
		changed.emit() # Update anything using this setting
		
@export var number_rounding: bool = true: ## Rounds up big numbers
	set(value):
		game_config.set_value("Gameplay", "number_rounding", value) # Update ConfigFile
		number_rounding = value # Change value
		changed.emit() # Update anything using this setting
		
@export var tax_notifications: bool = true: ## Shows a tax notification when it's paid for
	set(value):
		game_config.set_value("Gameplay", "tax_notifications", value) # Update ConfigFile
		tax_notifications = value # Change value
		changed.emit() # Update anything using this setting
		
@export var graph_scaling: bool = true: ## Automatically scales graphs
	set(value):
		game_config.set_value("Gameplay", "graph_scaling", value) # Update ConfigFile
		graph_scaling = value # Change value
		changed.emit() # Update anything using this setting
		
@export var competitor_news: bool = true: ## Shows your competitor's latest products
	set(value):
		game_config.set_value("Gameplay", "competitor_news", value) # Update ConfigFile
		competitor_news = value # Change value
		changed.emit() # Update anything using this setting
		
@export var research_autoscroll: bool= true: ## Autoscrolls your R&D tab to the latest tech
	set(value):
		game_config.set_value("Gameplay", "research_autoscroll", value) # Update ConfigFile
		research_autoscroll = value # Change value
		changed.emit() # Update anything using this setting
		
@export var text_speed: float = 29: ## How fast text scrolls
	set(value):
		game_config.set_value("Gameplay", "text_speed", value) # Update ConfigFile
		text_speed = value # Change value
		changed.emit() # Update anything using this setting


func _ready():
	var err = game_config.load("user://gamesettings.cfg")
	if err != OK:
		push_warning("game_config failed to load for unknown reason, initializing")
		# TODO: Tell user their config's invalid and has been reset
		# TODO: Check if there are alternate reasons for why a file doesn't load
		game_config.save("user://gamesettings.cfg")
		return
	print("game_config loaded")
