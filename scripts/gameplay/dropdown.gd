extends MarginContainer

@onready var gameplay: Gameplay = get_tree().current_scene
@onready var dropdown_button = preload("res://scenes/gameplay/dropdown_button.tscn")

class Screen: ## A class to describe all dropdown-able screens
	var button_text: String
	var unlocked: bool
	var screen: Gameplay.Screen
	
	func _init(_button_text: String = "Unnamed Button", _unlocked: bool = false, _screen: Gameplay.Screen = Gameplay.Screen.OFFICE):
		button_text = _button_text
		unlocked = _unlocked
		screen = _screen

## Array of Screens the dropdown can display
var Screens: Array[Screen] = [Screen.new("Locked Button", false),Screen.new("Unlocked Button", true, Gameplay.Screen.PAUSE_MENU),Screen.new("Unlocked Button 2", true),Screen.new("Unlocked Button 3", true),Screen.new("Unlocked Button 4", true)]

func update_dropdown_list(): ## Updates the dropdown list
	for child in %DropdownBoxContainer.get_children():
		%DropdownBoxContainer.remove_child(child)
	for screen in Screens:
		if (screen.unlocked):
			var button: DropdownButton = dropdown_button.instantiate()
			button.text = screen.button_text
			button.screen = screen.screen
			%DropdownBoxContainer.add_child(button)

func show_dropdown():
	update_dropdown_list()
	self.visible = true
