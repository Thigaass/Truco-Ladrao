extends Node2D
@onready var baralho_node = $Baralho
@onready var musica: AudioStreamPlayer = $Musica
var container_rodada: Node2D
var E: int = 0
var W: int = 0
var L: int = 0
var valor: int = 0
var valor2: int = 0
var cartas_jogadas: int = 0
var areas_bot: Array[Area2D] = []
var cartas_bot: Array[Carta] = []
var sprites_bot: Array[Sprite2D] = []
var ponto: int = 1
var pponto: int = 0
var bponto: int = 0
var rodfim: bool = false
var botaoproxrodada: TextureButton
var BotaoTruco: TextureButton
var BotaoPoder: TextureButton
var placar_sprite: Sprite2D
var placar_player: Sprite2D
var placar_bot: Sprite2D
var truco: int = 0
var primeiramao: int = 0
var aguard_bot: bool = false
var carta_troca: Carta
var area_troca: Area2D
func _ready() -> void:
	Globais.musica = musica
	if musica.stream == null:
		musica.stream = load("res://sprites/Sons/Baroes do autismo(ver1).wav")
	musica.finished.connect(func(): musica.play())
	musica.play()
	criar_fundo()
	container_rodada = Node2D.new()
	add_child(container_rodada)
	baralho_node.criarBaralho()
	criar_botao()
	criar_placar()
	turno()
func _exit_tree() -> void:
	if is_instance_valid(musica):
		musica.stop()
func criar_fundo() -> void:
	var camada = CanvasLayer.new()
	camada.layer = -1
	add_child(camada)
	var fundo = TextureRect.new()
	fundo.texture = load("res://sprites/PlaceHolders/cenario.png")
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fundo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fundo.stretch_mode = TextureRect.STRETCH_SCALE
	fundo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	camada.add_child(fundo)
func criar_botao() -> void:
	BotaoTruco = TextureButton.new()
	BotaoPoder = TextureButton.new()
	
	atualizar_botao_truco()
	BotaoTruco.position = Vector2(750, 950)
	Globais.sprite_poder(BotaoPoder)
	
	BotaoTruco.pressed.connect(trucar)
	BotaoPoder.pressed.connect(usar_poder)
	
	add_child(BotaoTruco)
	add_child(BotaoPoder)
func atualizar_botao_truco() -> void:
	var tex_normal: Texture2D
	var tex_pressed: Texture2D
	match truco:
		0:
			tex_normal = load("res://sprites/GUI/BotaoTruco/Botao3AntesdeAperta.png")
			tex_pressed = load("res://sprites/GUI/BotaoTruco/Botao3Apertado.png")
		1:
			tex_normal = load("res://sprites/GUI/BotaoTruco/Botao6AntesdeApertar.png")
			tex_pressed = load("res://sprites/GUI/BotaoTruco/Botao6Apertado.png")
		2:
			tex_normal = load("res://sprites/GUI/BotaoTruco/Botao9AntesdeApertar.png")
			tex_pressed = load("res://sprites/GUI/BotaoTruco/Botao9Apertado.png")
		3:
			tex_normal = load("res://sprites/GUI/BotaoTruco/Botao12AntesdeApertar.png")
			tex_pressed = load("res://sprites/GUI/BotaoTruco/Botao12Apertado.png")
		_:
			tex_normal = load("res://sprites/GUI/BotaoTruco/Botao12Apertado.png")
			tex_pressed = load("res://sprites/GUI/BotaoTruco/Botao12Apertado.png")
	BotaoTruco.texture_normal = tex_normal
	BotaoTruco.texture_hover = tex_normal
	BotaoTruco.texture_pressed = tex_pressed
	BotaoTruco.texture_disabled = tex_pressed
func criar_placar() -> void:
	placar_sprite = Sprite2D.new()
	placar_sprite.texture = load("res://sprites/GUI/Numeros/Placar.png")
	placar_sprite.position = Vector2(345, 210)
	placar_sprite.scale = Vector2(2.0, 2.0)
	add_child(placar_sprite)
	
	placar_player = Sprite2D.new()
	placar_player.position = Vector2(-69, -12)
	placar_sprite.add_child(placar_player)
	
	placar_bot = Sprite2D.new()
	placar_bot.position = Vector2(56, -12)
	placar_sprite.add_child(placar_bot)
	
	atualizar_placar()
func atualizar_placar() -> void:
	if pponto > 0:
		placar_player.texture = load("res://sprites/GUI/Numeros/%02d.png" % clampi(pponto, 1, 12))
		placar_player.visible = true
	else:
		placar_player.visible = false
	if bponto > 0:
		placar_bot.texture = load("res://sprites/GUI/Numeros/%02d.png" % clampi(bponto, 1, 12))
		placar_bot.visible = true
	else:
		placar_bot.visible = false
func usar_poder() -> void:
	if rodfim or aguard_bot or Globais.poder_us or Globais.arg_carta or Globais.arg_troca:
		return
	Globais.poder()
	if Globais.poder_esc in [1, 2]:
		BotaoPoder.disabled = true
func turno() -> void:
	Globais.distribuir()
	for i in range(3):
		var carta = Globais.maoP[i]
		var area = Area2D.new()
		area.input_pickable = true
		area.collision_layer = 1
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(0.45, 0.45)
		sprite.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")
		area.add_child(sprite)
		var colisao = CollisionShape2D.new()
		var forma = RectangleShape2D.new()
		forma.size = sprite.texture.get_size() * sprite.scale
		colisao.shape = forma
		area.add_child(colisao)
		area.position = Vector2(775 + i *170, 850)
		area.set_meta("carta", carta)
		area.input_event.connect(carta_clicada.bind(area))
		container_rodada.add_child(area)
	for j in range(3):
		var carta2 = Globais.maoO[j]
		var area2 = Area2D.new()
		area2.input_pickable = true
		area2.collision_layer = 1
		var sprite2 = Sprite2D.new()
		sprite2.scale = Vector2(0.45, 0.45)
		sprite2.texture = load("res://sprites/cartas/Verso.png")
		area2.add_child(sprite2)
		var colisao2 = CollisionShape2D.new()
		var forma2 = RectangleShape2D.new()
		forma2.size = sprite2.texture.get_size() * sprite2.scale
		colisao2.shape = forma2
		area2.add_child(colisao2)
		area2.set_meta("carta", carta2)
		area2.input_event.connect(bot_carta_clicada.bind(area2))
		area2.position = Vector2(775 + j * 170, 200)
		container_rodada.add_child(area2)
		areas_bot.append(area2)
		cartas_bot.append(carta2)
		sprites_bot.append(sprite2)
func carta_clicada(
	viewport: Node,
	event: InputEvent,
	shape_idx: int,
	area: Area2D
	) -> void:
	if rodfim:
		return
	if  not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	if aguard_bot:
		return
	var carta: Carta = area.get_meta("carta")
	if Globais.arg_carta:
		carta.valor += 1
		var indicador = Sprite2D.new()
		indicador.texture = load("res://sprites/PlaceHolders/Poder_1.png")
		indicador.scale = Vector2 (0.03, 0.03)
		indicador.position = Vector2 (-60, -30)
		indicador.z_index = 1
		area.add_child(indicador)
		Globais.arg_carta = false
		Globais.poder_us = true
		return
	if Globais.arg_troca:
		carta_troca = carta
		area_troca = area
		aguard_bot = true
		Globais.arg_troca = false
		return
	area.input_pickable = false
	cartas_jogadas += 1
	area.position = Vector2(485 + cartas_jogadas * 150, 525)
	valor = carta.valor
	Globais.maoP.erase(carta)
	BotTurno()
	return
func BotTurno() -> void:
	if cartas_bot.is_empty():
			return
	var carta: Carta = cartas_bot[0]
	var area2: Area2D = areas_bot[0]
	var sprite2: Sprite2D = sprites_bot[0]
	area2.input_pickable = false
	valor2 = carta.valor
	cartas_jogadas +=1
	sprite2.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")
	area2.position = Vector2(370 + cartas_jogadas * 150, 525)
	Globais.maoO.erase(carta)
	cartas_bot.remove_at(0)
	areas_bot.remove_at(0)
	sprites_bot.remove_at(0)
	checar()
	winner()
	return
func bot_carta_clicada(
	viewport: Node,
	event: InputEvent,
	shape_idx: int,
	area_bot: Area2D
) -> void:
	if rodfim or not aguard_bot:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	var carta_bot: Carta = area_bot.get_meta("carta")
	var indice_jogador = Globais.maoP.find(carta_troca)
	var indice_bot = cartas_bot.find(carta_bot)
	var indice_mao_bot = Globais.maoO.find(carta_bot)
	if indice_jogador == -1 or indice_bot == -1 or indice_mao_bot == -1:
		return
	Globais.maoP[indice_jogador] = carta_bot
	Globais.maoO[indice_mao_bot] = carta_troca
	cartas_bot[indice_bot] = carta_troca
	area_troca.set_meta("carta", carta_bot)
	area_bot.set_meta("carta", carta_troca)
	var sprite = area_troca.get_child(0) as Sprite2D
	sprite.texture = load("res://sprites/cartas/" + carta_bot.num + "_" + carta_bot.naipe + ".png")
	aguard_bot = false
	carta_troca = null
	area_troca = null
	Globais.poder_us = true
func checar() -> void:
	var wel_sprite = Sprite2D.new()
	var mao_idx := int(cartas_jogadas / 2.0)
	if valor > valor2:
		W += 1
		wel_sprite.texture = load("res://sprites/PlaceHolders/Win.png")
	elif valor2 > valor:
		L += 1
		wel_sprite.texture = load("res://sprites/PlaceHolders/Loss.png")
	else:
		E += 1
		wel_sprite.texture = load("res://sprites/PlaceHolders/Emp.png")
	wel_sprite.position = Vector2(380 + mao_idx * 290, 690)
	if cartas_jogadas == 2 and primeiramao == 0:
		if W > 0:
			primeiramao = 1
		elif L > 0:
			primeiramao = 2
	container_rodada.add_child(wel_sprite)
	return
func winner() -> void:
	if W == 2:
		pponto += ponto
		atualizar_placar()
		rodfim = true
		cabo()
		return
	elif L == 2:
		bponto += ponto
		atualizar_placar()
		rodfim = true
		cabo()
		return
	elif cartas_jogadas == 4 and E == 1:
		if W > L:
			pponto += ponto
		else:
			bponto += ponto
		atualizar_placar()
		rodfim = true
		cabo()
		return
	elif cartas_jogadas == 6:
		if W > L:
			pponto += ponto
		elif L > W:
			bponto += ponto
		elif primeiramao == 1:
			pponto += ponto
		elif primeiramao == 2:
			bponto += ponto
		atualizar_placar()
		rodfim = true
		cabo()
		return
func cabo() -> void:
	rodfim = true
	BotaoPoder.disabled = true
	BotaoTruco.disabled = true
	if pponto >= 12 or bponto >= 12:
		Globais.arg_carta = false
		Globais.arg_troca = false
		Globais.poder_us = false
		await get_tree().create_timer(1.5).timeout
		if is_inside_tree():
			get_tree().change_scene_to_file("res://menu.tscn")
		return
	botaoproxrodada = TextureButton.new()
	botaoproxrodada.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.position = Vector2 (1400, 500)
	botaoproxrodada.pressed.connect(proxrodada)
	add_child(botaoproxrodada)
func proxrodada() -> void:
	botaoproxrodada.queue_free()
	botaoproxrodada = null
	BotaoPoder.disabled = false
	BotaoTruco.disabled = false
	Globais.arg_carta = false
	Globais.arg_troca = false
	aguard_bot = false
	carta_troca = null
	area_troca = null
	Globais.poder_us = false
	W = 0
	E = 0
	L = 0
	primeiramao = 0
	cartas_jogadas = 0
	valor = 0 
	valor2 = 0
	truco = 0
	ponto = 1
	atualizar_botao_truco()
	areas_bot.clear()
	cartas_bot.clear()
	sprites_bot.clear()
	for filho in container_rodada.get_children():
		filho.queue_free()
	rodfim = false
	turno()
func trucar() -> void:
	if truco >= 4:
		return
	truco += 1
	ponto = 3 * truco
	atualizar_botao_truco()
	if truco == 4:
		BotaoTruco.disabled = true
		return
