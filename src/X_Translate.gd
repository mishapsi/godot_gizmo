extends MeshInstance

var dragged = false
var start_ray = "test"
var drag_start_position = Vector2(0,0)
var original_transform = null

func _process(delta):
	if(dragged && !Input.is_mouse_button_pressed(BUTTON_LEFT)):
		dragged = false
	if(dragged):
		var cam = get_viewport().get_camera()
		var mp = get_viewport().get_mouse_position()
		var dd = cam.unproject_position(global_transform.origin) - cam.unproject_position(get_parent().get_parent().global_transform.origin)
		get_parent().get_parent().global_transform = original_transform
		var step = dd.normalized()
		var dis = mp - drag_start_position
		var output = step * dis
		var diff  = Vector3(output.x + output.y,0, 0)/15
		get_parent().get_parent().translate_object_local(diff)


func _input_event(camera, ev, click_position, click_normal, shape_idx):
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_LEFT && ev.pressed):
		dragged = true
		start_ray = camera.project_position(get_viewport().get_mouse_position())
		drag_start_position = camera.unproject_position(click_position)
		original_transform = get_parent().get_parent().global_transform