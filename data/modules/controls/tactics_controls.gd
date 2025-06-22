class_name TacticsControls
extends Control
## Handles UI elements and player controls for the Tactics systems
## 
## Resource Interface: [TacticsControlsResource] -- Service: [TacticsControlsService]

#region: --- Props ---
## Resource containing control-related data and settings
@export var controls: ControlsResource = load("res://data/models/view/control/control.tres")
## Resource containing camera-related data and settings
@export var t_cam: CameraResource = load("res://data/models/view/camera/camera.tres")
## Resource containing participant-related data and settings
@export var participant: ParticipantsResource = load("res://data/models/world/combat/participants/participants.tres")
## Resource containing board-related data and settings
@export var board: BoardResource = load("res://data/models/world/combat/board/board.tres")

## Currently selected unit
var curr_unit: DefaultUnit = null
## Service handling control logic
var serv: TacticsControlsService

## Texture for Xbox controller layout
@onready var layout_xbox: Texture2D = load("res://assets/textures/ui/labels/controls-ui-xbox.png")
## Texture for PC controls layout
@onready var layout_pc: Texture2D = load("res://assets/textures/ui/labels/controls-ui.png")
## Node for capturing mouse clicks
@onready var input_capture: InputCapture = $InputCapture
#endregion

#region: --- Processing ---
func _ready() -> void:
	# Initialize the service with necessary resources
	serv = TacticsControlsService.new(controls, t_cam, participant, board, input_capture)
	serv.setup(self)
	
	# Connect action buttons to their respective methods
	for action: String in controls.actions.keys():
		var str_name: StringName = controls.actions[action]
		get_act(action).connect("pressed", Callable(self, str_name))

func _physics_process(delta: float) -> void:
	# Handle physics-based processing
	serv.physics_process(delta, self)

func _input(event: InputEvent) -> void:
	# Handle input events
	serv.handle_input(event)
#endregion

#region: --- Methods ---
## Sets the cursor shape to 'move'
func set_cursor_shape_to_move() -> void:
	CursorService.set_cursor_shape_to_move()


## Sets the cursor shape to 'arrow'
func set_cursor_shape_to_arrow() -> void:
	CursorService.set_cursor_shape_to_arrow()


## Moves the camera based on input
func move_camera(delta: float) -> void:
	serv.move_camera(delta)


## Retrieves an action button node
func get_act(action: String = "") -> Button:
	if action == "": 
		return %Actions
	return %Actions.get_node(action)


## Checks if the mouse is hovering over a UI element
func is_mouse_hovering_ui_elem() -> bool:
	return serv.is_mouse_hovering_ui_elem(self)


## Sets the visibility of the actions menu
func set_actions_menu_visibility(v: bool, p: DefaultUnit) -> void:
	serv.set_actions_menu_visibility(v, p, self)


## Gets the 3D position of the mouse in the game world
func get_3d_canvas_mouse_position(collision_mask: int) -> Object:
	return serv.get_3d_canvas_mouse_position(collision_mask, self)


## Selects a unit for the player
func select_unit(player: DefaultUnit) -> void:
	serv.select_unit(player, self)


## Initiates the process of selecting a new location for the unit
func select_new_location() -> void:
	serv.select_new_location(self)


## Initiates the process of selecting a unit to attack
func select_unit_to_attack() -> void:
	serv.select_unit_to_attack(self)


## Handles the player's intention to move
func _player_wants_to_move() -> void:
	serv.player_wants_to_move()


## Handles the player's intention to cancel an action
func _player_wants_to_cancel() -> void:
	serv.player_wants_to_cancel()


## Handles the player's intention to use skill
func _player_wants_to_use_skill() -> void:
	serv.player_wants_to_use_skill()


## Handles the player's intention to end their turn
func _player_wants_to_end_turn() -> void:
	serv.player_wants_to_end_turn()


## Handles the player's intention to attack
func _player_wants_to_attack() -> void:
	serv.player_wants_to_attack()
#endregion
