extends Node2D


const SCROLL_SPEED: int = 4
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
var screen_size: Vector2i
var ground_height: int
var pipes: Array
var sfx_running: bool
var bgMusic = AudioServer.get_bus_index("Music")
var sfxMusic = AudioServer.get_bus_index("SFX")

@onready var crash_sfx: AudioStreamPlayer = $CrashSfx
@onready var music_track: AudioStreamPlayer = $BgMusic



# Called when the node enters the scene tree for the first time.
func _ready():
    # await splash()
    screen_size = get_window().size
    ground_height = $Ground.get_node("Sprite2D").texture.get_height()
    new_game()
    $BgMusicSlider.value = db_to_linear(bgMusic)
    $SFXSlider.value = db_to_linear(sfxMusic)


# func splash():
#     $intro


func new_game():
    $Control.visible = true
    game_running = false
    game_over = false
    sfx_running = true
    score = 0
    scroll = 0
    $ScoreLabel.text = "SCORE: %d" % [score]
    $GameOver.hide()
    get_tree().call_group("pipes", "queue_free")
    pipes.clear()
    generate_pipes()
    $Bat.reset()


func _input(event):
    if (
        not game_over and (
            (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or
            (event.is_action_pressed("jump") and event.pressed)
            # (event is InputEventKey and event.scancode == KEY_SPACE and event.pressed)
        )
    ):
    # if (
    #        not game_over and event is InputEventMouseButton and
    #        event.button_index == MOUSE_BUTTON_LEFT and event.pressed
    # ):
        if game_running and $Bat.flying:
            $Bat.flap()
            check_top()
        else:
            start_game()


func start_game():
    $Control.visible = false
    game_running = true
    $Bat.flying = true
    $Bat.flap()
    $PipeTimer.start()
    $BgMusicSlider.editable = false
    $SFXSlider.editable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
    if game_running:
        scroll += SCROLL_SPEED
        if scroll >= screen_size.x:
            scroll = 0
        
        $Ground.position.x = -scroll
        for pipe in pipes:
            pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout() -> void:
    generate_pipes()


func generate_pipes():
    var pipe = pipe_scene.instantiate()
    pipe.position.x = screen_size.x + PIPE_DELAY
    pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
    pipe.hit.connect(bat_hit)
    pipe.scored.connect(scored)
    add_child(pipe)
    pipes.append(pipe)


func scored():
    score += 1
    $ScoreLabel.text = "SCORE: %d" % [score]


func check_top():
    if $Bat.position.y < 0:
        $Bat.falling = true
        stop_game()


func stop_game():
    $BgMusicSlider.editable = true
    $SFXSlider.editable = true
    $PipeTimer.stop()
    if sfx_running:
        crash_sfx.play()
        sfx_running = false
    $Bat.flying = false
    game_running = false
    game_over = true
    $GameOver.show()


func bat_hit():
    $Bat.falling = true
    stop_game()


func _on_ground_hit() -> void:
    $Bat.falling = false
    stop_game()


func _on_game_over_restart() -> void:
    new_game()


func _on_bg_music_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(bgMusic, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(sfxMusic, linear_to_db(value))
