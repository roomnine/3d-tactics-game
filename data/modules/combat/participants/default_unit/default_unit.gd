class_name DefaultUnit
extends CharacterBody3D
## Represents a unit in the tactics game, handling movement, combat, and state management

## Resource containing control-related data and configurations
@export var controls: ControlsResource = load("res://data/models/view/control/control.tres")
## Resource containing initial stats for the actor
@export var starting_stats: StatsResource
## Array of initial skills for the actor
@export var starting_skills: Array[String]

## Resource containing unit-specific data and configurations
var res: DefaultUnitResource
## Service handling unit-related logic and operations
var serv: DefaultUnitService

## Reference to the Stats node, handling unit statistics
@onready var stats: Stats = $Stats
## Reference to the Skills node, handling unit skills
@onready var skills: Skills = $Skills
## Reference to the DefaultUnitSprite node, handling visual representation
@onready var character: DefaultUnitSprite = $DefaultUnitSprite


## Initializes the DefaultUnit node
func _ready() -> void:
	print("[DefaultUnit] starting_skills:", starting_skills)
	res = DefaultUnitResource.new()
	serv = DefaultUnitService.new()
	stats.import_stats(starting_stats) # Initialize stats from the starting_stats resource
	skills.import_skills(starting_skills) # Initialize skills from the starting_stats array
	#TODO: serv.setup(self)
	controls.set_actions_menu_visibility(false, self)
	show_unit_stats(false)


## Processes unit logic every physics frame
##
## @param delta: Time elapsed since the last frame
func _physics_process(delta: float) -> void:
	serv.process(self, delta)


## Centers the unit on its current tile
##
## @return: Whether the centering operation was successful
func center() -> bool:
	return character.adjust_to_center(self)


## Gets the tile the unit is currently on
##
## @return: The Tile the unit is on
func get_tile() -> Tile:
	var obj = $Tile.get_collider()
	if obj and obj is Tile:
		return obj
	return null


## Checks if the unit is alive
##
## @return: Whether the unit's current health is above 0
func is_alive() -> bool:
	return stats.curr_health > 0


## Checks if the unit can perform any action
##
## @return: Whether the unit can move or attack, and is alive
func can_act() -> bool:
	return res.can_move or res.can_attack


## Checks if the unit can move
##
## @return: Whether the unit can move and is alive
func can_unit_move() -> bool:
	return res.can_move and is_alive()


## Checks if the unit can attack
##
## @return: Whether the unit can attack and is alive
func can_unit_attack() -> bool:
	return res.can_attack and is_alive()


## Shows or hides unit stats
##
## @param v: visibility yes or no
func show_unit_stats(v: bool) -> void:
	$DefaultUnitSprite/CharacterUI.visible = v


## Initiates a basic attack on a target unit
## 
## @param target_unit: DefaultUnit to attack
func basic_attack(target_unit: DefaultUnit) -> bool:
	return serv.basic_attack(self, target_unit)


## Initiates using a skill
##
## @param skill: The skill resource to use
## @param targetable_units: The units being targeted if exists
## @param targetable_tiles: The tiles being targeted if exists
## @return: Whether the skill was successfully used
func use_skill(unit: DefaultUnit, skill: SkillResource, targetable_units: Array[DefaultUnit] = [], targetable_tiles: Array[Tile] = []):
	return serv.use_skill(self, skill, targetable_units, targetable_tiles)


## Resets the unit's turn state
func reset_turn() -> void:
	res.reset_turn()


## Ends the unit's turn
func end_unit_turn() -> void:
	res.end_unit_turn()
