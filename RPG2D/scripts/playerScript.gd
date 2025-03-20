extends KinematicBody2D

var velocity : Vector2 = Vector2()
var direction: Vector2 = Vector2()
onready var sprite = $AnimatedSprite

onready var attack_area = $AttackArea
onready var attack_sound = $AttackSound
onready var move_sound = $MoveSound

var can_attack = true  # Controla si el jugador puede atacar
const ATTACK_COOLDOWN = 0.5

func _read_imput():
	velocity = Vector2()
	direction = Vector2.ZERO
	if Input.is_action_pressed("esc"):  # "ui_cancel" es la acción por defecto para Esc
		get_tree().quit()  # Cierra el juego
	if Input.is_action_pressed("up"): 
		velocity.y -= 1
		direction = Vector2(0,-1)
		sprite.play("up")
	if Input.is_action_pressed("down"): 
		velocity.y += 1
		direction = Vector2(0,1)
		sprite.play("down")
	if Input.is_action_pressed("left"): 
		velocity.x -= 1
		direction = Vector2(-1,0)
		sprite.play("left")
	if Input.is_action_pressed("right"): 
		velocity.x += 1
		direction = Vector2(1,0)
		sprite.play("right")
	if direction == Vector2.ZERO:
		sprite.play("idle")
		move_sound.stop()  # Detiene el sonido si no se mueve
	else:
		if not move_sound.playing:  # Solo reproducir si no está sonando
			move_sound.play()
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity*200)
	
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func attack():
	can_attack = false	
	sprite.play("down")
	attack_sound.play()  # Reproduce el sonido de ataque
	sprite.play("attack")  # Asegúrate de tener una animación de ataque
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage()
	yield(get_tree().create_timer(ATTACK_COOLDOWN), "timeout")
	can_attack = true
	attack_sound.stop()
	

func _physics_process(delta):
	_read_imput()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
