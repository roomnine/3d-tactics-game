class_name Status
extends Node
## The expertise of a game actor.
##
## Assigns a set of stats to a pawn, 

## Resource containing initial stats for the actor
@export var starting_stats: StatsResource
## Array of initial skills for the actor
@export var starting_skills: Array[String]

## Node containing the actor's stats
@onready var stats: Stats = $Stats


func _ready() -> void:
	if not starting_stats:
		push_error("Status needs a StatsResource (Starting Stats) from /data/models/stats/") # Error if starting stats are not set
	stats.import_stats(starting_stats) # Initialize stats from the starting_stats resource
