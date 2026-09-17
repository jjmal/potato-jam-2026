extends Node

@export var main_menu_packed: PackedScene
@export var game_scene_packed: PackedScene
@export var pause_scene_packed: PackedScene

func _ready() -> void:
	load_main_menu("game_start")

func load_main_menu(origin: String) -> void:
	var main_menu: Control = main_menu_packed.instantiate()


	main_menu.new_game_pressed.connect(new_game)
	main_menu.continue_pressed.connect(continue_game)
	main_menu.exit_pressed.connect(exit_game)
	main_menu.settings_pressed.connect(open_settings)

	add_child(main_menu)

func new_game(origin: String) -> void:
	if origin == "main_menu":
		get_node("MainMenu").queue_free()
	var game_scene: Node2D = game_scene_packed.instantiate()
	add_child(game_scene)

func exit_game(origin: String) -> void:
	print("Quitting game from: ", origin)
	get_tree().quit()

func open_settings(origin: String) -> void:
	pass

func continue_game(origin: String) -> void:
	pass

func resume_game(origin: String) -> void:
	pass

# not sure if working
func display_pause_scene() -> void:
	print("Displaying pause scene")
	var pause_menu: Control = pause_scene_packed.instantiate()

	pause_menu.resume_pressed.connect(resume_game)
	pause_menu.settings_pressed.connect(open_settings)
	pause_menu.exit_to_menu_pressed.connect(load_main_menu)

	add_child(pause_menu)

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause_game"):
		print("game paused")
		display_pause_scene()
		get_tree().paused = true 
