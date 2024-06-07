@tool
class_name AbilitiesCSVImporter extends Resource

@export var import: bool = false:
	set(value):
		_import()

const ABILITIES_PATH = "res://characters/abilities/"
const RESOURCE_SAVE_PATH = "res://characters/abilities/resources/"
const CSV_FILES = [
	preload("res://characters/abilities/csv/Wrath of the Witty - Abilities - Appearance Attack.csv"),
	preload("res://characters/abilities/csv/Wrath of the Witty - Abilities - Intelligence Attack.csv"),
	preload("res://characters/abilities/csv/Wrath of the Witty - Abilities - Physical Ability Attack.csv"),
	preload("res://characters/abilities/csv/Wrath of the Witty - Abilities - Self-esteem Attack.csv"),
	preload("res://characters/abilities/csv/Wrath of the Witty - Abilities - Social Life Attack.csv")
]

func _import():
	var dir = DirAccess.open(ABILITIES_PATH)
	if dir != null:
		dir.remove(RESOURCE_SAVE_PATH)
		dir.make_dir_recursive(RESOURCE_SAVE_PATH)
	else:
		dir.make_dir_recursive(RESOURCE_SAVE_PATH)
	
	for csv_file in CSV_FILES:
		for i in range(csv_file.records.size() - 1):
			var row_data = csv_file.records[i + 1]
			
			var ability_resource = Ability.new()
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
