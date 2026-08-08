extends Control

@onready var background = $Background
@onready var story = $StoryText
@onready var fade = $Fade
@onready var animation = $AnimationPlayer

var page = 0
var is_transitioning := false

var texts = [
"""Many years ago....""",

"""Harvestia is with full of life.""",

"""Time passes.""",
"""The village slowly becomes empty.""",

"""Buildings decay.""",

"""People leave.""",

"""Grandfather alone in his field.
Looking toward the village.""",

"""A letter has arrived...
"""
]

var images = [

    preload("res://assets/story/story1.png"),
    preload("res://assets/story/story2.png"),
    preload("res://assets/story/story3.png"),
    preload("res://assets/story/story4.png"),
    preload("res://assets/story/story5.png"),
    preload("res://assets/story/story6.png"),
    preload("res://assets/story/story7.png"),
    preload("res://assets/story/story9.png"),

]
func _ready():
    show_page()

func _unhandled_input(event):
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_B:
            print("B key pressed! Current page: ", page)
            next_page()

func show_page():

    background.texture = images[page]

    story.text = texts[page]

    animation.play("FadeIn")
func next_page():
    if is_transitioning:
        return

    is_transitioning = true

    animation.play("FadeOut")
    await animation.animation_finished

    page += 1

    if page >= texts.size():
        start_game()
        return

    show_page()
    is_transitioning = false

func start_game():
    StageManager.change_stage(StageManager.MainWorld)
