extends Node

signal on_data_loaded()
signal on_data_saved()
signal on_data_save_failed()
signal on_new_element_added(element:ElementData)
##This signal is emitted right before the element is deleted
signal on_element_deleted(element:ElementData)
signal on_data_deleted()

var data:SaveData

const save_path:String = "user://BokyaSaveFile.tres"

func save_data():
	var err = ResourceSaver.save(data, save_path)
	if err == 0:
		print("Saved succesfully at : " + ProjectSettings.globalize_path(save_path))
		on_data_saved.emit()
	else:
		print("Save failed, error : " + error_string(err))
		on_data_save_failed.emit()

func load_data() -> SaveData:
	if ResourceLoader.exists(save_path):
		print("Save file available, loading it")
		data = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		print("No save file found, new data created")
		print(ProjectSettings.globalize_path(save_path))
		data = SaveData.new()
	
	on_data_loaded.emit()
	return data

func save_new_element(element:ElementData):
	if data == null:
		load_data()
	
	data.elements.append(element)
	on_new_element_added.emit(element)

func delete_element(id:int):
	pass

func delete_data():
	data = SaveData.new()
	on_data_deleted.emit()
	save_data()

func get_saved_elements() -> Array[ElementData]:
	if data == null:
		load_data()
	
	return data.elements

func get_next_element_id() -> int:
	if data == null:
		load_data()
	
	return data.elements.size()
