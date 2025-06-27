class_name TacticsControlsService
extends RefCounted
## Service class for managing tactics controls and related functionalities.

## Reference to the TacticsControlsResource.
var controls: ControlsResource
## Reference to the TacticsCameraResource.
var t_cam: CameraResource
## Reference to the TacticsParticipantResource.
var participant: ParticipantsResource
## Reference to the TacticsArenaResource.
var board: BoardResource
## Node for capturing mouse clicks.
var input_capture: Node
## Service for handling input-related operations.
var input_service: ControlsInputService
## Service for managing UI-related operations.
var ui_service: UiService
## TODO: Service for handling camera-related operations.
#var camera_service: ControlsCameraService
## Service for managing unit selection operations.
var selection_service: ControlsSelectionService


## Initializes the TacticsControlsService with necessary resources and services.
func _init(_controls: ControlsResource, _t_cam: CameraResource, _participant: ParticipantsResource, _board: BoardResource, _inputk_capture: Node) -> void:
	controls = _controls
	t_cam = _t_cam
	participant = _participant
	board = _board
	input_capture = _inputk_capture
	input_service = ControlsInputService.new(controls, input_capture)
	ui_service = UiService.new(controls)
	#TODO: camera_service = TacticsControlsCameraService.new(t_cam)
	selection_service = ControlsSelectionService.new(participant, board, controls, t_cam, input_service)


## Sets up signal connections and performs initial checks.
func setup(ctrl: TacticsControls) -> void:
	if not controls:
		push_error("TacticsControls needs a ControlResource from /data/models/view/controls/tactics/")
	else:
		controls.connect("called_set_actions_menu_visibility", ctrl.set_actions_menu_visibility)
		controls.connect("called_set_cursor_shape_to_move", ctrl.set_cursor_shape_to_move)
		controls.connect("called_set_cursor_shape_to_arrow", ctrl.set_cursor_shape_to_arrow)
		controls.connect("called_select_unit", ctrl.select_unit)
		controls.connect("called_select_unit_to_attack", ctrl.select_unit_to_attack)
		controls.connect("called_select_new_location", ctrl.select_new_location)
	if not t_cam:
		push_error("TacticsCamera needs a CameraResource (T Cam) from /data/models/view/camera/tactics/")
	if not board:
		push_error("TacticsControls needs an ArenaResource from /data/models/world/combat/arena/")


## Performs physics processing tasks.
func physics_process(_delta: float, ctrl: TacticsControls) -> void:
	input_service.update_mouse_mode()
	#TODO: ui_service.update_controller_hints(ctrl)
	selection_service.update_hovered_tile(ctrl)


## Handles input events.
func handle_input(event: InputEvent) -> void:
	input_service.handle_input(event)


## Delegates setting actions menu visibility to the UI service.
func set_actions_menu_visibility(v: bool, p: DefaultUnit, ctrl: TacticsControls) -> void:
	ui_service.set_actions_menu_visibility(v, p, ctrl)


## Delegates unit selection to the unit selection service.
func select_unit(player: PlayerUnits, ctrl: TacticsControls) -> void:
	selection_service.select_unit(player, ctrl)


## Delegates new location selection to the unit selection service.
func select_new_location(ctrl: TacticsControls) -> void:
	selection_service.select_new_location(ctrl)


## Delegates unit attack selection to the unit selection service.
func select_unit_to_attack(ctrl: TacticsControls) -> void:
	selection_service.select_unit_to_attack(ctrl)


## Handles player's move action.
func player_wants_to_move() -> void:
	selection_service.player_wants_to_move()


## Handles player's cancel action.
func player_wants_to_cancel() -> void:
	selection_service.player_wants_to_cancel()


## Handles player's wait action.
func player_wants_to_wait() -> void:
	selection_service.player_wants_to_wait()


## Handles player's skip turn action.
func player_wants_to_end_turn() -> void:
	selection_service.player_wants_to_end_turn()


## Handles player's attack action.
func player_wants_to_attack() -> void:
	selection_service.player_wants_to_attack()
