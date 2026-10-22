extends SceneTree

const GAME := "res://scenes/vila.tscn"
const REPORT := "user://resultado-aula09.json"
var checks: Array[Dictionary] = []
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, name: String) -> void:
	checks.append({"teste": name, "passou": condition})
	if not condition:
		failures += 1
	print(("PASS " if condition else "FAIL ") + name)

func frames(count := 3) -> void:
	for _i in range(count):
		await physics_frame
		await process_frame

func fresh(game) -> void:
	check(game.get_node("Jogador").vida == 3, "reinício: três vidas")
	check(is_equal_approx(game.get_node("Horda").wait_time, 2.0), "reinício: intervalo de horda 2 s")
	check(not game.get_node("Horda").is_stopped(), "reinício: horda ativa")
	check(not game.get_node("Relogio").is_stopped() and game.get_node("Relogio").time_left > 59.0, "reinício: relógio 60 s ativo")
	check(not game.partida_encerrada, "reinício: partida aberta")

func new_game():
	if is_instance_valid(current_scene):
		current_scene.free()
		current_scene = null
	var game = load(GAME).instantiate()
	root.add_child(game)
	current_scene = game
	fresh(game)
	game.get_node("Horda").stop()
	await frames()
	return game

func enemy(game, where: Vector2):
	var body = game.cena_inimigo.instantiate()
	game.add_child(body)
	body.global_position = where
	return body

func key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)

func restart():
	Input.action_press("ui_accept")
	await frames()
	Input.action_release("ui_accept")
	await frames()
	check(current_scene.scene_file_path == GAME, "Enter retorna à vila")
	fresh(current_scene)
	current_scene.get_node("Horda").stop()
	return current_scene

func run() -> void:
	for path in ["res://scenes/inicio.tscn", GAME, "res://entities/inimigo.tscn", "res://entities/jogador.tscn", "res://scenes/vitoria.tscn", "res://scenes/derrota.tscn"]:
		check(load(path) is PackedScene, "cena carregável: " + path)
	check(ProjectSettings.get_setting("application/run/main_scene") == "res://scenes/inicio.tscn", "menu é a cena principal")
	change_scene_to_file("res://scenes/inicio.tscn")
	await scene_changed
	key(KEY_ENTER, true)
	await frames()
	key(KEY_ENTER, false)
	await frames()
	check(current_scene.scene_file_path == GAME, "tecla Enter inicia partida pelo menu")
	for screen in ["inicio", "vitoria", "derrota"]:
		change_scene_to_file("res://scenes/" + screen + ".tscn")
		await scene_changed
		current_scene.get_node("Jogar").pressed.emit()
		await frames()
		check(current_scene.scene_file_path == GAME, "botão inicia ou reinicia: " + screen)
	var game = await new_game()
	var player = game.get_node("Jogador")
	check(player.is_in_group("player") and player.collision_layer == 2 and player.collision_mask == 1, "jogador: grupo e camadas")
	check(player.get_node("CollisionShape2D").shape != null, "jogador: colisor presente")
	var hurtbox: Area2D = player.get_node("Hurtbox")
	check(hurtbox.collision_layer == 0 and hurtbox.collision_mask == 4, "Hurtbox: camada e máscara")
	check(hurtbox.get_node("CollisionShape2D").shape is CircleShape2D and is_equal_approx(hurtbox.get_node("CollisionShape2D").shape.radius, 6.0), "Hurtbox: círculo de raio 6")
	var probe = enemy(game, Vector2(4000, 4000))
	probe.set_physics_process(false)
	check(probe.is_in_group("inimigo") and probe.collision_layer == 4 and probe.collision_mask == 5, "inimigo: grupo e camadas")
	check(is_equal_approx(probe.velocidade, 40.0), "inimigo: velocidade 40")
	var spawnpoints = game.get_node("Nascedouros").get_children()
	check(spawnpoints.size() == 4, "quatro nascedouros")
	for point in spawnpoints:
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = probe.get_node("CollisionShape2D").shape
		query.transform = Transform2D(0, point.global_position + probe.get_node("CollisionShape2D").position)
		query.collision_mask = 1
		check(game.get_world_2d().direct_space_state.intersect_shape(query).is_empty(), "nascedouro livre: " + point.name)
	probe.free()
	check(game.get_node("Horda").timeout.is_connected(Callable(game, "_on_horda_timeout")), "Horda timeout conectado")
	check(game.get_node("Relogio").timeout.is_connected(Callable(game, "_on_relogio_timeout")), "Relogio timeout conectado")
	check(game.get_node("HUD") is CanvasLayer and "3" in game.get_node("HUD/Vida").text and "Tempo:" in game.get_node("HUD/Tempo").text, "HUD fixo mostra vida e tempo")

	# Movimento real: eventos físicos de teclado, fora dos obstáculos do mapa.
	player.global_position = Vector2(4000, 4000)
	for pair in [[KEY_D, KEY_W], [KEY_RIGHT, KEY_UP]]:
		var start: Vector2 = player.global_position
		key(pair[0], true)
		await frames(4)
		check(player.global_position.x > start.x and is_equal_approx(player.velocity.length(), 70.0), "movimento horizontal: " + str(pair[0]))
		key(pair[1], true)
		await frames(4)
		check(player.velocity.x > 0 and player.velocity.y < 0 and absf(player.velocity.length() - 70.0) < 0.1, "diagonal normalizada: " + str(pair))
		key(pair[0], false)
		key(pair[1], false)
	await frames()
	check(player.velocity == Vector2.ZERO, "soltar teclas interrompe movimento")

	# Perseguição e colisão contra um corpo real da camada mundo.
	player.global_position = Vector2(4160, 4000)
	var chaser = enemy(game, Vector2(4000, 4000))
	await frames(8)
	check(chaser.global_position.x > 4000 and absf(chaser.velocity.length() - 40.0) < 0.1, "inimigo aproxima-se do jogador a 40")
	var wall := StaticBody2D.new()
	wall.collision_layer = 1
	wall.collision_mask = 0
	var wall_collision := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(8, 120)
	wall_collision.shape = rectangle
	wall.add_child(wall_collision)
	game.add_child(wall)
	wall.global_position = Vector2(4030, 4000)
	await create_timer(1.0).timeout
	check(chaser.global_position.x < 4026 and chaser.get_slide_collision_count() > 0, "mundo bloqueia perseguição")
	chaser.free()
	wall.free()

	# Um timeout real e a curva inteira de pressão, usando o sinal conectado.
	game.get_node("Horda").start()
	await create_timer(2.1).timeout
	check(get_nodes_in_group("inimigo").size() == 1 and absf(game.get_node("Horda").wait_time - 1.9) < 0.001, "timer gera primeiro inimigo e reduz intervalo")
	game.get_node("Horda").stop()
	for body in get_nodes_in_group("inimigo"):
		body.free()
	for _i in range(32):
		game.get_node("Horda").timeout.emit()
		for body in get_nodes_in_group("inimigo"):
			body.free()
	check(is_equal_approx(game.get_node("Horda").wait_time, 0.5), "horda alcança e respeita mínimo 0,5 s")

	# Dano vem da sobreposição física; retirar inimigo testa recuperação.
	player.global_position = Vector2(4000, 4000)
	var contact = enemy(game, player.global_position)
	contact.set_physics_process(false)
	await frames(5)
	check(player.vida == 2 and player.invencivel and absf(player.modulate.a - 0.4) < 0.01, "contato causa um dano e transparência")
	player.levar_dano()
	check(player.vida == 2, "invencibilidade bloqueia dano repetido")
	check("2" in game.get_node("HUD/Vida").text, "HUD acompanha perda de vida")
	contact.global_position += Vector2(100, 0)
	await create_timer(1.05).timeout
	await frames()
	check(not player.invencivel and is_equal_approx(player.modulate.a, 1.0), "após 1 s recupera alpha e vulnerabilidade")
	player.vida = 1
	contact.global_position = player.global_position
	await frames(6)
	check(current_scene.scene_file_path == "res://scenes/derrota.tscn", "sobreposição com última vida causa derrota")
	game = await restart()
	# Primeiro encerramento no mesmo turno prevalece sobre o segundo.
	game.get_node("Jogador").vida = 1
	game.get_node("Jogador").levar_dano()
	game.vencer()
	game.get_node("Horda").timeout.emit()
	check(game.partida_encerrada and game.get_node("Horda").is_stopped() and game.get_node("Relogio").is_stopped() and get_nodes_in_group("inimigo").is_empty(), "encerrar para timers e bloqueia spawn")
	await frames()
	check(current_scene.scene_file_path == "res://scenes/derrota.tscn", "derrota não é sobrescrita por vitória no mesmo turno")
	game = await restart()
	game.get_node("Relogio").timeout.emit()
	game.perder()
	await frames()
	check(current_scene.scene_file_path == "res://scenes/vitoria.tscn", "Relogio vence e segundo encerramento é ignorado")
	await restart()
	var report := {"total": checks.size(), "falhas": failures, "testes": checks}
	var file := FileAccess.open(REPORT, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("RESULTADO: %d testes; %d falhas" % [checks.size(), failures])
	quit(1 if failures > 0 else 0)
