extends CharacterBody2D

@export var velocidade: float = 40.0

var tempo_animacao := 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	# A faixa do pacote tem oito quadros de corrida, exibidos a oito por segundo.
	tempo_animacao += delta
	sprite.frame = int(tempo_animacao * 8.0) % sprite.hframes

func _physics_process(_delta: float) -> void:
	var jogador := get_tree().get_first_node_in_group("player") as Node2D
	if jogador == null:
		return
	# Persegue em linha reta; casas, muros e outros inimigos bloqueiam o corpo.
	velocity = global_position.direction_to(jogador.global_position) * velocidade
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	move_and_slide()
