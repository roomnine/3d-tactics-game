class_name EnemyUnits
extends Participants
## Handles enemy AI actions and decision-making
## 
## Service: [EnemyService]

## Service handling enemy-specific logic and operations
var enemy_serv: EnemyService


## Initializes the EnemyService node
func _ready() -> void:
	super._ready() # Call the parent's _ready function
	enemy_serv = EnemyService.new(res, camera, controls, board) # Initialize the opponent service


## Checks if the opponent's unit is properly configured
##
## @return: Whether the unit is configured
func is_unit_configured() -> bool:
	return enemy_serv.is_unit_configured(self) # Delegate to the service


## Chooses a unit for the opponent to act with
func choose_unit() -> void:
	enemy_serv.choose_unit(self) # Delegate to the service


## Initiates the action of chasing the nearest enemy
func chase_nearest_enemy() -> void:
	enemy_serv.chase_nearest_enemy() # Delegate to the service


## Checks if the opponent's unit has finished moving
func is_unit_done_moving() -> void:
	enemy_serv.is_unit_done_moving() # Delegate to the service


## Chooses a unit for the opponent to attack
func choose_unit_to_attack() -> void:
	enemy_serv.choose_unit_to_attack() # Delegate to the service
