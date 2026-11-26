extends Node2D

# Nós da cena
@onready var baralho_node: Node2D = $Baralho
@onready var musica: AudioStreamPlayer = $Musica

# Containers e elementos de interface
var container_rodada: Node2D
var BotaoTruco: TextureButton
var BotaoPoder: TextureButton
var botaoproxrodada: TextureButton
var placar_sprite: Sprite2D
var placar_player: Sprite2D
var placar_bot: Sprite2D
var status_label: Label
var cache_truco: Dictionary = {}

# Estado da partida e placar
var pponto: int = 0
var bponto: int = 0
var ponto: int = 1
var truco: int = 0
var jogador_comeca_mao: bool = true

# Estado da rodada atual
var W: int = 0
var L: int = 0
var E: int = 0
var valor: int = 0
var valor2: int = 0
var cartas_jogadas: int = 0
var primeiramao: int = 0
var vaza_atual: int = 0
var cartas_na_vaza: int = 0
var jogador_comecou_vaza: bool = true
var vez_do_jogador: bool = true
var bot_pensando: bool = false
var rodada_id: int = 0
var rodfim: bool = false
var animando_poder: bool = false

# Cartas do bot na mesa
var areas_bot: Array[Area2D] = []
var cartas_bot: Array[Carta] = []
var sprites_bot: Array[Sprite2D] = []

# Estado de troca (poder 2)
var aguard_bot: bool = false
var carta_troca: Carta
var area_troca: Area2D


#region Ciclo de Vida

func _ready() -> void:
	Globais.resetar_poderes()
	jogador_comeca_mao = Globais.jogador_comeca_proxima_partida
	Globais.jogador_comeca_proxima_partida = not Globais.jogador_comeca_proxima_partida

	if musica.stream == null:
		musica.stream = load("res://sprites/Sons/Baroes do autismo(ver1).wav")
	musica.finished.connect(func():
		if is_inside_tree():
			musica.play()
	)
	musica.play()

	criar_fundo()
	container_rodada = Node2D.new()
	add_child(container_rodada)

	baralho_node.criarBaralho()
	criar_botao()
	criar_placar()
	criar_status_label()
	turno()


func _exit_tree() -> void:
	if is_instance_valid(musica):
		musica.stop()

#endregion


#region Interface (Fundo, Botões e Placar)

func criar_fundo() -> void:
	var camada := CanvasLayer.new()
	camada.layer = -1
	add_child(camada)

	var fundo := TextureRect.new()
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
	BotaoTruco.ignore_texture_size = true
	BotaoTruco.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	BotaoTruco.custom_minimum_size = Vector2(290, 290)
	BotaoTruco.size = Vector2(290, 290)
	BotaoTruco.scale = Vector2.ONE

	Globais.sprite_poder(BotaoPoder)
	posicionar_botoes()
	get_viewport().size_changed.connect(posicionar_botoes)
	atualizar_visual_botao_poder()

	BotaoTruco.pressed.connect(trucar)
	BotaoPoder.pressed.connect(usar_poder)

	add_child(BotaoTruco)
	add_child(BotaoPoder)


func posicionar_botoes() -> void:
	if not is_instance_valid(BotaoTruco) or not is_instance_valid(BotaoPoder):
		return

	var altura_viewport: float = get_viewport_rect().size.y
	var centro_y: float = clampf(altura_viewport - 96.0, 1045.0, 1125.0)
	BotaoTruco.position = Vector2(704.0, centro_y - 148.0)
	BotaoPoder.position = Vector2(933.0, centro_y - 127.0)


func atualizar_botao_truco() -> void:
	var nivel: int = mini(truco, 4)
	if not cache_truco.has(nivel):
		var tex_normal: Texture2D
		var tex_pressed: Texture2D

		match nivel:
			0:
				tex_normal = load("res://sprites/GUI/BotaoTruco/Botao3AntesdeApertar.png")
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

		var mascara: BitMap = Globais.criar_mascara_alpha(tex_normal)

		cache_truco[nivel] = {
			"normal": tex_normal,
			"pressed": tex_pressed,
			"mask": mascara,
		}

	var dados: Dictionary = cache_truco[nivel]
	BotaoTruco.texture_normal = dados["normal"]
	BotaoTruco.texture_hover = dados["normal"]
	BotaoTruco.texture_pressed = dados["pressed"]
	BotaoTruco.texture_disabled = dados["pressed"]
	BotaoTruco.texture_click_mask = dados["mask"]


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
	placar_player.texture = load("res://sprites/GUI/Numeros/%02d.png" % clampi(pponto, 0, 12))
	placar_player.visible = true

	placar_bot.texture = load("res://sprites/GUI/Numeros/%02d.png" % clampi(bponto, 0, 12))
	placar_bot.visible = true


func criar_status_label() -> void:
	status_label = Label.new()
	status_label.position = Vector2(460, 35)
	status_label.size = Vector2(1000, 48)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_label.add_theme_font_size_override("font_size", 28)
	status_label.add_theme_color_override("font_color", Color.WHITE)
	status_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	status_label.add_theme_constant_override("outline_size", 6)
	add_child(status_label)

#endregion


#region Fluxo da Rodada

func turno() -> void:
	Globais.distribuir()

	vaza_atual = 0
	cartas_na_vaza = 0
	bot_pensando = false
	jogador_comecou_vaza = jogador_comeca_mao
	vez_do_jogador = jogador_comeca_mao

	if pponto >= 11 or bponto >= 11:
		BotaoTruco.disabled = true

	# Cartas do jogador
	for i in range(3):
		var carta := Globais.maoP[i]
		var area := Area2D.new()
		area.input_pickable = true
		area.collision_layer = 1

		var sprite := Sprite2D.new()
		sprite.scale = Vector2(0.45, 0.45)
		sprite.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")
		area.add_child(sprite)

		var colisao := CollisionShape2D.new()
		var forma := RectangleShape2D.new()
		forma.size = sprite.texture.get_size() * sprite.scale
		colisao.shape = forma
		area.add_child(colisao)

		area.position = Vector2(775 + i * 170, 850)
		area.set_meta("carta", carta)
		area.set_meta("sprite", sprite)
		area.input_event.connect(carta_clicada.bind(area))
		container_rodada.add_child(area)

	# Cartas do bot
	for j in range(3):
		var carta2 := Globais.maoO[j]
		var area2 := Area2D.new()
		area2.input_pickable = true
		area2.collision_layer = 1

		var sprite2 := Sprite2D.new()
		sprite2.scale = Vector2(0.45, 0.45)
		sprite2.texture = load("res://sprites/cartas/Verso.png")
		area2.add_child(sprite2)

		var colisao2 := CollisionShape2D.new()
		var forma2 := RectangleShape2D.new()
		forma2.size = sprite2.texture.get_size() * sprite2.scale
		colisao2.shape = forma2
		area2.add_child(colisao2)

		area2.set_meta("carta", carta2)
		area2.set_meta("sprite", sprite2)
		area2.input_event.connect(bot_carta_clicada.bind(area2))
		area2.position = Vector2(775 + j * 170, 200)
		container_rodada.add_child(area2)

		areas_bot.append(area2)
		cartas_bot.append(carta2)
		sprites_bot.append(sprite2)

	atualizar_visual_botao_poder()
	if vez_do_jogador:
		status_label.text = "Você começa esta mão!"
	else:
		status_label.text = "O bot começa esta mão!"
		agendar_jogada_bot(1.1)


func obter_posicao_carta_mesa(ordem_na_vaza: int) -> Vector2:
	var deslocamento_x: float = 0.0 if ordem_na_vaza == 1 else 35.0
	return Vector2(635.0 + float(vaza_atual) * 300.0 + deslocamento_x, 525.0)


func agendar_jogada_bot(atraso: float = 0.9) -> void:
	bot_pensando = true
	atualizar_visual_botao_poder()
	var id_atual: int = rodada_id
	await get_tree().create_timer(atraso).timeout
	if not is_inside_tree() or rodfim or id_atual != rodada_id:
		bot_pensando = false
		return
	bot_pensando = false
	BotTurno()


func checar() -> int:
	var wel_sprite := Sprite2D.new()
	var resultado: int = 0

	if valor > valor2:
		W += 1
		resultado = 1
		wel_sprite.texture = load("res://sprites/PlaceHolders/Win.png")
	elif valor2 > valor:
		L += 1
		resultado = 2
		wel_sprite.texture = load("res://sprites/PlaceHolders/Loss.png")
	else:
		E += 1
		wel_sprite.texture = load("res://sprites/PlaceHolders/Emp.png")

	wel_sprite.position = Vector2(380 + (vaza_atual + 1) * 290, 690)

	if vaza_atual == 0 and primeiramao == 0:
		if W > 0:
			primeiramao = 1
		elif L > 0:
			primeiramao = 2

	container_rodada.add_child(wel_sprite)
	return resultado


func finalizar_vaza() -> void:
	var resultado: int = checar()
	var proximo_jogador: bool = jogador_comecou_vaza
	if resultado == 1:
		proximo_jogador = true
	elif resultado == 2:
		proximo_jogador = false

	vaza_atual += 1
	cartas_na_vaza = 0
	valor = 0
	valor2 = 0

	winner()
	if rodfim:
		return

	jogador_comecou_vaza = proximo_jogador
	vez_do_jogador = proximo_jogador
	atualizar_visual_botao_poder()

	if vez_do_jogador:
		status_label.text = "Você ganhou a rodada! Sua vez." if resultado == 1 else "Empate! Sua vez de começar."
	else:
		status_label.text = "Bot ganhou a rodada! Vez do bot..." if resultado == 2 else "Empate! Vez do bot..."
		agendar_jogada_bot(1.1)


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
	atualizar_visual_botao_poder()

	if pponto >= 12 or bponto >= 12:
		Globais.resetar_poderes()
		status_label.text = "Você venceu a partida!" if pponto >= 12 else "O bot venceu a partida!"
		await get_tree().create_timer(2.0).timeout
		if is_inside_tree():
			get_tree().change_scene_to_file("res://menu.tscn")
		return

	botaoproxrodada = TextureButton.new()
	botaoproxrodada.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.position = Vector2(1400, 500)
	botaoproxrodada.pressed.connect(proxrodada)
	add_child(botaoproxrodada)


func proxrodada() -> void:
	if not is_instance_valid(botaoproxrodada):
		return

	rodada_id += 1
	botaoproxrodada.disabled = true
	botaoproxrodada.queue_free()
	botaoproxrodada = null

	Globais.resetar_poderes()
	animando_poder = false
	bot_pensando = false
	aguard_bot = false
	carta_troca = null
	area_troca = null
	status_label.text = ""

	W = 0
	E = 0
	L = 0
	primeiramao = 0
	cartas_jogadas = 0
	vaza_atual = 0
	cartas_na_vaza = 0
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
	jogador_comeca_mao = not jogador_comeca_mao
	BotaoTruco.disabled = pponto >= 11 or bponto >= 11
	atualizar_visual_botao_poder()
	turno()

#endregion


#region Ações de Jogo (Cartas, Bot e Truco)

func carta_clicada(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int,
	area: Area2D
) -> void:
	if rodfim or animando_poder or bot_pensando:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	if not vez_do_jogador:
		return
	if aguard_bot or Globais.arg_carta_bot or Globais.arg_revelar:
		return

	var carta: Carta = area.get_meta("carta")

	# Poder 1: aumentar valor da carta do jogador
	if Globais.arg_carta:
		var sprite_carta := area.get_meta("sprite") as Sprite2D
		if sprite_carta == null:
			return

		carta.valor += 1
		var tex_antigo: Texture2D = sprite_carta.texture

		Globais.arg_carta = false
		Globais.poder_us = true
		animando_poder = true
		status_label.text = ""
		atualizar_visual_botao_poder()

		if carta.valor > 14:
			var tween := animar_poder_carta(area, sprite_carta, tex_antigo, null)
			tween.finished.connect(func():
				animando_poder = false
				if not is_instance_valid(area):
					return
				adicionar_indicador_poder(area, "res://sprites/GUI/BotaoPoder/Poder_1.png")
			)
		else:
			var caminho_novo: String = obter_caminho_sprite_por_valor(carta.valor, carta.naipe)
			var tex_novo: Texture2D = load(caminho_novo) if caminho_novo != "" else null
			var tween := animar_poder_carta(area, sprite_carta, tex_antigo, tex_novo)
			tween.finished.connect(func():
				animando_poder = false
			)
		return

	# Poder 2: selecionar carta do jogador para trocar com o bot
	if Globais.arg_troca:
		carta_troca = carta
		area_troca = area
		aguard_bot = true
		Globais.arg_troca = false
		status_label.text = "Escolha uma carta do bot para trocar (ou clique no poder para cancelar)"
		atualizar_visual_botao_poder()
		return

	# Jogada normal
	area.input_pickable = false
	cartas_jogadas += 1
	cartas_na_vaza += 1
	area.position = obter_posicao_carta_mesa(cartas_na_vaza)
	area.z_index = cartas_na_vaza - 1
	valor = carta.valor
	Globais.maoP.erase(carta)
	vez_do_jogador = false
	atualizar_visual_botao_poder()

	if cartas_na_vaza == 1:
		agendar_jogada_bot(0.9)
	else:
		finalizar_vaza()


func escolher_indice_bot() -> int:
	if cartas_na_vaza == 1:
		var melhor_ganhadora: int = -1
		var melhor_empate: int = -1
		var menor_carta: int = 0

		for i in range(cartas_bot.size()):
			var v: int = cartas_bot[i].valor
			if v > valor:
				if melhor_ganhadora == -1 or v < cartas_bot[melhor_ganhadora].valor:
					melhor_ganhadora = i
			elif v == valor and melhor_empate == -1:
				melhor_empate = i
			if v < cartas_bot[menor_carta].valor:
				menor_carta = i

		if melhor_ganhadora != -1:
			return melhor_ganhadora
		if melhor_empate != -1:
			return melhor_empate
		return menor_carta

	if vaza_atual == 1 and L == 1:
		var maior_carta: int = 0
		for i in range(1, cartas_bot.size()):
			if cartas_bot[i].valor > cartas_bot[maior_carta].valor:
				maior_carta = i
		return maior_carta

	return randi() % cartas_bot.size()


func BotTurno() -> void:
	if cartas_bot.is_empty() or rodfim:
		return

	var idx: int = escolher_indice_bot()
	var carta: Carta = cartas_bot[idx]
	var area2: Area2D = areas_bot[idx]
	var sprite2: Sprite2D = sprites_bot[idx]
	area2.input_pickable = false
	valor2 = carta.valor
	cartas_jogadas += 1
	cartas_na_vaza += 1
	sprite2.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")

	if area2.get_meta("poder3_aplicado", false):
		adicionar_indicador_poder(area2, "res://sprites/GUI/BotaoPoder/Poder_3.png")

	area2.position = obter_posicao_carta_mesa(cartas_na_vaza)
	area2.z_index = cartas_na_vaza - 1

	Globais.maoO.erase(carta)
	cartas_bot.remove_at(idx)
	areas_bot.remove_at(idx)
	sprites_bot.remove_at(idx)

	if cartas_na_vaza == 1:
		vez_do_jogador = true
		status_label.text = "Sua vez de responder!"
		atualizar_visual_botao_poder()
	else:
		finalizar_vaza()


func bot_carta_clicada(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int,
	area_bot: Area2D
) -> void:
	if rodfim or animando_poder or bot_pensando or not vez_do_jogador:
		return
	if not aguard_bot and not Globais.arg_carta_bot and not Globais.arg_revelar:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	var carta_bot: Carta = area_bot.get_meta("carta")

	# Poder 4: revelar carta do bot
	if Globais.arg_revelar:
		var indice_revelar: int = cartas_bot.find(carta_bot)
		if indice_revelar == -1:
			return
		sprites_bot[indice_revelar].texture = load("res://sprites/cartas/" + carta_bot.num + "_" + carta_bot.naipe + ".png")
		Globais.arg_revelar = false
		Globais.poder_us = true
		status_label.text = ""
		atualizar_visual_botao_poder()
		return

	# Poder 3: diminuir valor da carta do bot
	if Globais.arg_carta_bot:
		if not cartas_bot.has(carta_bot):
			return
		var sprite_bot := area_bot.get_meta("sprite") as Sprite2D
		if sprite_bot == null:
			return

		carta_bot.valor = maxi(carta_bot.valor - 1, 0)
		area_bot.set_meta("poder3_aplicado", true)

		Globais.arg_carta_bot = false
		Globais.poder_us = true
		animando_poder = true
		status_label.text = ""
		atualizar_visual_botao_poder()

		var tween := animar_poder_carta(area_bot, sprite_bot, sprite_bot.texture, null)
		tween.finished.connect(func():
			animando_poder = false
		)
		return

	# Poder 2: concluir troca de carta com o bot
	var indice_jogador: int = Globais.maoP.find(carta_troca)
	var indice_bot: int = cartas_bot.find(carta_bot)
	var indice_mao_bot: int = Globais.maoO.find(carta_bot)
	if indice_jogador == -1 or indice_bot == -1 or indice_mao_bot == -1:
		return

	var sprite_troca := area_troca.get_meta("sprite") as Sprite2D
	if sprite_troca == null:
		return

	Globais.maoP[indice_jogador] = carta_bot
	Globais.maoO[indice_mao_bot] = carta_troca
	cartas_bot[indice_bot] = carta_troca
	area_troca.set_meta("carta", carta_bot)
	area_bot.set_meta("carta", carta_troca)

	sprite_troca.texture = load("res://sprites/cartas/" + carta_bot.num + "_" + carta_bot.naipe + ".png")

	aguard_bot = false
	carta_troca = null
	area_troca = null
	Globais.poder_us = true
	status_label.text = ""
	atualizar_visual_botao_poder()


func trucar() -> void:
	if rodfim or animando_poder or bot_pensando or not vez_do_jogador or aguard_bot or Globais.poder_ativo():
		return
	if truco >= 4 or pponto >= 11 or bponto >= 11:
		return

	var proximo_nivel: int = truco + 1
	if bot_aceita_truco(proximo_nivel):
		truco = proximo_nivel
		ponto = 3 * truco
		atualizar_botao_truco()
		status_label.text = "Bot aceitou! Rodada vale %d pontos." % ponto
		if truco == 4:
			BotaoTruco.disabled = true
	else:
		pponto += ponto
		atualizar_placar()
		status_label.text = "Bot correu! Você ganhou %d ponto(s)." % ponto
		cabo()


func bot_aceita_truco(proximo_nivel: int) -> bool:
	var valores_bot: Array[int] = []
	for carta in cartas_bot:
		valores_bot.append(carta.valor)
	if cartas_na_vaza == 1 and not jogador_comecou_vaza:
		valores_bot.append(valor2)

	if valores_bot.is_empty():
		return false

	var maior_valor: int = 0
	var soma_valores: int = 0
	for v in valores_bot:
		maior_valor = maxi(maior_valor, v)
		soma_valores += v

	var media: float = float(soma_valores) / float(valores_bot.size())
	var pontuacao_mao: float = float(maior_valor) * 0.65 + media * 0.35
	var limiar: float = 6.5 + float(proximo_nivel - 1) * 1.5
	var variacao: float = randf_range(-1.2, 1.2)
	return pontuacao_mao + variacao >= limiar

#endregion


#region Poderes e Animações

func usar_poder() -> void:
	if rodfim or animando_poder or bot_pensando or not vez_do_jogador or Globais.poder_us:
		return
	if Globais.poder_esc in [2, 3, 4] and cartas_bot.is_empty():
		return

	if Globais.poder_ativo() or aguard_bot:
		Globais.cancelar_poder()
		aguard_bot = false
		carta_troca = null
		area_troca = null
		status_label.text = ""
		atualizar_visual_botao_poder()
		return

	Globais.poder()
	match Globais.poder_esc:
		1:
			status_label.text = "Escolha uma carta sua para aumentar +1 (ou clique no poder para cancelar)"
		2:
			status_label.text = "Escolha uma carta sua para trocar com o bot (ou clique no poder para cancelar)"
		3:
			status_label.text = "Escolha uma carta do bot para diminuir -1 (ou clique no poder para cancelar)"
		4:
			status_label.text = "Escolha uma carta do bot para revelar (ou clique no poder para cancelar)"
	atualizar_visual_botao_poder()


func atualizar_visual_botao_poder() -> void:
	if not is_instance_valid(BotaoPoder):
		return

	var sem_alvo_bot: bool = Globais.poder_esc in [2, 3, 4] and cartas_bot.is_empty()
	if Globais.poder_esc not in [1, 2, 3, 4] or rodfim or Globais.poder_us or bot_pensando or not vez_do_jogador or sem_alvo_bot:
		BotaoPoder.disabled = true
		BotaoPoder.modulate = Color(0.45, 0.45, 0.45, 0.6)
	elif Globais.poder_ativo() or aguard_bot:
		BotaoPoder.disabled = false
		BotaoPoder.modulate = Color(1.0, 0.9, 0.35, 1.0)
	else:
		BotaoPoder.disabled = false
		BotaoPoder.modulate = Color.WHITE


func adicionar_indicador_poder(area: Area2D, caminho_icone: String) -> void:
	var indicador := Sprite2D.new()
	if ResourceLoader.exists(caminho_icone):
		indicador.texture = load(caminho_icone)
	else:
		indicador.texture = load("res://sprites/PlaceHolders/Butao.png")

	var tex_size: Vector2 = indicador.texture.get_size()
	var largura_visivel: float = tex_size.x
	var img := indicador.texture.get_image()
	if img != null:
		if img.is_compressed():
			img.decompress()
		var used_rect: Rect2i = img.get_used_rect()
		if used_rect.size.x > 0:
			largura_visivel = float(used_rect.size.x)
			var centro_usado: Vector2 = Vector2(used_rect.position) + Vector2(used_rect.size) * 0.5
			indicador.offset = (tex_size * 0.5) - centro_usado

	if largura_visivel > 0.0:
		var fator: float = 34.0 / largura_visivel
		indicador.scale = Vector2(fator, fator)

	indicador.position = Vector2(-60, -30)
	indicador.z_index = 1
	area.add_child(indicador)


func animar_poder_carta(area: Area2D, sprite: Sprite2D, tex_antigo: Texture2D, tex_novo: Texture2D = null) -> Tween:
	var escala_normal: Vector2 = sprite.scale
	var escala_menor: Vector2 = escala_normal * 0.75
	var passo: float = 1.0 / 6.0
	var trocar_textura: bool = tex_novo != null and tex_novo != tex_antigo

	var tween: Tween = area.create_tween()
	for _i in range(3):
		tween.tween_callback(func():
			if not is_instance_valid(sprite):
				return
			sprite.scale = escala_menor
			if trocar_textura:
				sprite.texture = tex_antigo
		)
		tween.tween_interval(passo)
		tween.tween_callback(func():
			if not is_instance_valid(sprite):
				return
			sprite.scale = escala_normal
			if trocar_textura:
				sprite.texture = tex_novo
		)
		tween.tween_interval(passo)

	return tween


func obter_caminho_sprite_por_valor(valor_carta: int, naipe_base: String) -> String:
	var num_sprite: String = ""
	var naipe_sprite: String = naipe_base

	match valor_carta:
		1:
			num_sprite = "4"
			if naipe_sprite == "Paus":
				naipe_sprite = "Espadas"
		2:
			num_sprite = "5"
		3:
			num_sprite = "6"
		4:
			num_sprite = "7"
			if naipe_sprite == "Ouros" or naipe_sprite == "Copas":
				naipe_sprite = "Espadas"
		5:
			num_sprite = "Q"
		6:
			num_sprite = "J"
		7:
			num_sprite = "K"
		8:
			num_sprite = "As"
			if naipe_sprite == "Espadas":
				naipe_sprite = "Paus"
		9:
			num_sprite = "2"
		10:
			num_sprite = "3"
		11:
			num_sprite = "7"
			naipe_sprite = "Ouros"
		12:
			num_sprite = "As"
			naipe_sprite = "Espadas"
		13:
			num_sprite = "7"
			naipe_sprite = "Copas"
		14:
			num_sprite = "4"
			naipe_sprite = "Paus"
		_:
			return ""

	return "res://sprites/cartas/" + num_sprite + "_" + naipe_sprite + ".png"

#endregion
