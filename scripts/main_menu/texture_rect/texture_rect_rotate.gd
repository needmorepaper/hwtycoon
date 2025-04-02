extends TextureRect
## Script designed for the rotating CPU graphic

func _ready():
	pivot_offset = size / 2 # Center point of rotation

func _process(delta):
	var speed = 0.33
	rotation += speed*delta # Rotate
