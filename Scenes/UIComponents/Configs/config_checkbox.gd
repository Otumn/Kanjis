class_name ConfigCheckbox
extends UIConfig

@export var checked: bool = false
@export var button_group:ButtonGroup

@onready var check_box: CheckBox = $HBoxContainer/SettingEdit/CheckBox

var current_value:bool

func _ready() -> void:
	super._ready()
	check_box.button_group = button_group
	check_box.button_pressed = checked

func _on_check_box_toggled(toggled_on: bool) -> void:
	var old = current_value
	current_value = toggled_on
	config_updated.emit(old, current_value)

#region VALUE GETTER/SETTER
func get_config_value() -> Variant:
	return current_value

func set_config_value(value: Variant):
	check_box.button_pressed = value
#endregion
