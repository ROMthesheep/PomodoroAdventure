extends Control

const BACKDROP = preload("res://Scenes/Backdrops/backdrop.tscn")
const MENUBUTTON = preload("res://Scenes/MenuButton/menu_button.tscn")
@onready var timer = $Timer
@onready var timer_label = $TimeMarginContainer/TimerLabel
@onready var menu_container = $MainMenuMarginContainer/MarginContainer/MenuContainer

var current_menu: int = 0

var _menu_data: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_menu_Data(0)
	_place_game_in_main_screen()
	_place_backdrop(BACKDROP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_label()

# Private Methods

func _get_screens() -> Array:
	var number_of_screens = DisplayServer.get_screen_count()
	var main_screen = DisplayServer.get_primary_screen()
	var screens = []
	for screen_index in range(number_of_screens):
		screens.append({ 
			"height": DisplayServer.screen_get_size(screen_index).y,
			"width": DisplayServer.screen_get_size(screen_index).x,
			"is_main": screen_index == main_screen -1
		})
	return screens

func _place_game_in_main_screen():
	get_window().position.x = 0
	get_window().position.y = 0
	
	#for screen in  _get_screens():
		#if screen.is_main:
			#get_window().position.x += screen.width - DisplayServer.window_get_size().x
			##get_window().position.x += screen.width
			#break
		#get_window().position.x += screen.width
	get_window().position.x += 1920*2
	DisplayServer.window_set_size(Vector2(460, DisplayServer.screen_get_usable_rect(0).size.y))
	#print(get_window().position)
	
func _place_backdrop(scene: PackedScene):
	var newBackdrop = scene.instantiate()
	add_child(newBackdrop)
	move_child(newBackdrop,0)

func _update_label():
	var seconds = int(timer.time_left)
	timer_label.text = "%02d:%02d" % [seconds / 60, seconds % 60]

func _on_timer_timeout():
	pass # Replace with function body.

func _on_menu_button_pressed(id: int):
	print("button with id:%d pressed" % id)
	match  id:
		1:
			_create_menu("2")
		2:
			_create_menu("1")
		3:
			get_tree().quit()
		11:
			pass # desactivar musica
		12:
			_create_menu("0")

func _load_menu_Data(menu_id: int):
	var file = FileAccess.open("res://Data/menus.json", FileAccess.READ)
	if file == null:
		print("Error al abrir el archivo")
		return
	var json_string = file.get_as_text()
	file.close()
	_menu_data = JSON.parse_string(json_string)
	_create_menu(str(menu_id))
	
func _create_menu(menu_id: String):
	_clear_menu()
	for button_key in _menu_data[menu_id]:
		match _menu_data[menu_id][button_key]["Tipo"]:
			"Boton":
				var new_button = MENUBUTTON.instantiate()
				var button_data = MyMenuButton.ButtonViewModel.new()
				button_data.id =  menu_id + button_key
				button_data.text = _menu_data[menu_id][button_key]["Texto"]
				new_button.menu_button_pressed.connect(_on_menu_button_pressed)
				menu_container.add_child(new_button)
				new_button.set_button_viewmodel(button_data)
			"Separador":
				var spacer = Control.new()
				menu_container.add_child(spacer)
				spacer.size_flags_vertical = Control.SIZE_EXPAND
				spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func _clear_menu():
	for child in menu_container.get_children():
				child.queue_free()
