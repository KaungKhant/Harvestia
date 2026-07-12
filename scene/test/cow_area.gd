extends Area2D

@onready var sound = $AudioStreamPlayer2D

func _ready():

 sound.stop()

func _on_body_entered(body):

 if body.name == "Player":
  print("Player Enter")
  sound.play()

func _on_body_exited(body):

 if body.name == "Player":
  print("Player Exit")
  sound.stop()
