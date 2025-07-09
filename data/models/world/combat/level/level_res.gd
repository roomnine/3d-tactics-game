class_name LevelResource
extends Resource
## Attributes, controller & signals of the game level.
## Player gains 3 victory points by killing all enemy units.
## Player gains 1 victory point by having more units on "victory tiles" than the opponent at the end of the turn.
## Player loses 1 victory point by having less units on "victory tiles" than the opponent at the end of the turn.
## Player wins the level if they have 3 score
## Player loses the level if they have -3 score

## Stores the current score of player
var player_score: int = 0
## Current turn stage (0: init, 1: handle, 2: end)
var turn_stage: int = 0
## Reference to the PlayerUnits node
var player: PlayerUnits = null
## Reference to the EnemyUnits node
var enemy: EnemyUnits
## Reference to the Participants node
var participant: Participants
## Reference to the TacticsBoard node
var board: TacticsBoard
