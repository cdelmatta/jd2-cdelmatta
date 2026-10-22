# Última Vigília — Aula 09

Jogo de sobrevivência em uma vila, continuando o projeto da Aula 08 de Jogos Digitais II. Desvie dos zumbis e permaneça vivo até o relógio terminar.

## Como jogar

1. Importe `project.godot` na **Godot 4.7.2**.
2. Pressione **F5** para abrir o menu (`scenes/inicio.tscn`).
3. Use **Enter** ou o botão para iniciar. Mova-se com **WASD** ou **setas**, inclusive na diagonal.
4. Sobreviva por **60 segundos**, começando com **3 vidas**. O contato com um zumbi tira uma vida e concede **1 segundo** de invencibilidade; nesse período o personagem fica semitransparente.
5. Nas telas de vitória ou derrota, pressione **Enter** ou use o botão para reiniciar.

Para testar diretamente a partida, abra `scenes/vila.tscn` e pressione **F6**. O HUD mostra as vidas, o tempo restante e o progresso da sobrevivência.

## O que foi implementado

As **Partes 1 a 4 da Aula 09** estão implementadas: inimigo perseguidor, dano com invencibilidade, horda progressiva, HUD, relógio e telas de encerramento. Há também um menu inicial. Os demais modos e desafios ficam para as próximas etapas do roteiro.

- Jogador: **70 pixels/s**; inimigo: **40 pixels/s**.
- A horda começa com intervalo de **2 segundos**. Cada surgimento multiplica o intervalo por **0,95**, até o mínimo de **0,5 segundo**.
- Vila preservada da Aula 08: **40 × 24 peças de 16 pixels**, totalizando **640 × 384 pixels**, com TileSet compartilhado e colisões nos obstáculos.
- Sobrevivente e zumbi usam os sprites de combate fornecidos, em escala **0,32**. O nome do asset `zumbi_rapido` não altera a velocidade de 40 pixels/s definida para esta atividade.
- O pacote possui uma orientação por animação. Os sprites são espelhados horizontalmente, enquanto os controles continuam funcionando nas quatro direções. O personagem original permanece em `sprites/personagem.png`.

Para experimentar o modo de sobrevivência de **3 minutos**, selecione o Timer **Relogio** em `scenes/vila.tscn` e altere **Wait Time** para **180**. Para visualizar os colisores, ative **Depurar → Formas de colisão visíveis** durante a execução.

## Verificações

Validado na **Godot 4.7.2**, com **65 verificações de integração, sem falhas**: início por Enter e botão, movimento WASD/setas e diagonal, colisões, perseguição, nascedouros livres, horda, HUD, dano por contato, invencibilidade, vitória, derrota e reinício. As quatro telas foram renderizadas e conferidas visualmente com o renderizador Compatibility.

O teste reproduzível está em `tests/validar.gd`. Execute na pasta do projeto, com o executável da Godot disponível no terminal:

```powershell
godot --headless --path . --script res://tests/validar.gd
```

O processo retorna código 0 se todos os testes passarem e grava `user://resultado-aula09.json` na pasta de dados da Godot. O resultado da validação desta entrega está em `tests/resultado-entrega.json`.

## Créditos

- Tileset **Tiny Town**, de Kenney: https://kenney.nl/assets/tiny-town — licença CC0, incluída em `sprites/LICENCA-tiny-town.txt`.
- Personagem original da Aula 08: **Prof. Ezefferth**.
- Sprites de combate: pacote fornecido pelo usuário para a atividade. O pacote não inclui identificação de autoria, fonte ou licença.

Repositório da atividade: https://github.com/cdelmatta/jd2-cdelmatta. A entrega da Aula 09 é identificada pela tag `aula-09`. O roteiro em PDF foi usado como referência e não integra a pasta do jogo.
