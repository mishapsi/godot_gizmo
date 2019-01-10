extends Spatial

export var scaling = 200
var selected_object = null

func _process(delta):
	var size = get_viewport().get_camera().size / scaling
	scale = Vector3(size, size, size)