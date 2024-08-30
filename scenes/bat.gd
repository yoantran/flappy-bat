extends CharacterBody2D


const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100,400)

# called when the node enters the scen tree for the first time
func _ready():
    reset()


func reset():
    falling = false
    flying = false
    position = START_POS
    set_rotation(0)


# to call every frame
func _physics_process(delta): # delta = elapsed time since the previous frame
    if flying or falling:
        velocity.y += GRAVITY * delta

        #terminal velocity
        if velocity.y > MAX_VEL:
            velocity.y = MAX_VEL
        if flying:
            set_rotation(deg_to_rad(velocity.y * 0.05))
            $AnimatedSprite2D.play()
        elif falling:
            set_rotation(PI/2)
            $AnimatedSprite2D.stop()
        
        move_and_collide(velocity * delta)
    else:
        $AnimatedSprite2D.stop()


func flap():
    velocity.y = FLAP_SPEED
