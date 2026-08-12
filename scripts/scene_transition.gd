extends Node

var outside_spawn_position: Vector2 = Vector2.ZERO

# Used when returning from the house.
# The main world should NOT load the save again.
var returning_from_house: bool = false
