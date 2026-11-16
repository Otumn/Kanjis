class_name BaseExercice
extends Control

signal on_exercice_setup
signal on_exercice_success
signal on_exercice_fail

@export var exercice_name:String = "Exercice"
@export var mastery_value: float = 0.1
@export var fail_value: float = 0.1
enum ExerciceType{WORD_AND_KANJI, WORD_ONLY, KANJI_ONLY}
@export var type : ExerciceType = ExerciceType.WORD_AND_KANJI

var tested_card:ElementData

func setup_exercice():
	on_exercice_setup.emit()

func validate_exercice():
	on_exercice_success.emit()

func fail_exercice():
	on_exercice_fail.emit()
