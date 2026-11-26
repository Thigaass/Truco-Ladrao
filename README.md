# Truco Ladrão!
<a id="topo"></a>
# 🃏 Truco Ladrão!
A 2D card game made in **Godot 4** by me and 2 friends as a personal and college project while learning game development as beginners.
Projeto pessoal e de faculdade de um jogo de cartas 2D feito na **Godot 4** por iniciantes, inspirado em **Truco** e **Balatro**.  
*Personal & college 2D card game project made in **Godot 4** by beginners, inspired by **Truco** and **Balatro**.*
<a id="sumario"></a>
## 📑 Sumário / Table of Contents
- 🇧🇷 **[Versão em Português](#portugues)**
  - [🎮 Como Funciona](#pt-como-funciona)
  - [✅ O que já foi feito (CORE do Jogo)](#pt-core)
  - [🛠️ O que falta implementar (Placeholders e Pendências)](#pt-pendencias)
  - [📁 Estrutura do Projeto](#pt-estrutura)
  - [▶️ Como Rodar](#pt-como-rodar)
- 🇺🇸 **[English Version](#english)**
  - [🎮 How It Works](#en-how-it-works)
  - [✅ What's Already Implemented (Core Game)](#en-core)
  - [🛠️ Placeholders & Unfinished Parts (To-Do / Future Updates)](#en-todo)
  - [📁 Project Structure](#en-structure)
  - [▶️ How to Run](#en-how-to-run)
---
<a id="portugues"></a>
## 🇧🇷 Versão em Português
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
<a id="pt-como-funciona"></a>
### 🎮 Como Funciona
1. Comece no **Menu Principal** (`Jogar` / `Sair`).
2. Escolha **1 entre 4 poderes** na tela de seleção para levar para a partida.
3. Jogue uma partida **1v1 de Truco contra o Bot** até **12 pontos**, podendo usar seu poder 1 vez por mão e pedir Truco para aumentar a aposta.
### The 4 Powers
- **Aumentar Carta (`Poder_1`):** Increases one of your cards' value by `+1` for the current hand.
- **Trocar Carta (`Poder_2`):** Lets you pick one of your cards and swap it with one of the bot's face-down cards.
- **Enfraquecer Carta (`Poder_3`):** Decreases one of the bot's cards' value by `-1` for the current hand.
- **Espiar Carta (`Poder_4`):** Reveals one of the bot's face-down cards before playing.
### ⚡ Os 4 Poderes
#### ⚡ Os 4 Poderes
- ⬆️ **Aumentar Carta (`Poder_1`):** Aumenta em `+1` o valor de uma das suas cartas nesta mão.
- 🔄 **Trocar Carta (`Poder_2`):** Escolhe uma carta sua e troca por uma carta virada do bot.
- ⬇️ **Enfraquecer Carta (`Poder_3`):** Diminui em `-1` o valor de uma carta do bot nesta mão.
- 👁️ **Espiar Carta (`Poder_4`):** Revela uma das cartas viradas do bot antes de jogar.
<a id="pt-core"></a>
