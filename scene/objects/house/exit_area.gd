extends Area2D

@export var outside_spawn : Marker2D

var player_inside=false

func _process(delta):

    if player_inside and Input.is_action_just_pressed("interact"):

        var player=get_tree().get_first_node_in_group("player")

        player.global_position=outside_spawn.global_position

func _on_body_entered(body):

    if body.is_in_group("player"):
        player_inside=true

func _on_body_exited(body):

    if body.is_in_group("player"):
        player_inside=false
