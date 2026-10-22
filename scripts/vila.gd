extends Node2D

@export var cena_inimigo: PackedScene

var partida_encerrada := false
var duracao_partida := 60.0

@onready var horda: Timer = $Horda
@onready var relogio: Timer = $Relogio
@onready var jogador = $Jogador
@onready var texto_vida: Label = $HUD/Vida
@onready var texto_tempo: Label = $HUD/Tempo
@onready var progresso: Range = get_node_or_null("HUD/Progresso") as Range

func _ready() -> void:
	# A duração pode ser mudada no Timer da cena (180 para três minutos).
	duracao_partida = relogio.wait_time
	if progresso != null:
		progresso.max_value = duracao_partida
	_atualizar_placar()

func _process(_delta: float) -> void:
	if not partida_encerrada:
		_atualizar_placar()

func _atualizar_placar() -> void:
	texto_vida.text = "Vida: %d / 3" % jogador.vida
	texto_tempo.text = "Tempo: %d s" % int(ceil(relogio.time_left))
	if progresso != null:
		progresso.value = duracao_partida - relogio.time_left

func _on_horda_timeout() -> void:
	if partida_encerrada:
		return
	var nascedouro := $Nascedouros.get_children().pick_random() as Node2D
	var inimigo := cena_inimigo.instantiate() as Node2D
	add_child(inimigo)
	inimigo.global_position = nascedouro.global_position
	# Cada inimigo chega um pouco antes; o intervalo mínimo é meio segundo.
	horda.wait_time = maxf(0.5, horda.wait_time * 0.95)

func _on_relogio_timeout() -> void:
	vencer()

func vencer() -> void:
	_encerrar_partida("res://scenes/vitoria.tscn")

func perder() -> void:
	_encerrar_partida("res://scenes/derrota.tscn")

func _encerrar_partida(caminho: String) -> void:
	if partida_encerrada:
		return
	partida_encerrada = true
	horda.stop()
	relogio.stop()
	# Troca só no fim do quadro, depois que a física terminar.
	get_tree().change_scene_to_file.call_deferred(caminho)
