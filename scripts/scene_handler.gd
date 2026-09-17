extends Node

@export var main_menu_packed: PackedScene
@export var game_scene_packed: PackedScene
@export var pause_scene_packed: PackedScene


var pause_menu: Control = null
var main_menu: Control = null
var game_scene: Node2D = null

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

func new_game(origin: String) -> void:
	if origin == "main_menu":
		get_node("MainMenu").queue_free()
	game_scene = game_scene_packed.instantiate()
	add_child(game_scene)

func exit_game(origin: String) -> void:
	print("Quitting game from: ", origin)
	get_tree().quit()

func open_settings(origin: String) -> void:
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
