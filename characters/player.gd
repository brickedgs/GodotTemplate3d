extends CharacterBody3D

@onready var spring_arm_pivot = $SpringArmPivot
@onready var camera = $SpringArmPivot/SpringArm3D/Camera3D

const SPRINT_SPEED = 5.0
const WALK_SPEED = 3.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _physics_process(delta):
	if delta == 0:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	var direction = (
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)

	var sprinting = Input.is_action_pressed("sprint")

	var speed = WALK_SPEED

	if direction:
		if sprinting:
			speed = SPRINT_SPEED

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	camera.toggle_sprint_mode(speed == SPRINT_SPEED)
