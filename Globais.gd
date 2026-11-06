extends Node
var baralho: Array[Carta] = []
var maoP: Array[Carta] = []
var maoO: Array[Carta] = []
func distribuir() -> void:
	baralho.shuffle()
	maoP = baralho.slice(0,3)
	maoO = baralho.slice(3,6)
