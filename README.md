<h1 align="center">Método de Gram-Schmidt em Scilab</h1>

<h2>📌 Descrição</h2>
<p>
Este projeto implementa os métodos de 
<strong>Gram-Schmidt Clássico</strong> e <strong>Gram-Schmidt Modificado</strong> 
para ortonormalização de vetores em Scilab. A partir de uma matriz 
<span style="font-style: italic;">A</span> (de vetores coluna), o algoritmo gera:
</p>

<ul>
  <li><strong>Q</strong> — matriz ortonormal</li>
  <li><strong>R</strong> — matriz triangular superior</li>
  <li><strong>Status</strong> — indica se foi detectada dependência linear</li>
</ul>

<p>
O código ainda trata situações importantes como:
</p>
<ul>
  <li>Vetores linearmente dependentes</li>
  <li>Norma próxima de zero (erro numérico)</li>
  <li>Comparação entre os métodos clássico e modificado</li>
</ul>

<hr>

<h2>📂 Estrutura dos Arquivos</h2>
<ul>
  <li><strong>gram-schmidt.sci</strong> → Contém a função <code>gram_schmidt(A, modo)</code></li>
  <li><strong>testes.sci</strong> → Conjunto de testes obrigatórios já configurados</li>
  <li><strong>maingram-schmidt.sce</strong> → Script principal com menu e execução dos testes</li>
</ul>

<hr>

<h2>▶️ Como Executar</h2>

<h3>1. Abrir o Scilab</h3>
<p>Inicie o Scilab normalmente.</p>

<h3>2. Navegar até a pasta do projeto</h3>
<pre><code>cd 'C:\caminho\da\pasta';
</code></pre>

<h3>3. Executar o programa principal</h3>
<pre><code>exec('main_gram.sce', -1);
</code></pre>

<h3>4. Uso</h3>
<p>O programa exibe um menu interativo:</p>
<ul>
  <li><strong>1</strong> → Executa automaticamente os testes</li>
  <li><strong>2</strong> → Permite inserir manualmente uma matriz para ortonormalizar</li>
  <li><strong>0</strong> → Finaliza o programa</li>
</ul>

<hr>

<h2>✅ Casos de Teste Obrigatórios</h2>

<ol>
  <li>
    <strong>Base já ortonormal</strong><br>
    A = [[1, 0], [0, 1]]<br>
    Resultado esperado: Q = A e R = I.<br>
    O método confirma corretamente.
  </li>

  <li>
    <strong>Base linearmente independente</strong><br>
    A = [[1, 1], [1, 0]]<br>
    Foram comparados os métodos <em>clássico</em> e <em>modificado</em>.<br>
    Ambos retornaram os mesmos Q e R, indicando boa estabilidade numérica.
  </li>

  <li>
    <strong>Base não ortogonal em 3D</strong><br>
    A = [[1, 1, 0], [1, 0, 1], [0, 1, 1]]<br>
    O método modificado produziu uma matriz Q claramente ortonormal e R triangular superior.
  </li>

  <li>
    <strong>Base mal-condicionada</strong><br>
    A = [[1, 1], [1, 1.00001]]<br>
    O método modificado foi capaz de manter maior estabilidade numérica na construção de Q e R.
  </li>

  <li>
    <strong>Base linearmente dependente</strong><br>
    A = [[1, 2, 3], [2, 4, 6], [3, 6, 9]]<br>
    O programa detectou corretamente dependência linear:<br>
    <code>⚠️ Vetor linearmente dependente na coluna 2</code><br>
    <code>⚠️ Vetor linearmente dependente na coluna 3</code>
  </li>
</ol>

<hr>

<h2>📖 Observações</h2>
<ul>
  <li>A matriz <strong>R</strong> resultante é sempre <strong>triangular superior</strong>.</li>
  <li>Se a norma de algum vetor intermediário for ~0, o algoritmo marca dependência.</li>
  <li>O método <strong>modificado</strong> é recomendado para evitar perda de precisão.</li>
</ul>

<hr>

<p>
📌 <strong>Disciplina:</strong> Álgebra Linear<br>
📌 <strong>Alunos:</strong> João Victor da Costa Cerqueira e Lucas Guerra de Araújo — Engenharia da Computação
</p>

