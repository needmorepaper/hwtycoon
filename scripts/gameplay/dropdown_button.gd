class_name DropdownButton extends Button

@onready var gameplay: Gameplay = get_tree().current_scene
var screen: Classes.Screen

func _pressed():
	gameplay.active_screen = screen
