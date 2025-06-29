class_name DefaultUnitService
extends RefCounted
## Service class for managing unit operations in the game

## Service for handling unit movement
var movement: UnitMovementService
## TODO: Service for handling unit combat
#var combat: UnitCombatService
## TODO: Service for handling unit animations
#var animation: UnitAnimationService
## Service for handling unit HUD operations
var ui: UnitHudService
## Service for handling character
var character: DefaultUnitSprite

## Initializes the DefaultUnitService and its sub-services
func _init() -> void:
	movement = UnitMovementService.new()
	#TODO: combat = UnitCombatService.new()
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
	#TODO: ui.update_character_health(unit)

## TODO: Initiates an attack on a target unit
##
## @param unit: The attacking unit
## @param target_unit: The unit being attacked
## @param delta: Time elapsed since the last frame
## @return: Whether the attack was successful
#func attack_target_unit(unit: DefaultUnit, target_unit: DefaultUnit, delta: float) -> bool:
	#return combat.attack_target_unit(unit, target_unit, delta)
