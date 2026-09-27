extends Node

@export var main_menu_packed: PackedScene
@export var initial_game_scene_packed: PackedScene
@export var pause_scene_packed: PackedScene
@export var settings_scene_packed: PackedScene
@export var level_array: Array[PackedScene]

var pause_menu: CanvasLayer = null
var main_menu: Control = null
var game_scene: Node2D = null
var settings_menu: CanvasLayer = null
var current_level: Node
var settings_origin: String = ""

signal toggle_hud(to_on: bool)
signal loaded_level(level: Node2D)

func _ready() -> void:
	load_main_menu("game_start")

func load_main_menu(origin: String) -> void:

	if origin == "pause_menu":
		print("Resuming game from pause menu")
		get_tree().paused = false
	
		if pause_menu:
			pause_menu.queue_free()
			pause_menu = null

		if game_scene:
			game_scene.queue_free()
			game_scene = null

	elif origin == "game_start":
		pass
	else:
		print("Unknown origin: ", origin)
	
	main_menu = main_menu_packed.instantiate()
	
	main_menu.new_game_pressed.connect(new_game)
	main_menu.continue_pressed.connect(continue_game)
	main_menu.exit_pressed.connect(exit_game)
	main_menu.settings_pressed.connect(open_settings)

	add_child(main_menu)
	
	call_deferred("hud_toggle_emitter", false)

func new_game(origin: String) -> void:
	if origin == "main_menu":
		get_node("MainMenu").queue_free()
	load_level(initial_game_scene_packed)
	call_deferred("hud_toggle_emitter", true)
	

func hud_toggle_emitter(to_on: bool):
	toggle_hud.emit(to_on)

func exit_game(origin: String) -> void:
	print("Quitting game from: ", origin)
	get_tree().quit()

func open_settings(origin: String) -> void:
	print("Opening settings from: ", origin)

	settings_origin = origin

	settings_menu = settings_scene_packed.instantiate()
	settings_menu.return_pressed.connect(close_settings)

	add_child(settings_menu)
	
func close_settings() -> void:
	if settings_menu:
		settings_menu.queue_free()
		settings_menu = null

	if settings_origin == "pause_menu":
		display_pause_scene()

	elif settings_origin == "main_menu":
		pass

func continue_game(origin: String) -> void:
	pass

func resume_game(origin: String) -> void:
	if origin == "pause_menu":
		print("Resuming game from pause menu")
		get_tree().paused = false
		

		if pause_menu:
			pause_menu.queue_free()
			pause_menu = null

# not sure if working
func display_pause_scene() -> void:
	if pause_menu:
		return

	print("Displaying pause scene")
	pause_menu = pause_scene_packed.instantiate()

	pause_menu.resume_pressed.connect(resume_game)
	pause_menu.settings_pressed.connect(open_settings)
	pause_menu.exit_to_menu_pressed.connect(load_main_menu)

	add_child(pause_menu)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		if get_tree().paused:
			print("game resumed")
			get_tree().paused = false
			pause_menu.queue_free()
			pause_menu = null
		else:	
			print("game paused")
			display_pause_scene()
			get_tree().paused = true 
			
func get_current_level_packed_scene():
	return level_array[Globals.current_level_idx]


func unload_level(level):
	level.queue_free()

func load_level(level_packed_scene):
	game_scene = level_packed_scene.instantiate()
	add_child(game_scene)
	current_level = game_scene
	loaded_level.emit(game_scene)
	
func restart():
	unload_level(current_level)
	call_deferred("load_level", get_current_level_packed_scene())
	
func next_level():
	unload_level(current_level)
	Globals.current_level_idx += 1
	call_deferred("load_level", get_current_level_packed_scene())
