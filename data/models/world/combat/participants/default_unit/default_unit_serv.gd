class_name DefaultUnitService
extends RefCounted
## Service class for managing unit operations in the game

## Service for handling unit movement
var movement: UnitMovementService
## Service for handling unit combat
var combat: UnitCombatService
## TODO: Service for handling unit animations
#var animation: UnitAnimationService
## Service for handling unit HUD operations
var ui: UnitHudService
## Service for handling character
var character: DefaultUnitSprite

## Initializes the DefaultUnitService and its sub-services
func _init() -> void:
	movement = UnitMovementService.new()
	combat = UnitCombatService.new()
	#TODO: animation = UnitAnimationService.new()
	ui = UnitHudService.new()

## TODO: Sets up the unit service, particularly the animation service
##
## @param unit: The unit to set up
#func setup(unit: DefaultUnit) -> void:
	#animation.setup(unit)

## Processes unit-related operations every frame
##
## @param unit: The unit to process
## @param delta: Time elapsed since the last frame
func process(unit: DefaultUnit, delta: float) -> void:
	movement.move_along_path(unit, delta)
	#TODO: animation.start_animator(unit)
	ui.apply_tint_when_unable_to_act(unit)
	ui.update_unit_health(unit)

## Initiates an attack on a target unit
##
## @param unit: The attacking unit
## @param target_unit: The unit being attacked
## @param delta: Time elapsed since the last frame
## @return: Whether the attack was successful
func basic_attack(unit: DefaultUnit, target_unit: DefaultUnit) -> bool:
	return combat.basic_attack(unit, target_unit)


## Initiates a skill on a target unit
##
## @param unit: The unit using the skill
## @param skill: The skill resource to use
## @param targetable_units: The units being targeted if exists
## @param targetable_tiles: The tiles being targeted if exists
## @return: Whether the skill was successfully used
func use_skill(unit: DefaultUnit, skill: SkillResource, targetable_units: Array[DefaultUnit] = [], targetable_tiles: Array[Tile] = []) -> bool:
	return combat.use_skill(unit, skill, targetable_units, targetable_tiles)
