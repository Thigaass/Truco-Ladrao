<a id="topo"></a>
# 🃏 Truco Ladrão!

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

O jogo é inspirado no clássico **Truco** brasileiro (com manilhas fixas) misturado com uma pegada estilo **Balatro**: antes de cada partida, você escolhe um poder especial para dar aquela "roubadinha" nas regras da mão — como aumentar o valor de uma carta sua, enfraquecer uma carta do bot, trocar cartas ou espiar a mão do adversário.

> 🚧 **Status do projeto:** Em desenvolvimento. O **CORE do jogo 1v1 já está jogável do começo ao fim**, mas ainda existem vários sprites *placeholder*, lógica básica no bot e elementos de interface não finalizados.

<a id="pt-como-funciona"></a>
### 🎮 Como Funciona

1. Comece no **Menu Principal** (`Jogar` / `Sair`).
2. Escolha **1 entre 4 poderes** na tela de seleção para levar para a partida.
3. Jogue uma partida **1v1 de Truco contra o Bot** até **12 pontos**, podendo usar seu poder 1 vez por mão e pedir Truco para aumentar a aposta.

#### ⚡ Os 4 Poderes
- ⬆️ **Aumentar Carta (`Poder_1`):** Aumenta em `+1` o valor de uma das suas cartas nesta mão.
- 🔄 **Trocar Carta (`Poder_2`):** Escolhe uma carta sua e troca por uma carta virada do bot.
- ⬇️ **Enfraquecer Carta (`Poder_3`):** Diminui em `-1` o valor de uma carta do bot nesta mão.
- 👁️ **Espiar Carta (`Poder_4`):** Revela uma das cartas viradas do bot antes de jogar.

<a id="pt-core"></a>
### ✅ O que já foi feito (CORE do Jogo)

#### 🃏 Baralho e Regras do Truco
- **Baralho completo de 40 cartas** (`Carta.gd`, `Baralho.gd`) com os 4 naipes (`Ouros`, `Espadas`, `Copas`, `Paus`) e sprites próprios para todas as cartas e para o verso (`Verso.png`).
- **Hierarquia de manilhas fixas:** 4 de Paus (Zap) > 7 de Copas > Ás de Espadas > 7 de Ouros, seguidos por `3 > 2 > As > K > J > Q > 7 > 6 > 5 > 4`.
- **Modificadores por mão:** Cada carta separa `valor_base` e `valor`, garantindo que buffs/debuffs dos poderes valham apenas na mão atual e resetem corretamente na próxima distribuição (`Globais.distribuir()`).

#### 🔁 Fluxo da Partida e Rodadas (`mesa.gd`)
- **Melhor de 3 vazas por mão**, controlando vitórias, derrotas e empates (`W`, `L`, `E`), incluindo regras de desempate do Truco (quem ganha após empate ou quem levou a primeira vaza decide em caso de empate na 3ª).
- **Alternância de turnos:** Quem começa cada partida e cada mão alterna automaticamente; quem vence uma vaza começa jogando a próxima (e empates mantêm quem começou).
- **Partida até 12 pontos:** Placar visual (`00`–`12`), botão de próxima rodada entre mãos e encerramento automático ao atingir 12 pontos (retornando ao Menu Principal após uma pequena pausa).

#### 📢 Sistema de Truco
- **Apostas progressivas (`3 → 6 → 9 → 12`):** O botão de Truco (`BotaoTruco`) atualiza dinamicamente suas texturas (normal/apertado) e máscara de clique por transparência a cada nível.
- **Trava na Mão de 11:** O botão de Truco fica desativado quando qualquer lado chega a 11 pontos.
- **Resposta básica do bot (`bot_aceita_truco()`):** Quando o jogador pede Truco, o bot avalia sua mão para decidir se aceita o aumento ou corre (dando os pontos atuais ao jogador e encerrando a mão).

#### ✨ Sistema de Poderes (`poderes.tscn`, `poderes.gd`, `Globais.gd`, `mesa.gd`)
- **Tela de seleção de poderes** com ícones próprios, máscaras de clique por alpha e caixa de descrição ao passar o mouse.
- **1 uso por mão**, com ativação, cancelamento (clicando novamente no poder antes de confirmar o alvo) e estados visuais no botão (disponível, ativo/destacado e desativado/usado).
- **Animações e feedback visual:** Animações de *tween* nos poderes 1 e 3, troca automática do sprite da carta ao aumentar o valor e ícones indicadores em cartas modificadas (como Zap buffado com `valor > 14` e cartas enfraquecidas do bot quando reveladas).

#### 🤖 IA Básica do Bot
- **Tempo simulado de resposta** (`agendar_jogada_bot()`), travando as ações do jogador enquanto o bot "pensa".
- **Escolha básica de cartas (`escolher_indice_bot()`):** Ao responder uma carta do jogador, o bot tenta ganhar usando a menor carta vencedora, empatar se possível ou descartar sua menor carta. Ao abrir a 2ª vaza tendo vencido a 1ª, joga sua carta mais forte.

#### 🖼️ Cenas, Interface e Áudio
- Fluxo funcional entre as 3 cenas: `menu.tscn` → `poderes.tscn` → `Main.tscn`.
- Mensagens de status na tela (`status_label`) indicando de quem é a vez, instruções dos poderes, resultado do Truco e fim da partida.
- Música de fundo em loop (`AudioStreamPlayer` em `Main.tscn`).

<a id="pt-pendencias"></a>
### 🛠️ O que falta implementar (Placeholders e Pendências)

#### 🤖 Melhorias na IA do Bot e no Truco
- **Bot pedir Truco:** Atualmente só o jogador pode pedir Truco; ainda falta implementar a lógica para o bot trucar e pedir aumento (`6`, `9`, `12`) por conta própria.
- **Bot pensar mais nas jogadas:** `escolher_indice_bot()` ainda é bem simples — ao começar uma vaza ele quase sempre joga uma carta aleatória, sem estratégia para economizar cartas fortes, lidar com empates ou blefar.
- **Bot pensar mais no Truco (`bot_aceita_truco()`):** Hoje a função está desbalanceada (costuma correr demais e dar pontos de graça) e olha apenas o valor bruto das cartas. Falta considerar o placar da partida, vazas já ganhas/perdidas na mão e blefe.

#### 🎨 Placeholders que ainda estão no jogo
- **Cenário de fundo:** A mesa, o menu principal e a tela de poderes ainda usam o fundo provisório `sprites/PlaceHolders/cenario.png`.
- **Botões genéricos:** `sprites/PlaceHolders/Butao.png` ainda é usado nos botões do Menu Principal (`Jogar`, `Sair`) e no botão de próxima rodada (`botaoproxrodada`, que ainda nem possui texto/arte própria).
- **Marcadores de resultado das vazas:** Ainda usam sprites provisórios (`Win.png`, `Loss.png`, `Emp.png`).
- **Placar:** Está funcional, mas o visual e o posicionamento ainda são sujeitos a mudanças.

#### 🧩 Menus, Recursos e Polimento que faltam
- **Menu Principal incompleto:** Ainda falta a opção de **Configurações** (volume geral, volume da música e volume dos efeitos sonoros) e um botão de **Como Jogar** explicando as regras do Truco e os poderes.
- **Menu / Pausa durante a partida:** Ainda não existe um botão de menu/pausa na mesa (para ajustar volume, reiniciar ou voltar ao menu principal).
- **Melhorias na GUI e acabamento:** Interface mais caprichada, efeitos sonoros (jogar carta, pedir truco, ativar poder), animações de distribuição/movimento das cartas e uma tela própria de vitória/derrota no fim da partida em vez de voltar direto ao menu após 2 segundos.
- **Regras completas da Mão de 11:** Chegar a 11 pontos hoje apenas desativa o botão de Truco; o fluxo completo de decisão da Mão de 11 ainda não foi implementado.

<a id="pt-estrutura"></a>
### 📁 Estrutura do Projeto

- `menu.tscn` / `menu.gd` — Tela de Menu Principal.
- `poderes.tscn` / `poderes.gd` — Tela de escolha de poderes antes da partida.
- `Main.tscn` / `mesa.gd` — Mesa principal, loop de rodadas, IA do bot, Truco, poderes e HUD.
- `Baralho.gd` / `Carta.gd` — Criação do baralho e modelo de dados das cartas.
- `Globais.gd` — Singleton (*Autoload*) que gerencia baralho, mãos, estado dos poderes e funções auxiliares.
- `sprites/` — Sprites das cartas, elementos de GUI, áudio e placeholders (`sprites/PlaceHolders/`).

<a id="pt-como-rodar"></a>
### ▶️ Como Rodar

1. Abra a **Godot 4** (configurada na versão `4.7` em `project.godot`).
2. Importe/abra o arquivo `project.godot` desta pasta.
3. Aperte **Play (`F5`)** para iniciar pelo Menu Principal.

[⬆️ Voltar ao Sumário](#sumario)

---

<a id="english"></a>
## 🇺🇸 English Version

A 2D card game made in **Godot 4** by me and 2 friends as a personal and college project while learning game development as beginners.

It is inspired by the Brazilian card game **Truco** (using fixed manilhas) mixed with a **Balatro**-style twist: before each match, you pick a special power that lets you bend the rules of a hand — like boosting your own card, weakening the bot's card, swapping cards, or peeking at what the bot is holding.

> 🚧 **Project status:** Work in progress. The **core 1v1 game loop is playable from start to finish**, though the project still uses several placeholder sprites, basic bot logic, and unfinished UI elements.

<a id="en-how-it-works"></a>
### 🎮 How It Works

1. Start from the **Main Menu** (`Jogar` / `Sair`).
2. Choose **1 of 4 powers** on the Power Selection screen to bring into the match.
3. Play a **1v1 Truco match against a Bot** up to **12 points**, using your chosen power once per hand and calling Truco to raise the stakes.

#### ⚡ The 4 Powers
- ⬆️ **Aumentar Carta (`Poder_1`):** Increases one of your cards' value by `+1` for the current hand.
- 🔄 **Trocar Carta (`Poder_2`):** Lets you pick one of your cards and swap it with one of the bot's face-down cards.
- ⬇️ **Enfraquecer Carta (`Poder_3`):** Decreases one of the bot's cards' value by `-1` for the current hand.
- 👁️ **Espiar Carta (`Poder_4`):** Reveals one of the bot's face-down cards before playing.

<a id="en-core"></a>
### ✅ What's Already Implemented (Core Game)

#### 🃏 Deck & Truco Rules
- **40-card Truco deck** (`Carta.gd`, `Baralho.gd`) with all 4 suits (`Ouros`, `Espadas`, `Copas`, `Paus`) and custom sprites for every card plus the card back (`Verso.png`).
- **Fixed manilha hierarchy:** 4 of Paus (Zap) > 7 of Copas > Ace of Espadas > 7 of Ouros, followed by `3 > 2 > As > K > J > Q > 7 > 6 > 5 > 4`.
- **Per-hand value modifiers:** Cards separate `valor_base` and `valor`, so buffs/debuffs from powers only apply to the current hand and reset cleanly on the next deal (`Globais.distribuir()`).

#### 🔁 Core Match & Round Loop (`mesa.gd`)
- **Best-of-3 tricks (vazas) per hand**, tracking wins, losses, and ties (`W`, `L`, `E`), including Truco tie-breaking rules (winning after a tied trick or resolving a tied 3rd trick via the first-trick winner).
- **Turn & lead alternation:** Who starts each match and each hand alternates automatically; whoever wins a trick leads the next one (and ties keep the previous leader).
- **12-point match flow:** Visual scoreboard (`00`–`12`), "Next Round" progression between hands, and automatic match end at 12 points (returning to the Main Menu after a short delay).

#### 📢 Truco Betting System
- **Progressive raises (`3 → 6 → 9 → 12`):** The Truco button (`BotaoTruco`) dynamically swaps its normal/pressed sprites and alpha click masks as the stakes rise.
- **Mão de 11 guard:** Calling Truco is disabled when either side reaches 11 points.
- **Basic bot response (`bot_aceita_truco()`):** When the player calls Truco, the bot evaluates its hand to decide whether to accept the raise or fold (giving the player the current points and ending the hand).

#### ✨ Powers System (`poderes.tscn`, `poderes.gd`, `Globais.gd`, `mesa.gd`)
- **Power selection screen** with custom icons, alpha click masks, and hover tooltips describing each power.
- **1 use per hand** with activation, cancellation (clicking the power button again before picking a target), and visual button states (available, active/highlighted, disabled/used).
- **Visual feedback & animations:** Tween animations when applying powers 1 and 3, dynamic card sprite updates when a card's value increases, and small power badge indicators on boosted Zap cards (`valor > 14`) and weakened bot cards when revealed.

#### 🤖 Basic Bot AI
- **Simulated thinking delay** (`agendar_jogada_bot()`), preventing player actions while the bot is taking its turn.
- **Basic card selection (`escolher_indice_bot()`):** When responding to a player's card, the bot tries to win with its lowest winning card, otherwise tries to tie, or dumps its weakest card. When leading the 2nd trick after winning the 1st, it plays its strongest card.

#### 🖼️ Scenes, HUD & Audio
- Complete scene flow across `menu.tscn` → `poderes.tscn` → `Main.tscn`.
- On-screen status text (`status_label`) guiding turn order, power targeting, Truco results, and match outcomes.
- Looping background music (`AudioStreamPlayer` in `Main.tscn`).

<a id="en-todo"></a>
### 🛠️ Placeholders & Unfinished Parts (To-Do / Future Updates)

#### 🤖 Bot AI & Truco Logic
- **Bot calling Truco:** Right now only the player can call Truco. The bot still needs logic to initiate Truco and counter-raise (`6`, `9`, `12`) on its own.
- **Bot thinking more during card plays:** `escolher_indice_bot()` is still very simple — when leading a trick it mostly picks a random card and doesn't yet strategize around remaining tricks, ties, or bluffing.
- **Bot thinking more on Truco (`bot_aceita_truco()`):** Currently unbalanced (it tends to fold too often and give away free points) and only checks raw card values. It needs to consider match score, tricks already won/lost in the hand, and bluffing.

#### 🎨 Placeholders Currently in the Game
- **Background art:** The table, main menu, and power selection screen all still use the placeholder `sprites/PlaceHolders/cenario.png`.
- **Generic button sprites:** `sprites/PlaceHolders/Butao.png` is still used for the Main Menu buttons (`Jogar`, `Sair`) and the "Next Round" button (`botaoproxrodada`, which also doesn't have a label/custom art yet).
- **Trick result markers:** Still using placeholder sprites (`Win.png`, `Loss.png`, `Emp.png`).
- **Scoreboard:** Works as intended for now, but its visuals and layout are still subject to change.

#### 🧩 Missing Menus, Features & Polish
- **Main Menu options:** Still missing a **Settings** menu (master volume, music volume, and sound effects volume) and a **How to Play** screen explaining Truco and the powers.
- **In-game Menu / Pause:** There is currently no pause or menu button during a match (to adjust volume, restart, or return to the main menu).
- **Better GUI & Juice:** Overall UI styling, sound effects (playing cards, calling Truco, using powers), card dealing/movement animations, and a proper end-of-match screen instead of returning straight to the menu after 2 seconds.
- **Full Mão de 11 rules:** Reaching 11 points currently only disables the Truco button; the full Mão de 11 decision flow isn't implemented yet.

<a id="en-structure"></a>
### 📁 Project Structure

- `menu.tscn` / `menu.gd` — Main Menu screen.
- `poderes.tscn` / `poderes.gd` — Pre-match power selection screen.
- `Main.tscn` / `mesa.gd` — Main game table, round loop, bot AI, Truco, powers, and HUD.
- `Baralho.gd` / `Carta.gd` — Deck creation and card data model.
- `Globais.gd` — Autoload singleton managing the deck, hands, power state, and shared helpers.
- `sprites/` — Card art, GUI assets, audio, and current placeholder sprites (`sprites/PlaceHolders/`).

<a id="en-how-to-run"></a>
### ▶️ How to Run

1. Open **Godot 4** (configured with Godot `4.7` in `project.godot`).
2. Import/open `project.godot` from this folder.
3. Press **Play (`F5`)** to launch from the Main Menu.

[⬆️ Back to Table of Contents](#sumario)
