extends ViewportContainer

var rotating = false
var panning = false
var drag_start = false
var drag_end = false
var selected_object = null
var rotating_object = false
var dragging = false
onready var camera = $Viewport/Camera

func select(ev):
	var mouse_pos = get_node("Viewport").get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var from = ray_origin
	var to = ray_origin + ray_direction * 1000000.0
	var state = camera.get_world().direct_space_state
	var hit = state.intersect_ray(from,to)
	if(!hit.empty() && hit.collider.is_in_group("gizmo")):
		print(hit.collider.get_parent().name)
		hit.collider.get_parent()._input_event(camera, ev, hit.position, null, null)
		dragging = true
	elif(!hit.empty()):
		print(hit.collider.get_parent().name)
	else:
		print("miss")
		selected_object = null

func zoom(delta):
	camera.size += delta

func pan(ev):
	var t = camera.transform.orthonormalized()
	t = t.translated(Vector3(1,0,0) * -ev.relative.x * .05)
	t = t.translated(Vector3(0,1,0) * ev.relative.y * .05)
	camera.transform = t

func rotate(ev):
	var cam_c = camera
	var y = cam_c.transform.basis.y.y
	var trans = cam_c.translation
	if(abs(ev.relative.y) > abs(ev.relative.x)):
		var t = cam_c.global_transform.orthonormalized()
		t = t.rotated(-t.basis.x,-ev.relative.y * .005)
		cam_c.global_transform = t
	else:
		var t = cam_c.transform.orthonormalized()
		t = t.rotated(-Vector3(0,1,0),ev.relative.x * .005)
		cam_c.transform = t
#

func gui_input(ev):
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_WHEEL_UP):
		zoom(-1)
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_WHEEL_DOWN):
		zoom(1)
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_RIGHT && ev.pressed):
		rotating = true
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_RIGHT && !ev.pressed):
		rotating = false
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_MIDDLE && ev.pressed):
		panning = true
	if(ev is InputEventMouseButton && ev.button_index == BUTTON_MIDDLE && !ev.pressed):
		panning = false
	if(ev is InputEventMouseMotion && rotating && !ev.is_echo()):
			rotate(ev)
	if(ev is InputEventMouseMotion && panning && !ev.is_echo()):
		pan(ev)
	if(ev is InputEventMouseButton && ev.button_index == 1 && ev.pressed && !ev.is_echo() && !dragging):
		select(ev)
	if(ev is InputEventMouseButton && ev.button_index == 1 && !ev.pressed && !ev.is_echo() && dragging):
		dragging = false
