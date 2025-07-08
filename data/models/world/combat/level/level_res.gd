class_name LevelResource
extends Resource
## Attributes, controller & signals of the game level.
## Player gains 3 victory points by killing all enemy units.
## Player gains 1 victory point by having more units on "victory tiles" than the opponent at the end of the turn.
## Player loses 1 victory point by having less units on "victory tiles" than the opponent at the end of the turn.
## Player wins the level if they have 3 score
## Player loses the level if they have -3 score

## Emitted when a participant gains a victory point
signal called_increment_victory_points(participant: Participants)

## Stores the current score of player
var player_score: int = 0

## Triggers the incrementation of victory points
## [param participant] The target participant who is gaining the victory points
func increment_victory_points(participant: Participants) -> void:
	called_increment_victory_points.emit(participant)
