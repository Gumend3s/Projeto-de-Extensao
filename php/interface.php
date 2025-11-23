<?php
session_start();
require_once 'conexao.php';

// Verifica se usuário está logado
if (!isset($_SESSION['idUsuario'])) {
    header("Location: login.php");
    exit;
}

$idUsuario = $_SESSION['idUsuario'];
$idEmpresa = $_SESSION['idEmpresa'];
$mensagem = "";

// === INSERÇÃO DE ROTINA ===
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['acao']) && $_POST['acao'] == 'criar_rotina') {

    try {
        // Verifica se o projeto pertence à empresa do usuário (através do criador)
        $check = $pdo->prepare("
            SELECT COUNT(*) 
            FROM Projeto p
            JOIN Usuario u ON p.idCriador = u.idUsuario
            WHERE p.idProjeto = :id AND u.idEmpresa = :emp
        ");
        $check->execute([':id' => $_POST['idProjeto'], ':emp' => $idEmpresa]);

        if ($check->fetchColumn() == 0) {
            throw new Exception("Você não pode criar rotinas em projetos de outra empresa.");
        }

        // Inserir rotina
        $sql = "INSERT INTO Rotina (idProjeto, idCriador, nome, status, prioridade, recorrenciaRegra) 
                VALUES (:idProjeto, :idCriador, :nome, :status, :prioridade, :recorrenciaRegra)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':idProjeto'      => $_POST['idProjeto'],
            ':idCriador'      => $idUsuario, // SEMPRE O USUÁRIO LOGADO
            ':nome'           => $_POST['nome'],
            ':status'         => 'PENDENTE',
            ':prioridade'     => $_POST['prioridade'],
            ':recorrenciaRegra' => $_POST['recorrencia']
        ]);

        $mensagem = "<div class='alert alert-success'>Rotina criada com sucesso!</div>";

    } catch (Exception $e) {
        $mensagem = "<div class='alert alert-danger'>Erro ao criar rotina: " . $e->getMessage() . "</div>";
    }
}

// === BUSCAR PROJETOS DA MESMA EMPRESA (através do criador) ===
$sqlProjetos = "
    SELECT p.idProjeto, p.nome 
    FROM Projeto p
    JOIN Usuario u ON p.idCriador = u.idUsuario
    WHERE u.idEmpresa = :idEmpresa
";
$stmt = $pdo->prepare($sqlProjetos);
$stmt->execute([':idEmpresa' => $idEmpresa]);
$projetos = $stmt->fetchAll(PDO::FETCH_ASSOC);

// === BUSCAR ROTINAS DA EMPRESA DO USUÁRIO ===
$sqlListagem = "
    SELECT r.*, p.nome AS nome_projeto, u.nome AS nome_criador
    FROM Rotina r
    JOIN Projeto p ON r.idProjeto = p.idProjeto
    JOIN Usuario uc ON p.idCriador = uc.idUsuario
    JOIN Usuario u ON r.idCriador = u.idUsuario
    WHERE uc.idEmpresa = :idEmpresa
    ORDER BY r.dataHoraCriacao DESC
";
$stmt = $pdo->prepare($sqlListagem);
$stmt->execute([':idEmpresa' => $idEmpresa]);
$rotinas = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Rotinas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="#"><i class="fas fa-tasks me-2"></i>Sistema de Rotinas</a>

        <span class="text-white">
            Olá, <strong><?= $_SESSION['nome'] ?></strong>
        </span>

        <a href="logout.php" class="btn btn-light btn-sm ms-3">Sair</a>
    </div>
</nav>

<div class="container">

    <?= $mensagem ?>

    <div class="row">

        <!-- FORMULÁRIO -->
        <div class="col-md-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-plus-circle text-primary me-2"></i>Nova Rotina
                    </h5>
                </div>

                <div class="card-body">
                    <form method="POST">
                        <input type="hidden" name="acao" value="criar_rotina">

                        <div class="mb-3">
                            <label class="form-label">Nome da Rotina</label>
                            <input type="text" name="nome" class="form-control" required>
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
                            <label class="form-label">Prioridade</label>
                            <select name="prioridade" class="form-select">
                                <option value="BAIXA">Baixa</option>
                                <option value="MEDIA" selected>Média</option>
                                <option value="ALTA">Alta</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Regra de Recorrência</label>
                            <input type="text" name="recorrencia" class="form-control" placeholder="Ex: Diariamente, Segunda a Sexta">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Salvar Rotina</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- LISTAGEM -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0"><i class="fas fa-list me-2"></i>Rotinas</h5>
                    <span class="badge bg-secondary"><?= count($rotinas) ?> total</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Rotina</th>
                                <th>Projeto</th>
                                <th>Criador</th>
                                <th>Prioridade</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>
                        <?php if ($rotinas): ?>
                            <?php foreach ($rotinas as $r): ?>
                                <tr>
                                    <td><?= $r['idRotina'] ?></td>
                                    <td><?= htmlspecialchars($r['nome']) ?></td>
                                    <td><?= htmlspecialchars($r['nome_projeto']) ?></td>
                                    <td><?= htmlspecialchars($r['nome_criador']) ?></td>

                                    <td>
                                        <?php 
                                            $class = [
                                                'ALTA' => 'bg-danger',
                                                'MEDIA' => 'bg-warning text-dark',
                                                'BAIXA' => 'bg-success'
                                            ][$r['prioridade']] ?? 'bg-secondary';
                                        ?>
                                        <span class="badge <?= $class ?>"><?= $r['prioridade'] ?></span>
                                    </td>

                                    <td><span class="badge bg-info"><?= $r['status'] ?></span></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    Nenhuma rotina encontrada.
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

</body>
</html>