extends CharacterBody3D

@export var speed := 1.5
@export var chase_distance := 15.0
@export var attack_distance := 2.0

@onready var player = $"../CharacterBody3D"
@onready var animation_player = $MonsterPSX/AnimationPlayer
@onready var attack_ray = $AttackRay

var can_attack := true
var is_attacking := false


func _ready():
	print("POCONG HIDUP!")

	if player == null:
		print("PLAYER MASIH TIDAK DITEMUKAN!")
	else:
		print("PLAYER DITEMUKAN: ", player.name)

	play_animation("MonsterPSX_Rig|Idle_Watchful")


func _physics_process(delta):
	if player == null:
		return

	# =========================================
	# SEDANG MENYERANG
	# =========================================

	if is_attacking:
		velocity = Vector3.ZERO
		move_and_slide()
		return


	# =========================================
	# HITUNG JARAK
	# =========================================

	var distance = global_position.distance_to(
		player.global_position
	)


	# =========================================
	# PLAYER TERLALU JAUH
	# =========================================

	if distance > chase_distance:
		velocity = Vector3.ZERO
		play_animation("MonsterPSX_Rig|Idle_Watchful")
		move_and_slide()
		return


	# =========================================
	# PLAYER SUDAH DEKAT
	# =========================================

	if distance <= attack_distance:

		velocity = Vector3.ZERO

		# Arah dari Pocong ke Player
		var to_player = player.global_position - global_position
		to_player.y = 0

		if to_player.length() > 0:
			to_player = to_player.normalized()

			# Cek apakah Player ada di DEPAN Pocong
			var forward = -global_transform.basis.z
			forward.y = 0
			forward = forward.normalized()

			var dot = forward.dot(to_player)

			# 0.5 = kira-kira sudut 60 derajat
			if dot > 0.5 and can_attack:

				# Arahkan RayCast langsung ke Player
				attack_ray.target_position = attack_ray.to_local(
					player.global_position
				)

				# Paksa RayCast update sekarang
				attack_ray.force_raycast_update()

				if attack_ray.is_colliding():

					var target = attack_ray.get_collider()

					# Kalau Ray mengenai Player
					if target == player or player.is_ancestor_of(target):
						attack()

					else:
						print("ATTACK TERHALANG: ", target.name)

				else:
					print("RAY TIDAK MENGENAI PLAYER")

		move_and_slide()
		return


	# =========================================
	# KEJAR PLAYER
	# =========================================

	var direction = global_position.direction_to(
		player.global_position
	)

	# Jangan naik / turun
	direction.y = 0

	if direction.length() > 0:
		direction = direction.normalized()

		# Hadap Player
		look_at(
			global_position + direction,
			Vector3.UP
		)

	# Gerak
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	play_animation("MonsterPSX_Rig|Walk_Nervous")

	move_and_slide()


# =========================================
# ATTACK
# =========================================

func attack():

	if not can_attack:
		return

	can_attack = false
	is_attacking = true

	velocity = Vector3.ZERO

	# Hadap Player
	var direction = global_position.direction_to(
		player.global_position
	)

	direction.y = 0

	if direction.length() > 0:
		look_at(
			global_position + direction,
			Vector3.UP
		)

	play_animation("MonsterPSX_Rig|Attack_Lunge")

	print("POCONG MENYERANG!")


	# Tunggu animasi sampai selesai
	await animation_player.animation_finished

	print("ATTACK SELESAI!")

	is_attacking = false
	can_attack = true

	print("POCONG SIAP MENYERANG LAGI!")


# =========================================
# ANIMATION
# =========================================

func play_animation(animation_name: String):

	if animation_player.current_animation != animation_name:

		if animation_player.has_animation(animation_name):
			animation_player.play(animation_name)
