extends Node

#region DATA SIGNALS
signal on_data_loaded()
signal on_data_saved()
signal on_data_save_failed()
signal on_new_element_added(element:ElementData)
##This signal is emitted right before the element is deleted
signal on_element_deleted(element:ElementData)
signal on_data_deleted()
#endregion

#region CONFIG SIGNALS
signal on_config_loaded()
signal on_config_saved()
signal on_config_save_failed()
signal on_config_deleted()
#endregion

var data:SaveData
var config:ConfigFile

const data_save_path:String = "user://BokyaSaveFile.tres"
const config_save_path:String = "user://BokyaConfig.ini"

#region DATA SAVE MANAGEMENT
func save_data():
	var err = ResourceSaver.save(data, data_save_path)
	if err == 0:
		print("Saved succesfully at : " + ProjectSettings.globalize_path(data_save_path))
		on_data_saved.emit()
	else:
		print("Save failed, error : " + error_string(err))
		on_data_save_failed.emit()

func load_data() -> SaveData:
	if ResourceLoader.exists(data_save_path):
		print("Save file available, loading it")
		data = ResourceLoader.load(data_save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		print("No save file found, new data created")
		print(ProjectSettings.globalize_path(data_save_path))
		data = SaveData.new()
	
	on_data_loaded.emit()
	return data

func save_new_element(element:ElementData):
	if data == null:
		load_data()
	
	data.elements.append(element)
	on_new_element_added.emit(element)

func delete_element(id:int):
	if data == null:
		load_data()
	
	for e in data.elements:
		if e.id == id:
			data.elements.erase(e)
			on_element_deleted.emit(e)
			return

func delete_data():
	if data == null:
		load_data()
	
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

func add_trained_card(card_id:int):
	if data == null:
		load_data()
	
	var date = Time.get_datetime_dict_from_system()
	data.last_trained.push_front(card_id)
	data.last_trained.resize(data.trained_memory_size)
	data.elements[card_id].last_seen_day = date["day"]
	data.elements[card_id].last_seen_month = date["month"]
	data.elements[card_id].last_seen_year = date["year"]

func add_exercice(exo_name:String):
	if data == null:
		load_data()
	
	data.exercice_memory.push_front(exo_name)
	data.exercice_memory.resize(data.exo_memory_size)

func update_elements_indexes():
	if data == null:
		load_data()
	
	for i in data.elements.size():
		data.elements[i].id = i
	
	data.need_general_list_update = true
	data.need_word_list_update = true
	data.need_kanji_list_update = true
#endregion

#region CONFIG SAVE MANAGEMENT
func save_config(saved_config: ConfigFile):
	var err = saved_config.save(config_save_path)
	if err == 0:
		on_config_saved.emit()
	else : 
		on_config_save_failed.emit()

func load_config() -> ConfigFile:
	var loaded_config:ConfigFile = ConfigFile.new()
	var err = loaded_config.load(config_save_path)
	if err == 0:
		on_config_loaded.emit()
		return loaded_config
	else:
		print("Loading failed : " + error_string(err))
		return null

func delete_config():
	on_config_deleted.emit()
	pass
#endregion
