extends Control

@onready var panel = $Panel

@onready var resume_button = $Panel/ResumeButton
@onready var main_menu_button = $Panel/MainMenuButton

@onready var bgm_slider = $Panel/BGMSlider
@onready var sfx_slider = $Panel/SFXSlider

@onready var bg_ambience = $BgAmbience
@onready var normal_click_sfx = $NormalClickSFX


func _ready():
	print("PAUSE MENU SCRIPT JALAN")

	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.hide()

	print("BGM SLIDER = ", bgm_slider)
	print("SFX SLIDER = ", sfx_slider)

	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	bgm_slider.value_changed.connect(_on_bgm_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)


func _input(event):
	# Tekan ESC untuk membuka/menutup Pause Menu
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		panel.hide()

		await get_tree().process_frame
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	else:
		get_tree().paused = true
		panel.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume_pressed():
	normal_click_sfx.play()

	get_tree().paused = false
	panel.hide()

	await get_tree().process_frame
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_main_menu_pressed():
	# SFX tombol
	normal_click_sfx.play()

	# Unpause sebelum pindah scene
	get_tree().paused = false

	# Kembali ke Main Menu
	get_tree().change_scene_to_file("res://Ui/UImain_menu/main menu.tscn")


func _on_bgm_changed(value):
	print("========== BGM ==========")
	print("Slider Value: ", value)

	var bus_index = AudioServer.get_bus_index("BGM")
	print("Bus Index: ", bus_index)

	if bus_index == -1:
		print("BGM BUS TIDAK DITEMUKAN!")
		return

	var volume_db: float

	if value <= 0:
		volume_db = -80.0
	else:
		volume_db = linear_to_db(value / 100.0)

	AudioServer.set_bus_volume_db(bus_index, volume_db)

	print("Volume DB: ", volume_db)
	print("Volume DB BUS SEKARANG: ", AudioServer.get_bus_volume_db(bus_index))

func _on_sfx_changed(value):
	print("SFX SLIDER: ", value)

	var bus_index = AudioServer.get_bus_index("SFX")
	print("SFX BUS INDEX: ", bus_index)

	if bus_index != -1:
		var volume_db = -80.0

		if value > 0:
			volume_db = linear_to_db(value / 100.0)

		AudioServer.set_bus_volume_db(bus_index, volume_db)

		print("SFX VOLUME DB: ", AudioServer.get_bus_volume_db(bus_index))
