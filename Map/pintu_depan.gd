extends Node3D

var is_open := false

func interact():
	if is_open:
		return

	is_open = true

	var tween = create_tween()
	tween.tween_property(
		self,
		"rotation_degrees:y",
		rotation_degrees.y + 90,
		1.0
	)
