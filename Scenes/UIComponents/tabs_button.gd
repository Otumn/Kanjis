class_name TabsButton
extends Button

signal index_selected(index:int)

@export var target_index: int = 0
@export var new_icon: Texture2D

var selected: bool = false

func _ready() -> void:
	icon = new_icon

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if selected: return
		index_selected.emit(target_index)
	selected = toggled_on
