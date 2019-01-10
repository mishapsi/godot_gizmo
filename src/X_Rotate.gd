extends MeshInstance

var original_transform = null
var parent_center = Vector2(0,0)
var drag_start_position = Vector2(0,0)
var dragged = false

func _process(delta):
	if(dragged && !Input.is_mouse_button_pressed(BUTTON_LEFT)):
		dragged = false
		material_override.albedo_color.a8 = 125
	if(dragged):
		material_override.albedo_color.a8 = 200
		var mp = get_viewport().get_mouse_position()
		var start = parent_center.angle_to_point(drag_start_position)
		var angle = parent_center.angle_to_point(mp)
		var direction = (get_viewport().get_camera().global_transform.origin - get_parent().get_parent().global_transform.origin)
		direction = direction.normalized()
		var face = get_parent().get_parent().global_transform.basis.x
		get_parent().get_parent().global_transform = original_transform
		if(rad2deg(face.dot(direction)) > 0):
			get_parent().get_parent().rotate_object_local(Vector3(1,0,0), start - angle)
		else:
			get_parent().get_parent().rotate_object_local(Vector3(1,0,0), angle - start)


func _input_event(camera, ev, click_position, click_normal, shape_idx):
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_LEFT && ev.pressed):
		dragged = true
		original_transform = get_parent().get_parent().global_transform
		parent_center = camera.unproject_position(get_parent().get_parent().global_transform.origin)
		drag_start_position = camera.unproject_position(click_position)