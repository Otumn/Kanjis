class_name BaseExercice
extends Control

@export var exercice_name:String = "Exercice"
@export var mastery_value: float = 0.1
@export var fail_value: float = 0.1
@export var word_exercice:bool = true

var tested_card:ElementData

func setup_exercice():
	pass

func validate_exercice():
	pass

func fail_exercice():
	pass
