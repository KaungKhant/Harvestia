extends Area2D

@onready var sound = $AudioStreamPlayer2D

var chicken_sounds = [

 preload("res://audio/sfx/chicken-cluck-1.ogg"),
 preload("res://audio/sfx/chicken-cluck-2.ogg"),
 preload("res://audio/sfx/chicken-cluck-3.ogg")

]

func _ready():

 randomize()

func _on_body_entered(body):

 if body.name == "Player":
  sound.stream = chicken_sounds[randi() % chicken_sounds.size()]
  sound.play()

func _on_body_exited(body):

 if body.name == "Player":
  sound.stop()
