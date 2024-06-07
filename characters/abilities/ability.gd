class_name Ability extends Resource

enum TargetType { ONE_SELF, ONE_OTHER, ALL_SELF, ALL_OTHER }

@export var type: Constants.AbilityType
@export var text: String = "Text TBD"
@export_multiline var description: String
@export var target_type: TargetType
@export var exhausts: bool
@export var mana_cost: int
@export var value: int
@export var attack_accuracy: float
@export var effect_accuracy: float


func does_target_all() -> bool:
	return target_type == TargetType.ALL_SELF or type == TargetType.ALL_OTHER
