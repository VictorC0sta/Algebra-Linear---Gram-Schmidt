// ============================================================================
// Função: gram_schmidt(A, modo)
// Realiza o processo de ortonormalização de Gram-Schmidt.
// Parâmetros:
//    A    -> Matriz de entrada (m×n), cujas colunas serão ortonormalizadas
//    modo -> "classico"  : Gram-Schmidt tradicional
//            "modificado": Gram-Schmidt estabilizado numericamente
//
// Retorna:
//    Q -> Matriz ortonormal resultante
//    R -> Matriz triangular superior
//    status -> Indica se houve dependência linear
// ============================================================================
function [Q,R,status] = gram_schmidt(A, modo)
    
    [m,n] = size(A);      // m = linhas | n = colunas
    Q = zeros(m,n);       // Inicializa matriz Q
    R = zeros(n,n);       // Inicializa matriz R
    status = "ok";        // Status padrão

    // Verifica se as colunas são linearmente independentes
    if rank(A) < n then
        status = "dependente (rank)";  // Já sabemos que existe dependência
    end

    // Escolha do tipo de algoritmo
    select modo

    // ========================================================================
    // GRAM-SCHMIDT CLÁSSICO
    // ========================================================================
    case "classico" then
        for k=1:n
            v = A(:,k);   // Começamos com a coluna atual

            // Subtrai projeções nos vetores anteriores já ortonormalizados
            for j=1:k-1
                R(j,k) = Q(:,j)' * A(:,k);   // Coeficiente de projeção
                v = v - R(j,k) * Q(:,j);     // Remove componente na direção de Q(:,j)
            end

            // Norma do vetor resultante
            R(k,k) = norm(v);

            // Se norma muito pequena → dependência linear detectada
            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
            else
                Q(:,k) = v / R(k,k); // Normaliza o vetor
            end
        end

    // ========================================================================
    // GRAM-SCHMIDT MODIFICADO (MAIS ESTÁVEL NUMERICAMENTE)
    // ========================================================================
    case "modificado" then
        V = A;   // Copiamos A para operar progressivamente
        for k=1:n
            R(k,k) = norm(V(:,k));  // Norma do vetor atual

            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
            else
                Q(:,k) = V(:,k) / R(k,k); // Normaliza primeiro (diferença chave)
            end

            // Remove projeções nos próximos vetores
            for j=k+1:n
                R(k,j) = Q(:,k)' * V(:,j);
                V(:,j) = V(:,j) - R(k,j) * Q(:,k);
            end
        end

    // ========================================================================
    // ERRO NO MODO INFORMADO
    // ========================================================================
    else
        error("Opção inválida: selecione ""classico"" ou ""modificado"".");
    end
endfunction



// ============================================================================
// Função auxiliar: mostrar_resultado(A,Q,R,modo)
// Exibe as matrizes e calcula o erro ||I - Q'Q||_F (erro de ortonormalidade)
// ============================================================================
function erro = mostrar_resultado(A, Q, R, modo)

    printf("\n================================================\n");
    printf("                 MÉTODO: %s\n", modo);
    printf("================================================\n\n");

    printf("Matriz A:\n"); disp(A); printf("\n");
    printf("Matriz Q (ortonormal):\n"); disp(Q); printf("\n");
    printf("Matriz R (triangular superior):\n"); disp(R); printf("\n");

    QT = Q';                  // Transposta de Q
    n = size(Q,2);            // Número de vetores
    erro = norm(eye(n) - QT*Q, "fro");   // Cálculo do erro de ortonormalidade

endfunction



// ============================================================================
// Função: run_tests()
// Executa 5 testes padrão recomendados em livros de Álgebra Linear
// ============================================================================
function run_tests()

    clc();
    printf("===============================================\n");
    printf("      TESTES OBRIGATÓRIOS - GRAM-SCHMIDT\n");
    printf("===============================================\n\n");

    // TESTE 1 - Base já ortonormal
    A1 = [1 0; 0 1];
    mostrar_resultado(A1, gram_schmidt(A1,"classico")(1), gram_schmidt(A1,"classico")(2), "clássico");

    // TESTE 2 - Base qualquer independente
    A2 = [1 1; 1 0];
    [Q1,R1,status1] = gram_schmidt(A2,"classico");
    [Q2,R2,status2] = gram_schmidt(A2,"modificado");
    erro_c = mostrar_resultado(A2,Q1,R1,"clássico");
    erro_m = mostrar_resultado(A2,Q2,R2,"modificado");

    // TESTE 3 - 3 vetores não ortogonais
    A3 = [1 1 0; 1 0 1; 0 1 1];
    [Q,R,status] = gram_schmidt(A3,"modificado");
    mostrar_resultado(A3,Q,R,"modificado");

    // TESTE 4 - Matriz mal condicionada
    A4 = [1 1; 1 1.00001];
    [Qc,Rc,sc] = gram_schmidt(A4,"classico");
    [Qm,Rm,sm] = gram_schmidt(A4,"modificado");
    erro_c = mostrar_resultado(A4,Qc,Rc,"clássico");
    erro_m = mostrar_resultado(A4,Qm,Rm,"modificado");

    // TESTE 5 - Base dependente
    A5 = [1 2 3; 2 4 6; 3 6 9];
    [Q,R,status] = gram_schmidt(A5,"classico");
endfunction



// ============================================================================
// Menu principal para o usuário inserir matrizes
// ============================================================================
function menu_principal()
    while %t
        clc();
        printf("=======================================\n");
        printf("      PROCESSO DE GRAM-SCHMIDT\n");
        printf("=======================================\n");
        printf("1 - Rodar testes obrigatórios\n");
        printf("2 - Inserir minha própria matriz\n");
        printf("0 - Sair\n");
        opcao = input("Escolha: ");

        select opcao
        case 1 then
            run_tests();
            input("Pressione Enter para continuar...");
        case 2 then
            sub_menu();
        case 0 then
            break;
        else
            printf("Opção inválida!\n");
        end
    end
endfunction



// ============================================================================
// Submenu: Entrada manual de matriz
// ============================================================================
function sub_menu()
    clc();
    printf("1 - Gram-Schmidt Clássico\n");
    printf("2 - Gram-Schmidt Modificado\n");
    metodo = input("Opção: ");

    select metodo
    case 1 then modo = "classico";
    case 2 then modo = "modificado";
    else
        printf("Opção inválida!\n"); return;
    end

    m = input("Número de linhas: ");
    n = input("Número de colunas: ");
    A = zeros(m,n);

    for i=1:m
        for j=1:n
            A(i,j) = input("A(" + string(i) + "," + string(j) + ") = ");
        end
    end

    [Q,R,status] = gram_schmidt(A, modo);
    mostrar_resultado(A,Q,R,modo);
    input("Pressione Enter para continuar...");
endfunction

// Executa o menu
menu_principal();
