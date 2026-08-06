extends CanvasLayer

func _ready():
    $ColorRect.hide()
    $Label.hide()
    
const MainMenu = "res://main_menu.tscn"
const Intro = "res://scene/ui/intro.tscn"
const MainWorld = "res://profile.tscn"

func change_stage(stage_path:String):

    $ColorRect.show()
    $Label.show()

    $anim.play("Fade In")

    await $anim.animation_finished

    get_tree().change_scene_to_file(stage_path)

    $anim.play("Fade Out")
    await $anim.animation_finished

    $ColorRect.hide()
    $Label.hide()
