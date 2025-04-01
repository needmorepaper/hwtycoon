class_name SelectHardwareButton extends MarginContainer

var new_hardware: NewHardware

var button_text: String:
	set(value):
		%RichTextLabel.text = value
	get():
		return %RichTextLabel.text

var button_progress: float:
	set(value):
		%ProgressBar.value = value
	get():
		return %ProgressBar.value

var button_texture_normal: Texture2D:
	set(value):
		%TextureButton.texture_normal = value
	get():
		return %TextureButton.texture_normal

var button_texture_hover: Texture2D:
	set(value):
		%TextureButton.texture_hover = value
	get():
		return %TextureButton.texture_hover

func _pressed():
	pass # TODO: Handle button.pressed()
