class_name DefaultUnit
extends CharacterBody3D
## Represents a unit in the tactics game, handling movement, combat, and state management

## Resource containing control-related data and configurations
@export var controls: ControlsResource = load("res://data/models/view/control/control.tres")

## Resource containing unit-specific data and configurations
var res: DefaultUnitResource
## Service handling unit-related logic and operations
var serv: DefaultUnitService

## Reference to the Stats node, handling unit statistics
@onready var stats: Stats = $Expertise/Stats
## TODO: The expertise (class or type) of the unit
#@onready var expertise: String = $Expertise/Stats.expertise
## Reference to the TacticsPawnSprite node, handling visual representation
@onready var character: DefaultUnitSprite = $DefaultUnitSprite


## Initializes the DefaultUnit node
func _ready() -> void:
	res = DefaultUnitResource.new()
	serv = DefaultUnitService.new()
	## TODO: setup animations
	#serv.setup(self)
	controls.set_actions_menu_visibility(false, self)
	#show_pawn_stats(false)


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


## Gets the tile the pawn is currently on
##
## @return: The TacticsTile the pawn is on
func get_tile() -> Tile:
	return $Tile.get_collider()


## Checks if the pawn is alive
##
## @return: Whether the pawn's current health is above 0
func is_alive() -> bool:
	return stats.curr_health > 0


## Checks if the pawn can perform any action
##
## @return: Whether the pawn can move or attack, and is alive
func can_act() -> bool:
	return res.can_move or res.can_attack


## Checks if the pawn can move
##
## @return: Whether the pawn can move and is alive
func can_pawn_move() -> bool:
	return res.can_move and is_alive()


## Checks if the pawn can attack
##
## @return: Whether the pawn can attack and is alive
func can_pawn_attack() -> bool:
	return res.can_attack and is_alive()
