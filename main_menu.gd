extends Control

@onready var start_button = $MenuOptions/StartButton
@onready var option_button = $MenuOptions/OptionButton
@onready var credit_button = $MenuOptions/CreditButton
@onready var quit_button = $MenuOptions/QuitButton

@onready var credit_menu = $CreditMenu
@onready var option_menu = $OptionMenu

@onready var animation_player = $AnimationPlayer
@onready var quit_confirmation = $QuitConfirmation


func _ready():
	credit_menu.hide()
	option_menu.hide()

	# Hubungkan tombol
	start_button.pressed.connect(_on_start_pressed)
	option_button.pressed.connect(_on_option_pressed)
	credit_button.pressed.connect(_on_credit_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Hubungkan konfirmasi Quit
	quit_confirmation.confirmed.connect(_on_quit_confirmed)

	# Atur teks dialog
	quit_confirmation.dialog_text = "Are you sure you want to quit?"
	quit_confirmation.ok_button_text = "Yes"
	quit_confirmation.cancel_button_text = "No"


func _on_start_pressed():
	print("Start ditekan")

	get_tree().change_scene_to_file("res://node.tscn")


func _on_option_pressed():
	print("Option ditekan")

	# Kalau Credits sedang terbuka
	if credit_menu.visible:
		animation_player.play("popup_close")
		await animation_player.animation_finished
		credit_menu.hide()

	# Kalau Options sedang terbuka → tutup
	if option_menu.visible:
		animation_player.play("popup_close")
		await animation_player.animation_finished
		option_menu.hide()
	else:
		# Kalau belum terbuka → buka
		option_menu.show()
		animation_player.play("popup_open")


func _on_credit_pressed():
	print("Credit ditekan")

	# Kalau Options sedang terbuka
	if option_menu.visible:
		animation_player.play("popup_close")
		await animation_player.animation_finished
		option_menu.hide()

	# Kalau Credits sedang terbuka → tutup
	if credit_menu.visible:
		animation_player.play("popup_close")
		await animation_player.animation_finished
		credit_menu.hide()
	else:
		# Kalau belum terbuka → buka
		credit_menu.show()
		animation_player.play("popup_open")


func _on_quit_pressed():
	print("Quit ditekan")

	# Tampilkan konfirmasi
	quit_confirmation.popup_centered()


func _on_quit_confirmed():
	print("Quit dikonfirmasi")

	# Keluar dari game
	get_tree().quit()
