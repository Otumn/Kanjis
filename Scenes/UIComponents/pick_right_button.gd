class_name PickRightButton
extends Control

signal on_answer_chosen(index:int)

@onready var label_main_info: Label = $Btn_Answer/MarginContainer/VBoxContainer/Label_MainInfo
@onready var label_secondary_info: Label = $Btn_Answer/MarginContainer/VBoxContainer/Label_SecondaryInfo

var displayed_card:int

func display_card(index:int):
	displayed_card = index
	var card:ElementData = SaveLogic.data.elements[index]
	label_main_info.text = card.base_writing
	label_secondary_info.visible = card.mastery < 1
	if card.is_word:
		label_secondary_info.text = card.kanas
	else:
		label_secondary_info.text = card.get_full_kunyomi() + "\n" + card.get_full_onyomi()

func clear_button():
	label_main_info.text = ""
	label_secondary_info.text = ""

func _on_btn_answer_button_down() -> void:
	on_answer_chosen.emit(displayed_card)
