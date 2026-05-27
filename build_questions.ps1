$file = "plano-estudo-grafos.html"
$lines = Get-Content $file -Encoding UTF8

# Find boundaries
$startLine = -1; $endLine = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match "<!-- Q1 -->" -and $startLine -eq -1) { $startLine = $i }
  if ($lines[$i] -match "<!-- Q21-30 ABERTAS -->" -and $startLine -ne -1 -and $endLine -eq -1) { $endLine = $i - 1 }
}
Write-Host "Replacing lines $startLine to $endLine"

# Helper to build one interactive question card
function MakeQ($id, $num, $question, $opts, $correct, $exp) {
  $o = ''
  foreach ($letter in 'a','b','c','d') {
    $o += "          <div class='quiz-option' data-letter='$letter' onclick='selectOption(this,$id)'><div class='quiz-letter'>$($letter.ToUpper())</div><div>$($opts[$letter])</div></div>`n"
  }
  return @"
      <!-- Q$num -->
      <div class="question-card" id="q-$id">
        <div class="question-header" onclick="toggle(this)">
          <div class="q-num fechada">$num</div>
          <div class="q-text">$question</div>
          <div class="q-toggle">▼</div>
        </div>
        <div class="question-body">
$o          <button class="quiz-btn" id="btn-$id" onclick="submitQuiz($id,'$correct','$exp')">✔ Responder</button>
          <div class="quiz-feedback" id="fb-$id"></div>
        </div>
      </div>

"@
}

$newBlock = @()
$newBlock += "      <!-- Q1 -->"

$newBlock += MakeQ 1 1 "Em um grafo completo Kn, qual afirmação descreve corretamente as conexões entre seus vértices?" `
  @{a="Todo vértice possui uma aresta ligando-o a absolutamente todos os outros vértices do grafo.";b="Apenas metade dos vértices estão conectados entre si.";c="Nenhum vértice possui conexão com outro.";d="As ligações existem apenas entre pares de vértices consecutivos."} `
  "a" "No grafo completo Kn, cada vértice possui exatamente n-1 arestas. Total de arestas: n*(n-1)/2. K4 tem 6 arestas."

$newBlock += MakeQ 2 2 "Qual é a fórmula correta para calcular o Posto (número ciclomático) de um grafo conexo?" `
  @{a="N + M − 2";b="M − N + 1";c="N − M + 1";d="3N − 6"} `
  "b" "Posto = M - N + 1. Representa quantas arestas extras (ELOs) existem além de uma árvore geradora."

$newBlock += MakeQ 3 3 "Segundo o Prof. Tenório, o que é um 'Broto' no contexto de emparelhamento?" `
  @{a="Um vértice com grau igual a 1.";b="Um ciclo alternante de comprimento par.";c="Um caminho de custo máximo no grafo.";d="Um ciclo M-alternante de comprimento ímpar."} `
  "d" "Broto (Blossom) é um ciclo alternante de comprimento ÍMPAR. A aresta que fecha o broto se chama Talo."

$newBlock += MakeQ 4 4 "O que define um 'Grafo Cúbico'?" `
  @{a="Um grafo desenhado em formato de cubo tridimensional.";b="Um grafo com exatamente 3 arestas no total.";c="Um grafo regular onde todos os vértices possuem grau exatamente igual a 3.";d="Um grafo onde o Delta é igual ao número de vértices."} `
  "c" "Grafo Cúbico = Grafo 3-Regular. Todos os vértices têm grau 3 sem exceção. Delta = delta = 3."

$newBlock += MakeQ 5 5 "Um grafo pode ser classificado como Bipartido apenas se..." `
  @{a="For altamente irregular.";b="Possuir exatamente dois laços.";c="Todos os seus ciclos possuírem comprimento par.";d="For uma triangulação planar."} `
  "c" "G é bipartido se e somente se não contém nenhum ciclo de comprimento ímpar. Um triângulo já elimina a bipartição."

$newBlock += MakeQ 6 6 "Um subconjunto de vértices onde nenhum possui aresta com outro do mesmo subconjunto é chamado de:" `
  @{a="SCEE (Externamente Estável)";b="Núcleo";c="SCIE (Internamente Estável)";d="Grafo Onorífico"} `
  "c" "SCIE = Conjunto Independente. Os vértices do grupo não se conectam entre si — nenhuma aresta interna ao grupo."

$newBlock += MakeQ 7 7 "O que representa o Delta (Δ) de um grafo?" `
  @{a="O número total de arestas do grafo.";b="O grau do vértice com mais conexões (grau máximo).";c="O número de triângulos formados na triangulação.";d="A complexidade espacial do algoritmo de busca."} `
  "b" "Delta(G) é o grau máximo — o vértice mais conectado. Na coloração de arestas, Delta é o limite inferior (Vizing)."

$newBlock += MakeQ 8 8 "Quais são as condições que definem um Grafo Onorífico, segundo o Prof. Tenório?" `
  @{a="N ≤ 8, M = 7, dígrafo enraizado com caminho euleriano.";b="N = 7, M = 8, grafo biconexo e planar.";c="N ≤ 10, M = 5, fracamente conexo.";d="Grafo trivial e acíclico com N = 8."} `
  "a" "Onorífico: (1) dígrafo, (2) N ≤ 8, (3) M = 7 exato, (4) enraizado, (5) caminho euleriano da raiz. Todas as 5 condições."

$newBlock += MakeQ 9 9 "Na notação assintótica, qual símbolo representa o pior caso (limite superior) de um algoritmo?" `
  @{a="Ω (Omega) — melhor caso";b="Θ (Theta) — caso médio";c="O (Big-O) — pior caso";d="Δ (Delta) — grau máximo"} `
  "c" "Big-O = limite superior (pior caso). Omega = melhor caso. Theta = caso exato (quando os dois limites coincidem)."

$newBlock += MakeQ 10 10 "Uma aresta cuja remoção desconecta o grafo é denominada:" `
  @{a="Articulação";b="Talo";c="Ponte";d="Laço"} `
  "c" "Ponte = aresta de corte. Articulação = vértice de corte. São conceitos distintos: linha vs. ponto que divide o grafo."

$newBlock += MakeQ 11 11 "Qual é a classe de complexidade mais lenta, inviável mesmo para entradas moderadas?" `
  @{a="O(1) — constante";b="O(log N) — logarítmica";c="O(N²) — quadrática";d="O(N!) — fatorial"} `
  "d" "O(N!) é a força bruta pura. Para N=10 são 3.628.800 operações. Para N=20 são 2,4 quintilhões — inviável."

$newBlock += MakeQ 12 12 "Em um dígrafo, o 'Sumidouro' é o vértice onde:" `
  @{a="O grau de entrada é zero (só saem setas).";b="O grau de saída é zero (só chegam setas).";c="Não há nenhuma aresta conectada a ele.";d="O grau de entrada e de saída são iguais entre si."} `
  "b" "Sumidouro: todos os caminhos chegam até ele, nada sai. Grau de saída = 0. Fonte é o oposto: grau de entrada = 0."

$newBlock += MakeQ 13 13 "Qual é o principal objetivo da Redução Transitiva?" `
  @{a="Dobrar o número de arestas para aumentar a conectividade.";b="Remover arestas redundantes mantendo a mesma alcançabilidade entre todos os vértices.";c="Transformar um dígrafo em um grafo planar.";d="Aumentar a complexidade temporal para Big-O."} `
  "b" "Redução Transitiva elimina arestas atalho redundantes sem perder alcançabilidade. Resultado visual: Diagrama de Hasse."

$newBlock += MakeQ 14 14 "Como é chamado o fecho em que a passagem pelo ciclo é completamente opcional?" `
  @{a="Fecho Positivo (+)";b="Fecho Neutro";c="Fecho Estrela (*)";d="Fecho de Articulação"} `
  "c" "Fecho Estrela (*): zero ou mais vezes (opcional). Fecho Positivo (+): pelo menos uma vez (obrigatório)."

$newBlock += MakeQ 15 15 "Qual a diferença fundamental entre Cadeia e Caminho, na terminologia de Tenório?" `
  @{a="São sinônimos perfeitos, sem diferença alguma.";b="Cadeia obriga repetição de aresta; caminho não.";c="Cadeia permite repetição de vértices (como nos fechos); caminho simples não permite.";d="Cadeia só pode existir em grafos triangulados."} `
  "c" "Cadeia pode revisitar vértices (ex: nos fechos). Caminho simples não repete vértice. Todo caminho é cadeia, mas nem toda cadeia é caminho."

$newBlock += MakeQ 16 16 "Se todos os vizinhos de cada vértice possuem graus mutuamente diferentes entre si, o grafo é:" `
  @{a="Biconexo";b="Bipartido";c="Altamente Irregular";d="Cápsula"} `
  "c" "Altamente Irregular: para cada vértice v, os graus de todos os seus VIZINHOS são distintos entre si."

$newBlock += MakeQ 17 17 "O que ocorre na operação 'Soma' (+) entre dois grafos G1 e G2?" `
  @{a="Somam-se os valores numéricos das matrizes de adjacência.";b="Para cada vértice de G1, cria-se uma aresta conectando-o a todo vértice de G2.";c="Multiplicam-se os graus dos vértices correspondentes.";d="Excluem-se os laços e arestas paralelas de ambos os grafos."} `
  "b" "Soma G1+G2: mantém todos os vértices/arestas originais e acrescenta uma aresta entre cada vértice de G1 e de G2."

$newBlock += MakeQ 18 18 "Um Bloco é formalmente definido como:" `
  @{a="Um subgrafo 2-conexo maximal ou uma aresta simples (K₂).";b="Um grafo trivial de um único vértice.";c="Qualquer ciclo de comprimento ímpar no grafo.";d="O centro geométrico de qualquer grafo planar."} `
  "a" "Bloco = subgrafo biconexo maximal (sem articulação) ou K2. Se um vértice está em dois blocos, é articulação."

$newBlock += MakeQ 19 19 "Se você soma as complexidades O(N) + O(N²), qual é o resultado final?" `
  @{a="O(N³)";b="O(1)";c="O(N)";d="O(N²) — o termo dominante sempre prevalece"} `
  "d" "Na análise assintótica, o maior termo domina e os menores são descartados. O(N)+O(N²) = O(N²)."

$newBlock += MakeQ 20 20 "O que significa a operação de Concatenação (//) em cadeias NÃO ser comutativa?" `
  @{a="Significa que C₁ // C₂ ≠ C₂ // C₁ — a ordem das cadeias importa.";b="Significa que o resultado é sempre o elemento neutro lambda.";c="Significa que a concatenação anula os fechos do grafo.";d="Significa que só ocorre em grafos completos Kₙ."} `
  "a" "C1//C2 emenda o fim de C1 com o início de C2. Inverter a ordem produz um trajeto diferente — por isso não é comutativa."

# Replace lines startLine..endLine with new block
$before = $lines[0..($startLine-1)]
$after = $lines[($endLine+1)..($lines.Count-1)]
$combined = $before + $newBlock + $after
Set-Content $file -Value $combined -Encoding UTF8
Write-Host "Done. Total lines: $($combined.Count)"
