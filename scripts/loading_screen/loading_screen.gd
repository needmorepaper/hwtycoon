extends MarginContainer

@onready var progress_bar = %ProgressBar
var scene_path
var loading = false
var progress: Array = [0.0]

func _ready():
	if (!loading):
		scene_path = Global.current_scene
		ResourceLoader.load_threaded_request(scene_path) # Request load of scene_path
		loading = true

func _process(_delta):
	if (loading):
		# Update progress
		ResourceLoader.load_threaded_get_status(scene_path, progress) 
		
		#Update progress_bar
		progress_bar.value = progress[0]
		
		#Change scene once progress is 100%
		if (progress[0] >= 1.0):
			loading = false
			var scene = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(scene)
