extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var PlayerCompany = {
		"Cash": 0, ## Money available
		"CEOName": "Steve Jobs", ## Name of CEO
		"CompanyName": "Apple Computer Inc.", ## Company name
		"Popularity": 0
	}
	print("PlayerCompany initialized")

func set_player_stats(key, value):
	PlayerCompany[key] = value
	return

func get_player_stats(key):
	return PlayerCompany[key]

func initialize_player_company():
	return
