class_name BaseMenu
extends Control

signal selected()
signal deselected()

@export_group("Menu")
@export var title: String = "Base menu"
@export var title_back_color: Color = Color.DARK_SLATE_GRAY
@export var background_color: Color = Color.SLATE_GRAY

@onready var title_back_color_rect: ColorRect = $VBoxContainer/TitleBackColor
@onready var background_color_rect: ColorRect = $VBoxContainer/Container/BackgroundColor

@onready var title_label: Label = $VBoxContainer/TitleBackColor/MarginContainer/TitleLabel


func _ready() -> void:
	setup_menu()

func setup_menu():
	title_label.text = title
	title_back_color_rect.color = title_back_color
	background_color_rect.color = background_color

func _on_draw() -> void:
	selected.emit()
	menu_selected()

func _on_hidden() -> void:
	deselected.emit()
	menu_deselected()

func menu_selected():
	pass #meant to be used by children classes

func menu_deselected():
	pass #meant to be used by children classes
