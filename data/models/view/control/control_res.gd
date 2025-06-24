class_name ControlsResource
extends Resource
## Resource class for managing tactics controls and related signals.

## Signal emitted when the actions menu visibility needs to be set.
signal called_set_actions_menu_visibility
## Signal emitted when the camera needs to be moved.
signal called_move_camera
## Signal emitted when a unit needs to be selected.
signal called_select_unit
## Signal emitted when a unit needs to be selected for attack.
signal called_select_unit_to_attack
## Signal emitted when a new location needs to be selected.
signal called_select_new_location
## Signal emitted when the cursor shape needs to be set to "move".
signal called_set_cursor_shape_to_move
## Signal emitted when the cursor shape needs to be set to "arrow".
signal called_set_cursor_shape_to_arrow

## Indicates whether the current input device is a joystick.
@export var is_joystick: bool
## Indicates whether the input hints are folded.
@export var input_hints_folded: bool

## Dictionary of available actions and their corresponding methods.
var actions: Dictionary = {
	"Move": "_player_wants_to_move",
	"Skill": "_player_wants_to_use_skill",
	"Cancel": "_player_wants_to_cancel",
	"Attack": "_player_wants_to_attack",
	"EndTurn": "_player_wants_to_end_turn"
}

## TODO: Sets the visibility of the actions menu.
#func set_actions_menu_visibility(v: bool, p: DefaultUnit) -> void:
	#called_set_actions_menu_visibility.emit(v, p)


## Initiates camera movement.
func move_camera(delta: float) -> void:
	called_move_camera.emit(delta)


## Selects a unit for the given player.
func select_unit(player: PlayerUnits) -> void:
	called_select_unit.emit(player)


## Selects a unit to attack.
func select_unit_to_attack() -> void:
	called_select_unit_to_attack.emit()


## Selects a new location.
func select_new_location() -> void:
	called_select_new_location.emit()


## Sets the cursor shape to "move".
func set_cursor_shape_to_move() -> void:
	called_set_cursor_shape_to_move.emit()


## Sets the cursor shape to "arrow".
func set_cursor_shape_to_arrow() -> void:
	called_set_cursor_shape_to_arrow.emit()
