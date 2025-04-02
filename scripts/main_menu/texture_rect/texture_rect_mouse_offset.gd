extends TextureRect
## Script designed for the main menu's room graphic
## TODO: On some resolution and window size variants, the room goes too high and leaves a gap at the bottom.

var original_pos = position

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position() - Vector2(get_viewport().size / 2) # Get mouse position as an offset from the center of the viewport
	var movement_offset = mouse_pos / 50.0 # Change number to control sensitivity
		
	position = original_pos + movement_offset # Offset
