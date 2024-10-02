extends CanvasLayer


signal restart

@onready var restart_sfx: AudioStreamPlayer = $RestartSfx


func _on_restart_button_pressed() -> void:
	restart_sfx.play()
	restart.emit()
