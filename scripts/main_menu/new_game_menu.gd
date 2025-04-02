extends MarginContainer
## Script that handles the New Game menu and its methods

var Difficulty = PlayerCompany.Difficulty

@onready var main_menu: MainMenu = get_tree().current_scene

var company_name: String
var player_first_name: String
var player_last_name: String
var game_difficulty: PlayerCompany.Difficulty

var has_selected_difficulty: bool = false

func update_done_button():
	if ((company_name) and (player_first_name) and (player_last_name) and (has_selected_difficulty)):
		%DoneButton.disabled = false
	else:
		%DoneButton.disabled = true


func _ready():
	update_done_button()


func _on_company_line_edit_text_changed(new_text):
	company_name = new_text
	update_done_button()


func _on_first_name_line_edit_text_changed(new_text):
	player_first_name = new_text
	update_done_button()


func _on_last_name_line_edit_text_changed(new_text):
	player_last_name = new_text
	update_done_button()


# TODO: Logo Creation Menu & Button Hover
func _on_logo_button_pressed():
	push_error("Not implemented")
	update_done_button()


func _on_easy_button_toggled(toggled_on):
	has_selected_difficulty = true
	if (toggled_on):
		game_difficulty = Difficulty.EASY
		update_done_button()


func _on_normal_button_toggled(toggled_on):
	has_selected_difficulty = true
	if (toggled_on):
		game_difficulty = Difficulty.NORMAL
		update_done_button()


func _on_hard_button_toggled(toggled_on):
	has_selected_difficulty = true
	if (toggled_on):
		game_difficulty = Difficulty.HARD
		update_done_button()


func _on_very_hard_button_toggled(toggled_on):
	has_selected_difficulty = true
	if (toggled_on):
		game_difficulty = Difficulty.VERY_HARD
		update_done_button()

## TODO: Create new game settings menu
func _on_game_settings_texture_button_toggled(toggled_on): 
	push_error("Not implemented")
	update_done_button()


func _on_done_button_pressed():
	var player_company = PlayerCompany.new()
	
	player_company.new_company = true
	player_company.company_name = company_name
	player_company.player_first_name = player_first_name
	player_company.player_last_name = player_last_name
	player_company.difficulty = game_difficulty
	
	Global.player_company = player_company
	Global.load_scene("res://scenes/gameplay.tscn")


func _on_back_button_pressed():
	main_menu.active_screen = main_menu.Screen.MAIN_MENU
