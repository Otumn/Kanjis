class_name ConfigKeybind
extends UIConfig

@onready var button: Button = $HBoxContainer/SettingEdit/Button

var valid_keybind: bool = false
var current_event:InputEvent

func _ready() -> void:
	set_process_unhandled_key_input(false)
	param_label.text = clean_param_name(parameter_name)
	update_current_event()
	set_key_text()
	if !valid_keybind:
		button.disabled = true

func set_key_text():
	if !valid_keybind:
		return
	var keycode = OS.get_keycode_string(current_event.physical_keycode)
	button.text = keycode

func update_current_event():
	var action_events = InputMap.action_get_events(parameter_name)
	if !action_events.is_empty():
		current_event = action_events[0]
		valid_keybind = true

func _on_button_toggled(toggled_on: bool) -> void:
	
	if toggled_on:
		button.text = "Assign key..."
		set_process_unhandled_key_input(toggled_on)
		
		for b in get_tree().get_nodes_in_group("KeybindButton"):
			b = b as ConfigKeybind
			if b.parameter_name != parameter_name:
				b.button.toggle_mode = false
				set_process_unhandled_key_input(true)
	else:
		set_key_text()
		
		for b in get_tree().get_nodes_in_group("KeybindButton"):
			b = b as ConfigKeybind
			if b.parameter_name != parameter_name:
				b.button.toggle_mode = true
				set_process_unhandled_key_input(false)

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_input(event)
	button.button_pressed = false

func rebind_input(event: InputEvent):
	var old_event = current_event
	for b in get_tree().get_nodes_in_group("KeybindButton"):
		b = b as ConfigKeybind
		if b.parameter_name != parameter_name:
			if b.current_event.physical_keycode == event.physical_keycode:
				set_process_unhandled_key_input(false)
				return
	
	InputMap.action_erase_events(parameter_name)
	InputMap.action_add_event(parameter_name, event)
	
	set_process_unhandled_key_input(false)
	update_current_event()
	set_key_text()
	config_updated.emit(old_event, current_event)

#region VALUE GETTER/SETTER
func get_config_value() -> Variant:
	return current_event #will probably not be possible because InputEvent might not be possible to save, as opposed as a String

func set_config_value(value: Variant):
	rebind_input(value)
#endregion
