# Aula 08 — A vila vista de cima

Prática de Jogos Digitais II: uma vila em visão de cima, feita na Godot 4.7 com o renderizador Compatibility.

## Como executar

1. Importe o arquivo `project.godot` na Godot 4.7.1 ou uma versão 4.7 posterior.
2. Abra o projeto e pressione **F5**. A cena principal é `scenes/vila.tscn`.
3. Mova o personagem com **WASD** ou com as **setas**. Também é possível andar na diagonal.

## Projeto

- Vila de **40 × 24** peças de 16 pixels: **640 × 384** pixels.
- Camadas `chao` e `objetos` compartilham o recurso `tiles/vila.tres`.
- Casas de 4 × 3 peças e árvores altas de 1 × 2 aparecem inteiras na paleta.
- Personagem com quatro animações a 8 FPS, velocidade de 70 pixels/s e colisor nos pés.
- Câmera com zoom 3 e limites nas quatro bordas do mapa.
- Casas, árvores, arbustos, muro, cerca, poço e placa têm colisão; o chão permanece livre.

As Partes 0 a 4 do roteiro estão implementadas; os desafios opcionais não foram acrescentados.
Para visualizar os colisores durante a execução, ative **Depurar → Formas de colisão visíveis**.

## Créditos

- Tileset: Tiny Town, de Kenney — https://kenney.nl/assets/tiny-town — licença CC0.
- Personagem: Prof. Ezefferth, para a Aula 08 de Jogos Digitais II.

Os três arquivos de `sprites/` são os originais do pacote `assets-vila` da aula.
A licença do tileset está em `sprites/LICENCA-tiny-town.txt`.
