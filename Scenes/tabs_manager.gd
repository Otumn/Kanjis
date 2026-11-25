class_name TabsManager
extends TabContainer

@export var tabs_button: Array[TabsButton]

func _ready() -> void:
	connect_buttons()

func connect_buttons():
	if tabs_button.is_empty():return
	
	for b in tabs_button:
		b.connect("index_selected", display_tab)
		if b.target_index == current_tab:
			b.button_pressed = true

func display_tab(index: int):
	current_tab = index
