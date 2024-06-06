class_name Ability extends Resource

enum TargetType { ONE, ALL }

@export var type: Constants.AbilityType
@export var text: String = "Text TBD"
@export_multiline var description: String
@export var target_type: TargetType
@export var exhausts: bool
@export var mana_cost: int
@export var value: int
@export var accuracy: float


func does_target_all() -> bool:
	return target_type == TargetType.ALL
