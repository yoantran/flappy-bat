extends Control

var bgMusic = AudioServer.get_bus_index("Music")


func _ready():
    $HSlider.value = db_to_linear(bgMusic)

func _on_h_slider_mouse_exited():
    release_focus()


func _on_h_slider_value_changed(value:float) -> void:
    AudioServer.set_bus_volume_db(bgMusic, linear_to_db(value))
