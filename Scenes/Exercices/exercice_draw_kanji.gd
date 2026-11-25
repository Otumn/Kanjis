extends BaseExercice

@onready var viewport_answer: SubViewport = $SubViewportContainer/Viewport_Answer
@onready var label_target_kanji: Label = $SubViewportContainer/Viewport_Answer/Label_TargetKanji
@onready var texture_answer: TextureRect = $VBoxContainer/MarginContainer/Texture_Answer

func setup_exercice():
	
	await RenderingServer.frame_post_draw
	texture_answer.texture = viewport_answer.get_texture()
	var test = texture_answer.get
	test.save_png("res://test.png")
	
	super.setup_exercice()

func _on_btn_validate_button_down() -> void:
	fail_exercice()
