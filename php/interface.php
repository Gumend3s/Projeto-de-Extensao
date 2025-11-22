<?php
// Inclui o arquivo de conexão
require_once 'conexao.php';

// --- LÓGICA DE INSERÇÃO (POST) ---
$mensagem = "";
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['acao']) && $_POST['acao'] == 'criar_rotina') {
    try {
        $sql = "INSERT INTO Rotina (idProjeto, idCriador, nome, status, prioridade, recorrenciaRegra) 
                VALUES (:idProjeto, :idCriador, :nome, :status, :prioridade, :recorrenciaRegra)";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':idProjeto' => $_POST['idProjeto'],
            ':idCriador' => $_POST['idCriador'], // Em um sistema real, pegaria da Sessão de Login
            ':nome' => $_POST['nome'],
            ':status' => 'PENDENTE',
            ':prioridade' => $_POST['prioridade'],
            ':recorrenciaRegra' => $_POST['recorrencia']
        ]);
        
        $mensagem = "<div class='alert alert-success'>Rotina criada com sucesso!</div>";
    } catch (Exception $e) {
        $mensagem = "<div class='alert alert-danger'>Erro ao criar rotina: " . $e->getMessage() . "</div>";
    }
}

// --- LÓGICA DE SELEÇÃO (GET) ---

// 1. Buscar Usuários (para preencher o select do formulário)
$usuarios = $pdo->query("SELECT idUsuario, nome FROM Usuario")->fetchAll(PDO::FETCH_ASSOC);

// 2. Buscar Projetos (para preencher o select do formulário)
$projetos = $pdo->query("SELECT idProjeto, nome FROM Projeto")->fetchAll(PDO::FETCH_ASSOC);

// 3. Buscar Rotinas (para a tabela de listagem)
// Fazemos JOINs para mostrar o nome do Projeto e do Criador em vez de apenas os IDs
$sqlListagem = "
    SELECT r.*, p.nome as nome_projeto, u.nome as nome_criador 
    FROM Rotina r
    JOIN Projeto p ON r.idProjeto = p.idProjeto
    JOIN Usuario u ON r.idCriador = u.idUsuario
    ORDER BY r.dataHoraCriacao DESC
";
$rotinas = $pdo->query($sqlListagem)->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Rotinas</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Ícones (FontAwesome) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="#"><i class="fas fa-tasks me-2"></i>Sistema de Rotinas</a>
    </div>
</nav>

<div class="container">
    
    <?= $mensagem ?>

    <div class="row">
        <!-- COLUNA DA ESQUERDA: FORMULÁRIO -->
        <div class="col-md-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0"><i class="fas fa-plus-circle text-primary me-2"></i>Nova Rotina</h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="index.php">
                        <input type="hidden" name="acao" value="criar_rotina">
                        
                        <div class="mb-3">
                            <label class="form-label">Nome da Rotina</label>
                            <input type="text" name="nome" class="form-control" required placeholder="Ex: Relatório Semanal">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Projeto</label>
                            <select name="idProjeto" class="form-select" required>
                                <option value="">Selecione...</option>
                                <?php foreach($projetos as $p): ?>
                                    <option value="<?= $p['idProjeto'] ?>"><?= $p['nome'] ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Responsável (Criador)</label>
                            <select name="idCriador" class="form-select" required>
                                <option value="">Selecione...</option>
                                <?php foreach($usuarios as $u): ?>
                                    <option value="<?= $u['idUsuario'] ?>"><?= $u['nome'] ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Prioridade</label>
                            <select name="prioridade" class="form-select">
                                <option value="BAIXA">Baixa</option>
                                <option value="MEDIA" selected>Média</option>
                                <option value="ALTA">Alta</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Regra de Recorrência</label>
                            <input type="text" name="recorrencia" class="form-control" placeholder="Ex: Toda Segunda-feira">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Salvar Rotina</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- COLUNA DA DIREITA: LISTAGEM -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0"><i class="fas fa-list text-secondary me-2"></i>Rotinas Cadastradas</h5>
                    <span class="badge bg-secondary"><?= count($rotinas) ?> total</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Rotina</th>
                                    <th>Projeto</th>
                                    <th>Prioridade</th>
                                    <th>Status</th>
                                    <th>Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if(count($rotinas) > 0): ?>
                                    <?php foreach($rotinas as $r): ?>
                                        <tr>
                                            <td><?= $r['idRotina'] ?></td>
                                            <td class="fw-bold"><?= htmlspecialchars($r['nome']) ?></td>
                                            <td><?= htmlspecialchars($r['nome_projeto']) ?></td>
                                            <td>
                                                <?php 
                                                    $badgeClass = 'bg-secondary';
                                                    if($r['prioridade'] == 'ALTA') $badgeClass = 'bg-danger';
                                                    if($r['prioridade'] == 'MEDIA') $badgeClass = 'bg-warning text-dark';
                                                    if($r['prioridade'] == 'BAIXA') $badgeClass = 'bg-success';
                                                ?>
                                                <span class="badge <?= $badgeClass ?>"><?= $r['prioridade'] ?></span>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark"><?= $r['status'] ?></span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i></button>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            Nenhuma rotina cadastrada ainda.
                                        </td>
                                    </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>