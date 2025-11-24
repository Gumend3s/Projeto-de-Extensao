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

// Insersão de rotina
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

        // Preparar dataLimite se preenchida
        $dataLimite = null;
        if (!empty($_POST['dataLimite']) && !empty($_POST['horaLimite'])) {
            $dataLimite = $_POST['dataLimite'] . ' ' . $_POST['horaLimite'] . ':00';
        }

        // Inserir rotina
        $sql = "INSERT INTO Rotina (idProjeto, idCriador, nome, status, prioridade, recorrenciaRegra, dataLimite) 
                VALUES (:idProjeto, :idCriador, :nome, :status, :prioridade, :recorrenciaRegra, :dataLimite)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':idProjeto'      => $_POST['idProjeto'],
            ':idCriador'      => $idUsuario,
            ':nome'           => $_POST['nome'],
            ':status'         => 'PENDENTE',
            ':prioridade'     => $_POST['prioridade'],
            ':recorrenciaRegra' => $_POST['recorrencia'],
            ':dataLimite'     => $dataLimite
        ]);

        // Redireciona para evitar reenvio de formulário por padrão PRG(Post-Redirect-Get)
        $_SESSION['mensagem'] = "<div class='alert alert-success'>Rotina criada com sucesso!</div>";
        header("Location: interface.php");
        exit;

    } catch (Exception $e) {
        $_SESSION['mensagem'] = "<div class='alert alert-danger'>Erro ao criar rotina: " . $e->getMessage() . "</div>";
        header("Location: interface.php");
        exit;
    }
}

// Exibe mensagem da sessão(se existir) e limpa
if (isset($_SESSION['mensagem'])) {
    $mensagem = $_SESSION['mensagem'];
    unset($_SESSION['mensagem']);
}

// Busca projetos da mesma empresa pelo criador
$sqlProjetos = "
    SELECT p.idProjeto, p.nome 
    FROM Projeto p
    JOIN Usuario u ON p.idCriador = u.idUsuario
    WHERE u.idEmpresa = :idEmpresa
";
$stmt = $pdo->prepare($sqlProjetos);
$stmt->execute([':idEmpresa' => $idEmpresa]);
$projetos = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Busca rotinas da empresa do usuário
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
    <style>
        .table td {
            vertical-align: middle;
        }
        .prazo-vencido {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="#"><i class="fas fa-tasks me-2"></i>Sistema de Rotinas</a>

        <div class="d-flex align-items-center">
            <span class="text-white me-3">
                Olá, <strong><?= $_SESSION['nome'] ?></strong>
                <span class="badge bg-light text-primary ms-2"><?= $_SESSION['nivel'] ?></span>
            </span>

            <?php if ($_SESSION['nivel'] == 'ADMIN' || $_SESSION['nivel'] == 'MASTER'): ?>
                <a href="cadastro_usuario.php" class="btn btn-light btn-sm me-2">
                    <i class="fas fa-user-plus me-1"></i>Usuários
                </a>
            <?php endif; ?>

            <a href="logout.php" class="btn btn-outline-light btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i>Sair
            </a>
        </div>
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
                            <label class="form-label">Data Limite</label>
                            <input type="date" name="dataLimite" class="form-control">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Hora Limite</label>
                            <input type="time" name="horaLimite" class="form-control">
                            <small class="text-muted">Opcional - defina o prazo final</small>
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
                                <th>Prazo</th>
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

                                    <td>
                                        <?php if ($r['dataLimite']): ?>
                                            <?php 
                                                $dataLimite = new DateTime($r['dataLimite']);
                                                $agora = new DateTime();
                                                $diff = $agora->diff($dataLimite);
                                                $diasRestantes = ($dataLimite > $agora) ? $diff->days : -$diff->days;
                                                
                                                // Define cor baseado no prazo
                                                if ($diasRestantes < 0) {
                                                    $prazoClass = 'text-danger fw-bold';
                                                    $prazoIcon = 'fa-exclamation-triangle';
                                                } elseif ($diasRestantes <= 2) {
                                                    $prazoClass = 'text-warning fw-bold';
                                                    $prazoIcon = 'fa-clock';
                                                } else {
                                                    $prazoClass = 'text-muted';
                                                    $prazoIcon = 'fa-calendar';
                                                }
                                            ?>
                                            <small class="<?= $prazoClass ?>">
                                                <i class="fas <?= $prazoIcon ?> me-1"></i>
                                                <?= $dataLimite->format('d/m/Y H:i') ?>
                                            </small>
                                        <?php else: ?>
                                            <small class="text-muted">Sem prazo</small>
                                        <?php endif; ?>
                                    </td>

                                    <td><span class="badge bg-info"><?= $r['status'] ?></span></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
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