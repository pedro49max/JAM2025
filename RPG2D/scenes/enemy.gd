extends KinematicBody2D

export var speed = 50  # Velocidad del enemigo
export var health = 3  # Vida del enemigo
onready var player = get_node("../Player")  # Referencia al jugador
onready var sprite = $AnimatedSprite
onready var golpe_sound = $golpe
onready var muerte_sound = $Muerte
func _physics_process(delta):
	sprite.play("default")
	if player:
		var direction = (player.position - position).normalized()
		move_and_slide(direction * speed)

func take_damage():
	health -= 1
	if health <= 0:
		muerte_sound.play()
		yield(get_tree().create_timer(1), "timeout")
		queue_free()  # Elimina al enemigo al morir
	else:
		golpe_sound.play()
