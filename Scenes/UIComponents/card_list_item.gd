class_name CardListItem
extends Control

signal on_card_selected(element:ElementData)

@onready var label_index: Label = $Btn_Main/MarginContainer/HBoxContainer/Control/MarginContainer/Label_Index
@onready var label_japanese: Label = $Btn_Main/MarginContainer/HBoxContainer/Control/Label_Japanese
@onready var label_translation: Label = $Btn_Main/MarginContainer/HBoxContainer/Label_Translation
@onready var bar_mastery: ProgressBar = $Btn_Main/MarginContainer/HBoxContainer/Bar_Mastery

var linked_element:ElementData

func link_element(element:ElementData):
	label_index.text = str(element.id)
	label_japanese.text = element.base_writing
	label_translation.text = element.translation
	bar_mastery.value = element.mastery
	linked_element = element

func _on_btn_main_button_down() -> void:
	on_card_selected.emit(linked_element)
