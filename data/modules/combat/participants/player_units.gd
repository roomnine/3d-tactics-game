class_name PlayerUnits
extends Participants
## Handles player-specific actions and logic in the tactics game
## 
## Extends Participants to provide player-specific functionality
## Service: [PlayerService]

## Service handling player-specific logic and operations
var player_serv: PlayerService


## Initializes the PlayerUnits node
func _ready() -> void:
	# Call the parent class's _ready function
	super._ready()
	# Initialize the player service with necessary resources
	player_serv = PlayerService.new(res, camera, controls, board)


## Processes player-related physics updates
##
## @param _delta: Time elapsed since the last frame (unused)
func _physics_process(_delta: float) -> void:
	# Toggle the display of enemy stats
	player_serv.toggle_enemy_stats(get_node("../EnemyUnits"))


## Checks if the player's unit is properly configured
##
## @return: Whether the player's unit is configured
func is_unit_configured() -> bool:
	return player_serv.is_unit_configured(self)


## Displays the available actions for the player's unit
func show_available_unit_actions() -> void:
	player_serv.show_available_unit_actions()


## Displays the available movement options for the player's unit
func show_available_movements() -> void:
	player_serv.show_available_movements()


## Displays the attackable targets for the player's unit
func display_attackable_targets() -> void:
	player_serv.display_attackable_targets()


## Initiates the movement of the player's unit
func move_unit() -> void:
	player_serv.move_unit()
