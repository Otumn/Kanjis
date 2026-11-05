extends CanvasLayer

enum pop_type{INFO, WARNING, QUESION}

@onready var background: ColorRect = $Background
@onready var info_pop_parent: Control = $InfoPopParent
@onready var info_icon: TextureRect = $InfoPopParent/VBoxContainer/ColorRect/HBoxContainer/InfoIcon
@onready var info_title: Label = $InfoPopParent/VBoxContainer/ColorRect/HBoxContainer/InfoTitle
@onready var label_pop_text: Label = $InfoPopParent/VBoxContainer/MarginContainer/VBoxContainer/Label_PopText
@onready var btn_confirm: Button = $InfoPopParent/VBoxContainer/MarginContainer/VBoxContainer/Btn_Confirm
@onready var yes_no_parent: HBoxContainer = $InfoPopParent/VBoxContainer/MarginContainer/VBoxContainer/YesNoParent
@onready var btn_yes: Button = $InfoPopParent/VBoxContainer/MarginContainer/VBoxContainer/YesNoParent/Btn_YES
@onready var btn_no: Button = $InfoPopParent/VBoxContainer/MarginContainer/VBoxContainer/YesNoParent/Btn_NO

var linked_yes_callable:Callable
var linked_no_callable:Callable

func _ready() -> void:
	background.visible = false
	info_pop_parent.visible = false

func pop_info(type:pop_type, title:String, text:String):
	yes_no_parent.visible = false
	btn_confirm.visible = true
	show_popup_menu()
	
	info_icon.texture = get_texture(type)
	info_title.text = title
	label_pop_text.text = text

func pop_choice(type:pop_type, title:String, text:String, yes:Callable, no:Callable = Callable(), yes_text:String = "YES", no_text:String = "NO"):
	btn_confirm.visible = false
	yes_no_parent.visible = true
	show_popup_menu()
	
	info_icon.texture = get_texture(type)
	info_title.text = title
	label_pop_text.text = text
	btn_yes.text = yes_text
	btn_no.text = no_text
	
	linked_yes_callable = yes
	linked_no_callable = no
	
	btn_yes.connect("button_down", linked_yes_callable)
	btn_yes.connect("button_down", hide_popup_menu)
	btn_no.connect("button_down", linked_no_callable)
	btn_no.connect("button_down", hide_popup_menu)

func get_texture(type:pop_type) -> Texture2D:
	match type:
		pop_type.INFO:
			return load("res://Sprites/Icons/Icon_Info.png")
		pop_type.WARNING:
			return load("res://Sprites/Icons/Icon_Warning.png")
		pop_type.QUESION:
			return load("res://Sprites/Icons/Icon_Question.png")
	return load("res://Sprites/Icons/Icon_Info.png")

func show_popup_menu():
	background.visible = true
	info_pop_parent.visible = true

func hide_popup_menu():
	background.visible = false
	info_pop_parent.visible = false
	
	if !linked_yes_callable.is_null() || !linked_yes_callable == Callable(): 
		btn_yes.disconnect("button_down", linked_yes_callable)
		linked_yes_callable = Callable()
	if !linked_no_callable.is_null() || !linked_no_callable == Callable(): 
		btn_no.disconnect("button_down", linked_no_callable)
		linked_no_callable = Callable()

func _on_btn_confirm_pressed() -> void:
	hide_popup_menu()
