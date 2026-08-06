extends Control

@onready var background = $Background
@onready var story = $StoryText
@onready var fade = $Fade
@onready var animation = $AnimationPlayer

var page = 0
var is_transitioning := false

var texts = [
"""Long ago...

Harvestia was filled with life.

Every family grew crops together.""",

"""But one day...

The villagers left.

The fields became empty.""",

"""Years later...

You receive a letter from your grandfather.""",

"""Your journey begins...
"""
]

var images = [

    preload("res://assets/story/img1.png"),
    preload("res://assets/story/img2.png"),
    preload("res://assets/story/img3.png"),
    preload("res://assets/story/img4.png"),

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
