extends Node3D

@export_range(0, 100) var mouse_sensitivity_x = 10
@export_range(0, 100) var mouse_sensitivity_y = 10
@export_range(0, 100) var joy_sensitivity_x = 10
@export_range(0, 100) var joy_sensitivity_y = 20

var parent: Node3D

func _ready():
	parent = get_parent()

	if parent == null:
		set_process(false)

func _unhandled_input(event):
	if parent == null:
		return

	if event is InputEventMouseMotion:
		parent.rotate_y(
			deg_to_rad(mouse_sensitivity_x * -event.relative.x * 0.01)
		)

		rotate_x(
			deg_to_rad(mouse_sensitivity_y * -event.relative.y * 0.01)
		)
		rotation.x = clamp(rotation.x, -PI / 4, PI / 4)

func _process(delta):
	if parent == null:
		return

	var joy_x = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	var joy_y = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")

	if joy_y != 0:
		parent.rotate_y(deg_to_rad(joy_sensitivity_y * joy_y * 10 * delta))

	if joy_x != 0:
		rotate_x(deg_to_rad(joy_sensitivity_x * joy_x * 10 * delta))
		rotation.x = clamp(rotation.x, -PI / 4, PI / 4)
