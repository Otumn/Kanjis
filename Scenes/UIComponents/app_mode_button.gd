class_name AppModeButton
extends Control

signal mode_changed(word:bool)

var word_mode:bool = true

func _on_btn_word_mode_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if word_mode:return
		word_mode = true
		mode_changed.emit(word_mode)

func _on_btn_kanji_mode_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if !word_mode:return
		word_mode = false
		mode_changed.emit(word_mode)
