# Truco Ladrão!
# 🃏 Truco Ladrão!
A 2D card game made in **Godot 4** by me and 2 friends as a personal and college project while learning game development as beginners.
Um jogo de cartas 2D feito na **Godot 4** por mim e mais 2 amigos como um projeto pessoal e de faculdade, enquanto aprendemos desenvolvimento de jogos como iniciantes.
It is inspired by the Brazilian card game **Truco** (using fixed manilhas) mixed with a **Balatro**-style twist: before each match, you pick a special power that lets you bend the rules of a hand — like boosting your own card, weakening the bot's card, swapping cards, or peeking at what the bot is holding.
O jogo é inspirado no clássico **Truco** brasileiro (com manilhas fixas) misturado com uma pegada estilo **Balatro**: antes de cada partida, você escolhe um poder especial para dar aquela "roubadinha" nas regras da mão — como aumentar o valor de uma carta sua, enfraquecer uma carta do bot, trocar cartas ou espiar a mão do adversário.
> **Project status:** Work in progress. The **core 1v1 game loop is playable from start to finish**, though the project still uses several placeholder sprites, basic bot logic, and unfinished UI elements.
> 🚧 **Status do projeto:** Em desenvolvimento. O **CORE do jogo 1v1 já está jogável do começo ao fim**, mas ainda existem vários sprites *placeholder*, lógica básica no bot e elementos de interface não finalizados.
---
## How It Works
## 🎮 Como Funciona
1. Start from the **Main Menu** (`Jogar` / `Sair`).
2. Choose **1 of 4 powers** on the Power Selection screen to bring into the match.
3. Play a **1v1 Truco match against a Bot** up to **12 points**, using your chosen power once per hand and calling Truco to raise the stakes.
1. Comece no **Menu Principal** (`Jogar` / `Sair`).
2. Escolha **1 entre 4 poderes** na tela de seleção para levar para a partida.
3. Jogue uma partida **1v1 de Truco contra o Bot** até **12 pontos**, podendo usar seu poder 1 vez por mão e pedir Truco para aumentar a aposta.
### The 4 Powers
- **Aumentar Carta (`Poder_1`):** Increases one of your cards' value by `+1` for the current hand.
- **Trocar Carta (`Poder_2`):** Lets you pick one of your cards and swap it with one of the bot's face-down cards.
- **Enfraquecer Carta (`Poder_3`):** Decreases one of the bot's cards' value by `-1` for the current hand.
- **Espiar Carta (`Poder_4`):** Reveals one of the bot's face-down cards before playing.
### ⚡ Os 4 Poderes
- ⬆️ **Aumentar Carta (`Poder_1`):** Aumenta em `+1` o valor de uma das suas cartas nesta mão.
- 🔄 **Trocar Carta (`Poder_2`):** Escolhe uma carta sua e troca por uma carta virada do bot.
- ⬇️ **Enfraquecer Carta (`Poder_3`):** Diminui em `-1` o valor de uma carta do bot nesta mão.
- 👁️ **Espiar Carta (`Poder_4`):** Revela uma das cartas viradas do bot antes de jogar.
---
## What's Already Implemented (Core Game)
## ✅ O que já foi feito (CORE do Jogo)
### Deck & Truco Rules
- **40-card Truco deck** (`Carta.gd`, `Baralho.gd`) with all 4 suits (`Ouros`, `Espadas`, `Copas`, `Paus`) and custom sprites for every card plus the card back (`Verso.png`).
- **Fixed manilha hierarchy:** 4 of Paus (Zap) > 7 of Copas > Ace of Espadas > 7 of Ouros, followed by `3 > 2 > As > K > J > Q > 7 > 6 > 5 > 4`.
- **Per-hand value modifiers:** Cards separate `valor_base` and `valor`, so buffs/debuffs from powers only apply to the current hand and reset cleanly on the next deal (`Globais.distribuir()`).
### 🃏 Baralho e Regras do Truco
- **Baralho completo de 40 cartas** (`Carta.gd`, `Baralho.gd`) com os 4 naipes (`Ouros`, `Espadas`, `Copas`, `Paus`) e sprites próprios para todas as cartas e para o verso (`Verso.png`).
- **Hierarquia de manilhas fixas:** 4 de Paus (Zap) > 7 de Copas > Ás de Espadas > 7 de Ouros, seguidos por `3 > 2 > As > K > J > Q > 7 > 6 > 5 > 4`.
- **Modificadores por mão:** Cada carta separa `valor_base` e `valor`, garantindo que buffs/debuffs dos poderes valham apenas na mão atual e resetem corretamente na próxima distribuição (`Globais.distribuir()`).
### Core Match & Round Loop (`mesa.gd`)
- **Best-of-3 tricks (vazas) per hand**, tracking wins, losses, and ties (`W`, `L`, `E`), including Truco tie-breaking rules (winning after a tied trick or resolving a tied 3rd trick via the first-trick winner).
- **Turn & lead alternation:** Who starts each match and each hand alternates automatically; whoever wins a trick leads the next one (and ties keep the previous leader).
- **12-point match flow:** Visual scoreboard (`00`–`12`), "Next Round" progression between hands, and automatic match end at 12 points (returning to the Main Menu after a short delay).
### 🔁 Fluxo da Partida e Rodadas (`mesa.gd`)
- **Melhor de 3 vazas por mão**, controlando vitórias, derrotas e empates (`W`, `L`, `E`), incluindo regras de desempate do Truco (quem ganha após empate ou quem levou a primeira vaza decide em caso de empate na 3ª).
- **Alternância de turnos:** Quem começa cada partida e cada mão alterna automaticamente; quem vence uma vaza começa jogando a próxima (e empates mantêm quem começou).
- **Partida até 12 pontos:** Placar visual (`00`–`12`), botão de próxima rodada entre mãos e encerramento automático ao atingir 12 pontos (retornando ao Menu Principal após uma pequena pausa).
### Truco Betting System
- **Progressive raises (`3 → 6 → 9 → 12`):** The Truco button (`BotaoTruco`) dynamically swaps its normal/pressed sprites and alpha click masks as the stakes rise.
- **Mão de 11 guard:** Calling Truco is disabled when either side reaches 11 points.
