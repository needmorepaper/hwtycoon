class_name SelectArchitectureButton extends MarginContainer

var new_hardware: NewHardware

var architecture: Classes.Architecture

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

func _ready():
	%TextureButton.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	new_hardware.selected_architecture = architecture
	new_hardware.active_screen = new_hardware.Screens.DESIGN
