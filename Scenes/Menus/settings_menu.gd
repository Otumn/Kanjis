extends BaseMenu

@onready var btn_save_settings: Button = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/Btn_save_settings

var need_saving:bool = false

func _ready() -> void:
	load_config()
	link_all_configs()
	super._ready()

func link_all_configs():
	for c in get_tree().get_nodes_in_group("OptionConfig"):
		c = c as UIConfig
		c.config_updated.connect(on_ui_config_changed)

func create_config_file() -> ConfigFile:
	var config: ConfigFile = ConfigFile.new()
	for c in get_tree().get_nodes_in_group("OptionConfig"):
		c = c as UIConfig
		config.set_value(c.config_section, c.parameter_name, c.get_config_value())
	return config

func load_config():
	var settings: ConfigFile = SaveLogic.load_config()
	
	for c in get_tree().get_nodes_in_group("OptionConfig"):
		c = c as UIConfig
		c.set_config_value(settings.get_value(c.config_section, c.parameter_name))

func on_ui_config_changed(_old:Variant, _new:Variant):
	btn_save_settings.disabled = false

func _on_btn_save_settings_button_down() -> void:
	SaveLogic.save_config(create_config_file())
	btn_save_settings.disabled = true
