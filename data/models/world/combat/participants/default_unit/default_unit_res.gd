class_name DefaultUnitResource
extends Resource
## Resource class for managing unit data and state in the game

## Signal emitted when the unit moves
signal unit_moved
## Signal emitted when the unit attacks
signal unit_attacked
## Signal emitted when the unit's turn ends
signal turn_ended

## Minimum height difference required for the unit to jump
const MIN_HEIGHT_TO_JUMP: int = 1
## Strength of gravity applied to the unit
const GRAVITY_STRENGTH: int = 6
## Minimum time required for an attack animation
const MIN_TIME_FOR_ATTACK: float = 1.0
## Number of frames in the unit's animation
const ANIMATION_FRAMES: int = 1

## Whether the unit's HUD is currently enabled
var unit_hud_enabled: bool = false
## Whether the unit can move
var can_move: bool = true
## Whether the unit can attack
var can_attack: bool = true
## Whether the unit is currently jumping
var is_jumping: bool = false
## Whether the unit is currently moving
var is_moving: bool = false

## The direction the unit is moving in
var move_direction: Vector3 = Vector3.ZERO
## Stack of tiles representing the unit's pathfinding route
var pathfinding_tilestack: Array[Variant] = []
## Current gravity vector applied to the unit
var gravity: Vector3 = Vector3.ZERO
## Delay before the unit can perform its next action
var wait_delay: float = 0.0
## Speed at which the unit walks
var walk_speed: int = TacticsConfig.unit.base_walk_speed


## Resets the unit's turn, allowing it to move and attack again
func reset_turn() -> void:
	can_move = true
	can_attack = true


## Ends the unit's turn, preventing further actions and emitting the turn_ended signal
func end_unit_turn() -> void:
	can_move = false
	can_attack = false
	turn_ended.emit()


## Sets the unit's moving state and emits the unit_moved signal if true
## @param value: Whether the unit is moving or not
func set_moving(value: bool) -> void:
	is_moving = value
	if value:
		unit_moved.emit()


## Sets the unit's attacking state and emits the unit_attacked signal if false
## @param value: Whether the unit can attack or not
func set_attacking(value: bool) -> void:
	can_attack = value
	if not value:
		unit_attacked.emit()
