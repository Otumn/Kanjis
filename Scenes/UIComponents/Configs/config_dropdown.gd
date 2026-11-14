class_name ConfigDropdown
extends UIConfig

@export var options: Array[String] = []

@onready var option_button: OptionButton = $HBoxContainer/SettingEdit/OptionButton

var current_option: String = ""

func _ready() -> void:
	param_label.text = clean_param_name(parameter_name)
	update_options(options)

func update_options(opts:Array[String]):
	for o in opts:
		option_button.add_item(o)
	current_option = opts[0]

func _on_option_button_item_selected(index: int) -> void:
	var old = current_option
	current_option = option_button.get_item_text(index)
	config_updated.emit(old, current_option)

#region VALUE GETTER/SETTER
func get_config_value() -> Variant:
	return current_option

func set_config_value(value: Variant):
	_on_option_button_item_selected(options.find(value))
#endregion
