extends Button
@onready var dropdown_menu = %DropdownButtonContainer
@onready var dropdown_opened = false

# TODO: An animation shows when you open the dropdown
func _pressed():
	var cursor_position = get_viewport().get_mouse_position()
	dropdown_menu.set_global_position(cursor_position)
	dropdown_menu.visible = !dropdown_menu.visible
	dropdown_opened = dropdown_menu.visible
	print("Dropdown status: ", dropdown_opened)
	return
