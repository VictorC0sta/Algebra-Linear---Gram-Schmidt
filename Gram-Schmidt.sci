// ====================================
// Função: Gram-Schmidt (Clássico / Modificado)
// Entrada:
//   A    -> Matriz de entrada (m x n)
//   modo -> "classico" ou "modificado"
// Saída:
//   Q    -> Matriz ortonormal (m x n)
//   R    -> Matriz triangular superior (n x n)
//   status -> Indica se houve dependência linear
// ====================================
function [Q,R,status] = gram_schmidt(A, modo)
    
    // Dimensões de A
    [m,n] = size(A);
    
    // Inicialização das matrizes Q e R
    Q = zeros(m,n);   // Vetores ortonormais
    R = zeros(n,n);   // Coeficientes de projeção
    status = "ok";    // Estado inicial

    // Verifica se as colunas são linearmente independentes
    if rank(A) < n then
        status = "dependente (rank)";
    end

    // ==========================================================
    // Método Gram-Schmidt Clássico
    // ==========================================================
    select modo
    case "classico" then
        
        for k=1:n
            // Começamos com o k-ésimo vetor de A
            v = A(:,k);

            // Subtraímos as projeções nos vetores já ortonormalizados
            for j=1:k-1
                // Coeficiente da projeção de A(:,k) sobre Q(:,j)
                R(j,k) = Q(:,j)' * A(:,k);
                
                // Remove da direção de Q(:,j)
                v = v - R(j,k) * Q(:,j);
            end

            // Norma do vetor resultante
            R(k,k) = norm(v);

            // Se a norma for zero → dependência linear
            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
                R(k,k) = 0;
            else
                // Normaliza para obter vetor unitário
                Q(:,k) = v / R(k,k);
            end
        end

    // ==========================================================
    // Método Gram-Schmidt Modificado (mais estável numericamente)
    // ==========================================================
    case "modificado" then
        
        // Copiamos A para uma versão ajustável
        V = A;

        for k=1:n
            
            // Norma do k-ésimo vetor
            R(k,k) = norm(V(:,k));

            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
                R(k,k) = 0;
            else
                // Normaliza
                Q(:,k) = V(:,k) / R(k,k);
            end

            // Remove diretamente das colunas seguintes (evita erros de arredondamento)
            for j=k+1:n
                R(k,j) = Q(:,k)' * V(:,j);
                V(:,j) = V(:,j) - R(k,j) * Q(:,k);
            end
        end

    // ==========================================================
    // Opção inválida
    // ==========================================================
    else
        error("Opção inválida: selecione ""classico"" ou ""modificado"".");
    end
endfunction
