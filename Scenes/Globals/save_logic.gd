extends Node

var data:SaveData

const save_path:String = "user://BokyaSaveFile.tres"

func _ready() -> void:
	load_data()

func save_data():
	var err = ResourceSaver.save(data, save_path)
	if err == 0:
		print("Saved succesfully at : " + ProjectSettings.globalize_path(save_path))
	else:
		print("Save failed, error : " + error_string(err))

func load_data() -> SaveData:
	if ResourceLoader.exists(save_path):
		print("Save file available, loading it")
		data = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		print("No save file found, new data created")
		print(ProjectSettings.globalize_path(save_path))
		data = SaveData.new()
	return data

func save_new_element(element:ElementData):
	if data == null:
		load_data()
	
	data.elements.append(element)

func request_data_deletion():
	PopupLogic.pop_choice(PopupLogic.pop_type.WARNING, "Are you sure?", "You are about to delete all your cards. Are you sure?", delete_data)

func delete_data():
	data = SaveData.new()
	save_data()

func get_saved_elements() -> Array[ElementData]:
	if data == null:
		load_data()
	
	return data.elements

func get_next_element_id() -> int:
	if data == null:
		load_data()
	
	return data.elements.size()
