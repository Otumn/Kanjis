class_name ElementData
extends Resource

@export_group("Base")
@export var id:int = 0
@export var is_word:bool = true
@export var base_writing:String = ""
@export var translation:String = ""
@export var corrects: int = 0
@export var wrongs: int = 0

@export_group("State")
@export var mastery:float = 0.0

@export_group("Word parameters")
@export var kanas: String = ""

@export_group ("Kanji parameters")
@export var kunyomi:PackedStringArray
@export var onyomi:PackedStringArray

@export_group("Date")
@export var last_seen_day:int = 0
@export var last_seen_month:int = 0
@export var last_seen_year:int = 0

func get_full_kunyomi() -> String:
	var full:String = ""
	for k in kunyomi:
		full += k
		full += ", "
	return full

func get_full_onyomi() -> String:
	var full:String = ""
	for o in onyomi:
		full += o
		full += ", "
	return full
