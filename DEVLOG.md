# DEVLOG

## 21/10/2026 — Aula 09: Última Vigília

Continuei a vila da Aula 08, preservando o mapa de 640 × 384 pixels, o TileSet e suas colisões. Acrescentei menu inicial, inimigo perseguidor, horda progressiva, três vidas, dano por contato e um segundo de invencibilidade com transparência de 0,4.

A partida dura 60 segundos e termina em vitória ao completar o tempo ou derrota ao perder as vidas. O HUD mostra vidas, tempo e progresso; Enter e os botões iniciam ou reiniciam a partida. O jogador mantém velocidade de 70 pixels/s, e os inimigos usam 40 pixels/s. A horda parte de dois segundos entre surgimentos e reduz o intervalo em 5% a cada inimigo, com mínimo de meio segundo.

Integrei o sobrevivente e o zumbi do pacote de combate em escala 0,32. Como os arquivos não têm quatro orientações, usei espelhamento horizontal e preservei os controles em quatro direções. Mantive os assets originais da aula e os créditos existentes; o pacote novo não informa autoria ou licença.

As Partes 1 a 4 da Aula 09 foram implementadas. Os modos e desafios posteriores ficam para uma próxima etapa; o Timer Relogio pode ser ajustado para 180 segundos para experimentar sobrevivência de três minutos. A entrega é registrada no repositório da atividade com a tag aula-09.

Validei na Godot 4.7.2: 65 verificações de integração sem falhas, incluindo menu, botões, movimento, perseguição, colisões, nascedouros livres, horda, HUD, dano real por sobreposição, recuperação após um segundo, vitória, derrota e reinício. Conferi visualmente o menu, a partida e as duas telas de fim no renderizador Compatibility. O teste está em tests/validar.gd e seu resultado em tests/resultado-entrega.json.

## 07/10/2026 — Aula 08

Montei a vila de 40 × 24 peças, com grama, ruas em cruz, casas, árvores, horta, cerca e muro em duas camadas.
Configurei o personagem nas quatro direções, com animações a 8 FPS, colisor nos pés e câmera com zoom 3 e limites do mapa.
O pacote de arte não estava na busca inicial; o caminho informado permitiu usar os três arquivos originais do Classroom.
Salvei um único TileSet externo para as duas camadas e defini colisões completas nas peças sólidas, deixando o chão livre.
Validei movimento, animações, colisões e limites da câmera na Godot 4.7.2: 262 verificações sem falhas e conferência visual da vila.
