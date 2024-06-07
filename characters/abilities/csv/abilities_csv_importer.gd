@tool
class_name AbilitiesCSVImporter extends Resource

signal finished_processing_type

@export var import: bool = false:
	set(value):
		if not is_running:
			_import()
@export var is_running: bool = false

var current_csv_file = null

const ABILITIES_PATH = "res://characters/abilities/"
const TEMP_PATH = "res://characters/abilities/temp.csv"
const RESOURCE_SAVE_PATH = "res://characters/abilities/resources/"
const GID_NUMBERS = {
	Constants.AbilityType.APPEARANCE_ATTACK: 0,
	Constants.AbilityType.SELF_ESTEEM_ATTACK: 2144088841,
	Constants.AbilityType.INTELLIGENCE_ATTACK: 74296121,
	Constants.AbilityType.PHYSICAL_ABILITY_ATTACK: 1184434838,
	Constants.AbilityType.SOCIAL_LIFE_ATTACK: 1104121680
}


func _import():
	is_running = true
	
	var dir = DirAccess.open(ABILITIES_PATH)
	if dir != null:
		dir.remove(RESOURCE_SAVE_PATH)
		dir.make_dir_recursive(RESOURCE_SAVE_PATH)
	else:
		dir.make_dir_recursive(RESOURCE_SAVE_PATH)
	
	var requester = HTTPRequest.new()
	EditorInterface.get_edited_scene_root().add_child(requester)
	requester.request_completed.connect(_on_request_completed)
	for gid_number in GID_NUMBERS:
		requester.request("https://docs.google.com/spreadsheets/d/1e8IUim1I__UI9z75k35SvM6t0nqz7aL4TIBNw-VkA1w/gviz/tq?tqx=out:csv&gid=" + str(GID_NUMBERS[gid_number]))
		await requester.request_completed
		
		dir = DirAccess.open(ABILITIES_PATH)
		if dir.file_exists(TEMP_PATH):
			dir.remove(TEMP_PATH)
		var file = FileAccess.open(TEMP_PATH, FileAccess.WRITE)
		file.store_string(current_csv_file)
		file.close()
		EditorInterface.get_resource_filesystem().scan_sources()
		await EditorInterface.get_edited_scene_root().get_tree().create_timer(0.5).timeout
		
		var csv_file = load("res://characters/abilities/temp.csv")
		
		for i in range(csv_file.records.size() - 1):
			var row_data = csv_file.records[i + 1]
			
			var ability_resource = Ability.new()
			ability_resource.type = gid_number
			ability_resource.text = row_data[1]
			ability_resource.description = row_data[2]
			ability_resource.target_type = _get_enum_of_target_type_string(row_data[3])
			ability_resource.exhausts = row_data[4] == "TRUE"
			ability_resource.mana_cost = int(row_data[5])
			if row_data[6] != "-":
				ability_resource.value = int(row_data[6])
			if row_data[7] != "-":
				ability_resource.attack_accuracy = _get_accuracy_percentage_from_string(row_data[7])
			if row_data[8] != "-":
				ability_resource.effect_accuracy = _get_accuracy_percentage_from_string(row_data[8])
			
			var file_path = RESOURCE_SAVE_PATH + row_data[0] + ".tres"
			print("Creating: " + file_path)
			ResourceSaver.save(ability_resource, file_path)
	
	dir.remove(TEMP_PATH)
	dir.remove(TEMP_PATH + ".import")
	is_running = false
	print("Finished!")



func _on_request_completed(result, response_code, headers, body):
	current_csv_file = body.get_string_from_utf8()


func _get_enum_of_target_type_string(value: String) -> Ability.TargetType:
	match value:
		"One Self":
			return Ability.TargetType.ONE_SELF
		"One Other":
			return Ability.TargetType.ONE_OTHER
		"All Self":
			return Ability.TargetType.ALL_SELF
		"All Other":
			return Ability.TargetType.ALL_OTHER
		_:
			return Ability.TargetType.ONE_SELF


func _get_accuracy_percentage_from_string(value: String) -> float:
	value = value.substr(0, value.length() - 1)
	var result = float(value)
	result /= 100.0
	return result
