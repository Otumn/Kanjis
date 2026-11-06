extends BaseMenu

@export var list_item:PackedScene

@onready var list_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/ScrollContainer/ListParent
@onready var focus_parent: Control = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent

@onready var word_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/WordParent
@onready var kanji_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/KanjiParent

@onready var label_title: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/ColorRect/Label_Title
@onready var label_type: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/Label_Type
@onready var label_kanas: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/WordParent/Label_Kanas
@onready var label_kunyomi: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/KanjiParent/Label_Kunyomi
@onready var label_onyomi: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/KanjiParent/Label_Onyomi
@onready var label_translation: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/Label_Translation
@onready var label_rights: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label_Rights
@onready var label_wrongs: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label_Wrongs
@onready var label_date: Label = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/Label_Date
@onready var bar_mastery: ProgressBar = $VBoxContainer/Container/ScrollContainer/MarginContainer/FocusParent/ColorRect/FocusFrame/VBoxContainer/MarginContainer/VBoxContainer/Bar_Mastery

var focused_element:ElementData

func _ready() -> void:
	SaveLogic.connect("on_data_loaded", on_data_loaded)
	SaveLogic.connect("on_new_element_added", on_element_added)
	
	super._ready()

func on_data_loaded():
	create_list()

func on_element_added(element:ElementData):
	add_element(element)

func create_list():
	print("Creating list...")
	if list_parent.get_child_count() > 0:
		for c in list_parent.get_children():
			c.queue_free()
	for e in SaveLogic.data.elements:
		add_element(e)

func add_element(element:ElementData):
	var card = list_item.instantiate() as CardListItem
	list_parent.add_child(card)
	card.link_element(element)
	card.on_card_selected.connect(focus_element)

func focus_element(element:ElementData):
	focused_element = element
	label_title.text = element.base_writing
	if element.is_word:
		label_type.text = "Word card"
		word_parent.visible = true
		kanji_parent.visible = false
		label_kanas.text = "Kanas : " + element.kanas
	else:
		label_type.text = "Kanji card"
		word_parent.visible = false
		kanji_parent.visible = true
		label_kunyomi.text = "Kunyomi : " + element.get_full_kunyomi()
		label_onyomi.text = "Onyomi : " + element.get_full_onyomi()
	label_translation.text = "Translation : " + element.translation
	label_rights.text = "Corrects : " + str(element.corrects)
	label_wrongs.text = "Wrongs : " + str(element.wrongs)
	label_date.text = "Last seen on : " + str(element.last_seen_day) + "/" + str(element.last_seen_month) + "/" + str(element.last_seen_year)
	bar_mastery.value = element.mastery
	focus_parent.visible = true

func defocus():
	focus_parent.visible = false

func request_element_deletion(): #no need for arguments, just delete the element we are focused on
	PopupLogic.pop_choice(PopupLogic.pop_type.WARNING, "Delete", "You are about to delete this card permanently, are you sure?", delete_element)

func delete_element():
	SaveLogic.delete_element(focused_element.id)
	create_list()
	defocus()

func _on_btn_go_back_button_down() -> void:
	defocus()

func _on_btn_delete_button_down() -> void:
	request_element_deletion()
