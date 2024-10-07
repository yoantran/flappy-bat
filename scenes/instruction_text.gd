extends RichTextLabel


var speed = 5
var fade = false

var time=0
var sinTime = 0
var _visible = true

func flashMyText():
    if !fade:
        if sinTime >0 :
            # $instructionText.visibility = true
            _visible = true
        else:
            # $instructionText.visibility = false
            _visible = false
    else:
        # $instructionText.visibility = true
        _visible = true
        modulate.a = sinTime
    visible = _visible

func _physics_process(delta: float) -> void:
    time += delta
    sinTime = sin(time*speed)
    flashMyText()
