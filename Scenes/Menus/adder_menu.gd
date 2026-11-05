extends BaseMenu

@onready var app_mode_button: AppModeButton = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/AppModeButton
@onready var word_adding_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/WordAddingParent
@onready var kanji_adding_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent

func menu_selected():
	switch_menus(app_mode_button.word_mode)

func switch_menus(word:bool):
	word_adding_parent.visible = word
	kanji_adding_parent.visible = !word

func _on_app_mode_button_mode_changed(word: bool) -> void:
	switch_menus(word)
