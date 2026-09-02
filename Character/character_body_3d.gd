extends CharacterBody3D

@export var walk_speed := 3.0
@export var sprint_speed := 5.0
@export var jump_velocity := 3.0
@export var mouse_sensitivity := 0.002

@onready var head = $head
@onready var animation_player = $Muryotaisu/AnimationPlayer


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		head.rotate_x(event.relative.y * mouse_sensitivity)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity += get_gravity() * delta

	# JUMP - SPACE
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# WASD
	var input_dir := Input.get_vector(
		"left",
		"right",
		"forward",
		"backward"
	)

	var direction := (
	transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)
	).normalized()

	# SPEED
	var speed := walk_speed

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed

	# MOVEMENT
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 8 * delta)
		velocity.z = move_toward(velocity.z, 0, speed * 8 * delta)

	move_and_slide()

	# UPDATE ANIMATION
	update_animation()


# =====================================
# ANIMATION
# =====================================

func update_animation():
	if not is_on_floor():
		animation_player.play("Armature|Jump")
		return

	var horizontal_velocity := Vector2(velocity.x, velocity.z)

	if horizontal_velocity.length() > 0.1:
		animation_player.play("Armature|Walk")
	else:
		animation_player.play("Armature|FaceIdle")
