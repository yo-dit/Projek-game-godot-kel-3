extends Control

@onready var panel = $Panel

@onready var resume_button = $Panel/ResumeButton
@onready var main_menu_button = $Panel/MainMenuButton

@onready var bgm_slider = $BGMSlider
@onready var sfx_slider = $SFXSlider

@onready var bg_ambience = $BgAmbience
@onready var normal_click_sfx = $NormalClickSFX


func _ready():
	# Pause Menu tetap aktif walaupun game di-pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Sembunyikan panel saat game mulai
	panel.hide()

	# Connect tombol
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Connect slider
	bgm_slider.value_changed.connect(_on_bgm_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)


func _input(event):
	# Tekan ESC untuk membuka/menutup Pause Menu
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	if get_tree().paused:
		# Unpause
		get_tree().paused = false
		panel.hide()
	else:
		# Pause
		get_tree().paused = true
		panel.show()


func _on_resume_pressed():
	# SFX tombol
	normal_click_sfx.play()

	# Lanjutkan game
	get_tree().paused = false
	panel.hide()


func _on_main_menu_pressed():
	# SFX tombol
	normal_click_sfx.play()

	# Unpause sebelum pindah scene
	get_tree().paused = false

	# Kembali ke Main Menu
	get_tree().change_scene_to_file("res://UImain_menu/main menu.tscn")


func _on_bgm_changed(value):
	var bus_index = AudioServer.get_bus_index("BGM")

	if bus_index != -1:
		if value == 0:
			AudioServer.set_bus_volume_db(bus_index, -80)
		else:
			AudioServer.set_bus_volume_db(
				bus_index,
				linear_to_db(value / 100.0)
			)


func _on_sfx_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")

	if bus_index != -1:
		if value == 0:
			AudioServer.set_bus_volume_db(bus_index, -80)
		else:
			AudioServer.set_bus_volume_db(
				bus_index,
				linear_to_db(value / 100.0)
			)
