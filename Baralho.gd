extends Node2D


func criarBaralho() -> void:
	Globais.baralho.clear()

	for naipe: String in ["Ouros", "Espadas", "Copas", "Paus"]:
		for num: String in ["As", "2", "3", "4", "5", "6", "7", "J", "Q", "K"]:
			var carta := Carta.new()
			carta.num = num
			carta.naipe = naipe

			match carta.num:
				"4":
					carta.valor_base = 14 if carta.naipe == "Paus" else 1
				"5":
					carta.valor_base = 2
				"6":
					carta.valor_base = 3
				"7":
					if carta.naipe == "Ouros":
						carta.valor_base = 11
					elif carta.naipe == "Copas":
						carta.valor_base = 13
					else:
						carta.valor_base = 4
				"Q":
					carta.valor_base = 5
				"J":
					carta.valor_base = 6
				"K":
					carta.valor_base = 7
				"As":
					carta.valor_base = 12 if carta.naipe == "Espadas" else 8
				"2":
					carta.valor_base = 9
				"3":
					carta.valor_base = 10

			carta.valor = carta.valor_base
			Globais.baralho.append(carta)
