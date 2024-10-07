extends Node2D


func _ready() -> void:
    $AnimationPlayer.play("Fade in")
    await get_tree().create_timer(6).timeout
    $AnimationPlayer.play("Fade out")
    await get_tree().create_timer(3).timeout
    get_tree().change_scene_to_file("res://main.tscn")


# func _on_intro_finished():
#     if finished:
#         get_tree().change_scene("res://main.tscn")


# # Connect the animation end signal to the _on_intro_finished() function
# @onready var intro_animation = $AnimationPlayer.get_animation("Fade out")
# intro_animation.connect("finished", self, "_on_intro_finished")
