extends Node3D

var is_open := false

@onready var right_door = $RightDoorPivot
@onready var left_door = $LeftDoorPivot


func interact():
	print("PINTU DIINTERAKSI!")

	if is_open:
		return

	is_open = true

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		right_door,
		"rotation_degrees:y",
		90.0,
		1.0
	)

	tween.tween_property(
		left_door,
		"rotation_degrees:y",
		-90.0,
		1.0
	)
