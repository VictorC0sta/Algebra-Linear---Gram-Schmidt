// ====================================
// Função: Gram-Schmidt (clássico/modificado)
// ====================================
function [Q,R,status] = gram_schmidt(A, modo)
    [m,n] = size(A);
    Q = zeros(m,n);
    R = zeros(n,n);
    status = "ok";

    // Verificação de dependência linear
    if rank(A) < n then
        status = "dependente (rank)";
    end

    select modo
    case "classico" then
        for k=1:n
            v = A(:,k);
            for j=1:k-1
                R(j,k) = Q(:,j)' * A(:,k);
                v = v - R(j,k) * Q(:,j);
            end

            R(k,k) = norm(v);

            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
                R(k,k) = 0;
            else
                Q(:,k) = v / R(k,k);
            end
        end

    case "modificado" then
        V = A;
        for k=1:n
            R(k,k) = norm(V(:,k));
            if R(k,k) < 1e-12 then
                disp("⚠️ Vetor linearmente dependente na coluna " + string(k));
                Q(:,k) = zeros(m,1);
                status = "dependente (norma zero)";
                R(k,k) = 0;
            else
                Q(:,k) = V(:,k) / R(k,k);
            end

            for j=k+1:n
                R(k,j) = Q(:,k)' * V(:,j);
                V(:,j) = V(:,j) - R(k,j) * Q(:,k);
            end
        end

    else
        error("Opção inválida: selecione ""classico"" ou ""modificado"".");
    end
endfunction
