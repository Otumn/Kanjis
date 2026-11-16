extends BaseMenu

@onready var exercices_parent: Control = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/ExercicesParent

var exercices : Array[BaseExercice]
var current_exercice : BaseExercice

func _ready() -> void:
	for c in exercices_parent.get_children():
		c = c as BaseExercice
		exercices.append(c)
		c.visible = false
	super._ready()

func menu_selected():
	display_new_exercice(SaveLogic.data.get_new_card())

func menu_deselected():
	disconnect_exo()

func display_new_exercice(card: ElementData):
	var excluded_exercices: Array[String] = SaveLogic.data.exercice_memory
	var possible_exercices: Array[BaseExercice] = []
	for e in exercices:
		if !excluded_exercices.has(e.exercice_name):
			possible_exercices.append(e)
	
	current_exercice = possible_exercices.pick_random()
	
	current_exercice.tested_card = card
	current_exercice.on_exercice_success.connect(_on_exo_success)
	current_exercice.on_exercice_fail.connect(_on_exo_failure)
	current_exercice.setup_exercice()
	current_exercice.visible = true

func _on_exo_success():
	disconnect_exo()
	display_new_exercice(SaveLogic.data.get_new_card())

func _on_exo_failure():
	disconnect_exo()
	display_new_exercice(SaveLogic.data.get_new_card())

func disconnect_exo():
	SaveLogic.data.add_exercice(current_exercice.exercice_name)
	SaveLogic.save_data()
	current_exercice.on_exercice_success.disconnect(_on_exo_success)
	current_exercice.on_exercice_fail.disconnect(_on_exo_failure)
	current_exercice.visible = false
	current_exercice = null
