extends BaseExercice


func setup_exercice():
	#setup here
	super.setup_exercice()

func pick_answer(_index: int):
	fail_exercice()

func _on_btn_answer_1_button_down() -> void:
	pick_answer(0)


func _on_btn_answer_2_button_down() -> void:
	pick_answer(1)


func _on_btn_answer_3_button_down() -> void:
	pick_answer(2)
