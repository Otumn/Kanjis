class_name UIConfig
extends Control

signal config_updated(old_value:Variant, new_value:Variant)

@export_group("Save config")
@export var config_section = "Section"
@export var parameter_name: String = "Parameter"

@onready var param_label: Label = $HBoxContainer/ParamLabel

func _ready() -> void:
	param_label.text = clean_param_name(parameter_name)

func clean_param_name(text:String) -> String:
	var new_text:String = ""
	for c in text:
		if c == "_":
			c = " "
		new_text += c
	new_text[0] = new_text[0].capitalize()
	return new_text

func get_config_value() -> Variant:
	return null

func set_config_value(value: Variant):
	pass
