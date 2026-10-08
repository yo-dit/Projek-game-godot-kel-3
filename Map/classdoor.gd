extends Node3D

@export var open_angle := 90.0
@export var open_speed := 0.8

@onready var open_sound = $OpenSound
@onready var close_sound = $CloseSound

var is_open := false
var is_moving := false


func interact():
	if is_moving:
		return

	if is_open:
		close_door()
	else:
		open_door()


func open_door():
	is_moving = true
	is_open = true

	# Mainkan suara buka
	open_sound.play()

	var target_rotation = rotation_degrees.y + open_angle

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"rotation_degrees:y",
		target_rotation,
		open_speed
	)

	await tween.finished

	is_moving = false


func close_door():
	is_moving = true
	is_open = false

	# Mainkan suara tutup
	close_sound.play()

	var target_rotation = rotation_degrees.y - open_angle

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"rotation_degrees:y",
		target_rotation,
		open_speed
	)

	await tween.finished

	is_moving = false
