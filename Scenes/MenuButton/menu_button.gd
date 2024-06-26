class_name MyMenuButton extends Button

# MARK: Signals
signal menu_button_pressed(id: int)
# MARK: enums & constants

# MARK: Exports

# MARK: Public vars

# MARK: Private vars
var _button_id: int

# MARK: Onready vars
@onready var label = $Label

# MARK: Basic lifecycle

func _init():
	pass

func _enter_tree():
	pass

func _ready():
	pass

# MARK: Built-in methods

func _input(event):
	pass

# MARK: Public methods
func set_button_viewmodel(data: ButtonViewModel):
	_button_id = data.id
	label.text = data.text

# MARK: Private methods
func _on_pressed():
	menu_button_pressed.emit(_button_id)

# MARK: Internal classes

class ButtonViewModel:
	var id: int
	var text: String




