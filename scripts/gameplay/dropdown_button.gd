class_name DropdownButton extends Button

@onready var gameplay: Gameplay = get_tree().current_scene
var screen: Gameplay.Screen

func _pressed():
	print(screen)
	gameplay.active_screen = screen
