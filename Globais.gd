extends Node

# Cartas e mãos
var baralho: Array[Carta] = []
var maoP: Array[Carta] = []
var maoO: Array[Carta] = []

# Estado da partida
var jogador_comeca_proxima_partida: bool = true

# Estado dos poderes
var poder_esc: int = 0
var poder_us: bool = false
var arg_carta: bool = false
var arg_troca: bool = false
var arg_carta_bot: bool = false
var arg_revelar: bool = false


#region Cartas e Baralho

func distribuir() -> void:
	if baralho.size() < 6:
		push_error("Baralho incompleto para distribuir cartas.")
		return

	for carta in baralho:
		carta.valor = carta.valor_base

	baralho.shuffle()
	maoP = baralho.slice(0, 3)
	maoO = baralho.slice(3, 6)

#endregion


#region Poderes

func poder() -> void:
	if poder_us or poder_ativo():
		return

	match poder_esc:
		1:
			arg_carta = true
		2:
			arg_troca = true
		3:
			arg_carta_bot = true
		4:
			arg_revelar = true


func poder_ativo() -> bool:
	return arg_carta or arg_troca or arg_carta_bot or arg_revelar


func cancelar_poder() -> void:
	arg_carta = false
	arg_troca = false
	arg_carta_bot = false
	arg_revelar = false


func resetar_poderes() -> void:
	poder_us = false
	cancelar_poder()


func sprite_poder(botao: TextureButton) -> void:
	var caminho := "res://sprites/PlaceHolders/Poder_" + str(poder_esc) + ".png"
	var textura: Texture2D
	if ResourceLoader.exists(caminho):
		textura = load(caminho)
	else:
		textura = load("res://sprites/PlaceHolders/Butao.png")

	botao.texture_normal = textura
	botao.texture_hover = textura
	botao.texture_pressed = textura
	botao.texture_disabled = textura

	botao.ignore_texture_size = true
	botao.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	botao.custom_minimum_size = Vector2(90, 90)
	botao.size = Vector2(90, 90)
	botao.scale = Vector2.ONE

#endregion
