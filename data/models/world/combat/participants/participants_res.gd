class_name ParticipantsResource
extends Resource
## Attributes & signals of the tactics participant.
## 
## Dependency of: [Participants]

## Signal emitted when a turn is skipped
signal called_end_turn

#region Stage Selection
## Constant for the unit selection stage
const STAGE_SELECT_UNIT: int = 0
## Constant for the action display stage
const STAGE_SHOW_ACTIONS: int = 1
## Constant for the movement display stage
const STAGE_SHOW_MOVEMENTS: int = 2
## Constant for the location selection stage
const STAGE_SELECT_LOCATION: int = 3
## Constant for the unit movement stage
const STAGE_MOVE_UNIT: int = 4
## Constant for the target display stage
const STAGE_DISPLAY_TARGETS: int = 5
## Constant for the attack target selection stage
const STAGE_SELECT_ATTACK_TARGET: int = 6
## Constant for the attack execution stage
const STAGE_ATTACK: int = 7
## Constant for the no-target skill confirmation stage
const STAGE_SELECT_SKILL_NO_TARGET: int = 8
## Constant for the unit selection stage for skill
const STAGE_SELECT_SKILL_TARGET_UNIT: int = 9
## Constant for the tile selection stage for skill
const STAGE_SELECT_SKILL_TARGET_TILE: int = 10
## Constant for the skill execution stage
const STAGE_SKILL: int = 11
## The current stage of the participant's turn
var stage: int = 0
#endregion

## The currently active unit
var curr_unit: DefaultUnit = null:
	set(val):
		curr_unit = val
		DebugLog.debug_nospam("unit", val)
## The node containing allies on map
var allies_on_map: Node = null
## The node containing enemies on map
var enemies_on_map: Node = null
## The skill selected
var selected_skill: SkillResource = null
## The unit that can be targeted by skill
var targetable_unit: DefaultUnit = null
## The tile selected for a skill
var targetable_tile: Tile = null

## Flag to control the display of enemy stats
var display_enemy_stats: bool = false
## Flag indicating if the turn has just started
var turn_just_started: bool = true


## Emits the end_turn signal
func end_turn() -> void:
	called_end_turn.emit()
