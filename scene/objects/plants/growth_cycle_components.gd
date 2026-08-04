class_name GrowthCycleComponents
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(4, 365) var days_until_harvest: int = 6

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int

# NEW variable to reliably track accumulated growth steps independently of calendar math
var growth_progress: int = 0

var just_loaded := false
var harvested := false

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if just_loaded:
		just_loaded = false
		return

	if !is_watered:
		return

	if starting_day == 0:
		starting_day = day

	growth_progress += 4
	growth_states()
	harvest_state()

func growth_states() -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5
	
	# Calculate state based on our double-speed counter
	var state_index = (growth_progress % num_states) + 1
	
	if state_index >= DataTypes.GrowthStates.Maturity:
		current_growth_state = DataTypes.GrowthStates.Maturity
	else:
		current_growth_state = state_index as DataTypes.GrowthStates
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: ", name, " State index: ", current_growth_state)
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state() -> void:
	if harvested:
		return

	if growth_progress >= days_until_harvest:
		harvested = true
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

func stop_growth():
	if DayAndNightCycleManager.time_tick_day.is_connected(on_time_tick_day):
		DayAndNightCycleManager.time_tick_day.disconnect(on_time_tick_day)
