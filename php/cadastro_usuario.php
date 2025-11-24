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
$nivelUsuario = $_SESSION['nivel'];
$mensagem = "";

// Verifica se o usuário tem permissão (ADMIN ou MASTER)
if ($nivelUsuario != 'ADMIN' && $nivelUsuario != 'MASTER') {
    $mensagem = "<div class='alert alert-danger'>Você não tem permissão para cadastrar usuários.</div>";
}

// === CADASTRO DE USUÁRIO ===
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['acao']) && $_POST['acao'] == 'cadastrar_usuario') {
    
    if ($nivelUsuario == 'ADMIN' || $nivelUsuario == 'MASTER') {
        try {
            // Validações
            if (empty($_POST['nome']) || empty($_POST['cpf']) || empty($_POST['email']) || empty($_POST['senha'])) {
                throw new Exception("Todos os campos são obrigatórios.");
            }

            // Valida CPF (remove caracteres especiais)
            $cpf = preg_replace('/[^0-9]/', '', $_POST['cpf']);
            if (strlen($cpf) != 11) {
                throw new Exception("CPF inválido. Deve conter 11 dígitos.");
            }

            // Verifica se CPF já existe
            $checkCPF = $pdo->prepare("SELECT COUNT(*) FROM Usuario WHERE cpf = :cpf");
            $checkCPF->execute([':cpf' => $cpf]);
            if ($checkCPF->fetchColumn() > 0) {
                throw new Exception("CPF já cadastrado no sistema.");
            }

            // Verifica se email já existe
            $checkEmail = $pdo->prepare("SELECT COUNT(*) FROM Usuario WHERE email = :email");
            $checkEmail->execute([':email' => $_POST['email']]);
            if ($checkEmail->fetchColumn() > 0) {
                throw new Exception("E-mail já cadastrado no sistema.");
            }

            // Validar senha (mínimo 6 caracteres)
            if (strlen($_POST['senha']) < 6) {
                throw new Exception("A senha deve ter no mínimo 6 caracteres.");
            }

            // Hash da senha (compatível com seu login)
            $senhaHash = $_POST['senha']; // Mantendo como texto simples conforme seu sistema atual

            // Determina empresa e nível
            // ADMIN só pode cadastrar usuários na própria empresa
            $empresaCadastro = $idEmpresa;
            $nivel = $_POST['nivel'];

            // ADMIN não pode criar outros ADMIN ou MASTER
            if ($nivelUsuario == 'ADMIN' && ($nivel == 'ADMIN' || $nivel == 'MASTER')) {
                throw new Exception("Você não tem permissão para criar usuários ADMIN ou MASTER.");
            }

            // Inserir usuário
            $sql = "INSERT INTO Usuario (idEmpresa, nome, cpf, email, senhaHash, nivel, status) 
                    VALUES (:idEmpresa, :nome, :cpf, :email, :senhaHash, :nivel, 'ATIVO')";

            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                ':idEmpresa' => $empresaCadastro,
                ':nome'      => $_POST['nome'],
                ':cpf'       => $cpf,
                ':email'     => $_POST['email'],
                ':senhaHash' => $senhaHash,
                ':nivel'     => $nivel
            ]);

            // Redireciona para evitar reenvio de formulário (padrão PRG)
            $_SESSION['mensagem'] = "<div class='alert alert-success'>
                <i class='fas fa-check-circle'></i> Usuário cadastrado com sucesso!
            </div>";
            header("Location: cadastro_usuario.php");
            exit;

        } catch (Exception $e) {
            $_SESSION['mensagem'] = "<div class='alert alert-danger'>
                <i class='fas fa-exclamation-circle'></i> Erro: " . $e->getMessage() . "
            </div>";
            header("Location: cadastro_usuario.php");
            exit;
        }
    }
}

// Exibe mensagem da sessão (se existir) e limpa
if (isset($_SESSION['mensagem'])) {
    $mensagem = $_SESSION['mensagem'];
    unset($_SESSION['mensagem']);
}

// === BUSCAR USUÁRIOS DA MESMA EMPRESA ===
$sqlUsuarios = "
    SELECT u.*, e.nome AS nome_empresa
    FROM Usuario u
    JOIN Empresa e ON u.idEmpresa = e.idEmpresa
    WHERE u.idEmpresa = :idEmpresa
    ORDER BY u.dataHoraInsercao DESC
";
$stmt = $pdo->prepare($sqlUsuarios);
$stmt->execute([':idEmpresa' => $idEmpresa]);
$usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Usuários</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container">
        <a class="navbar-brand" href="interface.php">
            <i class="fas fa-arrow-left me-2"></i>Voltar às Rotinas
        </a>

        <span class="text-white">
            <i class="fas fa-user me-2"></i><strong><?= $_SESSION['nome'] ?></strong>
            <span class="badge bg-light text-primary ms-2"><?= $nivelUsuario ?></span>
        </span>

        <a href="logout.php" class="btn btn-light btn-sm ms-3">Sair</a>
    </div>
</nav>

<div class="container">

    <?= $mensagem ?>

    <div class="row">

        <!-- FORMULÁRIO DE CADASTRO -->
        <div class="col-md-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-user-plus text-primary me-2"></i>Cadastrar Usuário
                    </h5>
                </div>

                <div class="card-body">
                    <?php if ($nivelUsuario == 'ADMIN' || $nivelUsuario == 'MASTER'): ?>
                    <form method="POST">
                        <input type="hidden" name="acao" value="cadastrar_usuario">

                        <div class="mb-3">
                            <label class="form-label">Nome Completo</label>
                            <input type="text" name="nome" class="form-control" 
                                   placeholder="Ex: João Silva" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">CPF</label>
                            <input type="text" name="cpf" class="form-control" 
                                   placeholder="000.000.000-00" 
                                   maxlength="14" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">E-mail</label>
                            <input type="email" name="email" class="form-control" 
                                   placeholder="usuario@empresa.com" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Senha</label>
                            <input type="password" name="senha" class="form-control" 
                                   placeholder="Mínimo 6 caracteres" 
                                   minlength="6" required>
                            <small class="text-muted">Mínimo 6 caracteres</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nível de Acesso</label>
                            <select name="nivel" class="form-select" required>
                                <option value="FUNCIONARIO">Funcionário</option>
                                <?php if ($nivelUsuario == 'MASTER'): ?>
                                    <option value="ADMIN">Admin</option>
                                    <option value="MASTER">Master</option>
                                <?php endif; ?>
                            </select>
                            <small class="text-muted">
                                <?php if ($nivelUsuario == 'ADMIN'): ?>
                                    Você só pode criar Funcionários
                                <?php endif; ?>
                            </small>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Cadastrar Usuário
                            </button>
                        </div>
                    </form>
                    <?php else: ?>
                        <div class="alert alert-warning">
                            <i class="fas fa-lock me-2"></i>
                            Apenas ADMIN e MASTER podem cadastrar usuários.
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <!-- LISTAGEM DE USUÁRIOS -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-users me-2"></i>Usuários da Empresa
                    </h5>
                    <span class="badge bg-secondary"><?= count($usuarios) ?> usuários</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Nome</th>
                                <th>E-mail</th>
                                <th>CPF</th>
                                <th>Nível</th>
                                <th>Status</th>
                                <th>Cadastro</th>
                            </tr>
                        </thead>

                        <tbody>
                        <?php if ($usuarios): ?>
                            <?php foreach ($usuarios as $u): ?>
                                <tr>
                                    <td><?= $u['idUsuario'] ?></td>
                                    <td>
                                        <strong><?= htmlspecialchars($u['nome']) ?></strong>
                                        <?php if ($u['idUsuario'] == $idUsuario): ?>
                                            <span class="badge bg-info text-white ms-1">Você</span>
                                        <?php endif; ?>
                                    </td>
                                    <td><?= htmlspecialchars($u['email']) ?></td>
                                    <td><?= htmlspecialchars($u['cpf']) ?></td>
                                    <td>
                                        <?php 
                                            $nivelClass = [
                                                'MASTER' => 'bg-danger',
                                                'ADMIN' => 'bg-warning text-dark',
                                                'FUNCIONARIO' => 'bg-primary'
                                            ][$u['nivel']] ?? 'bg-secondary';
                                        ?>
                                        <span class="badge <?= $nivelClass ?>"><?= $u['nivel'] ?></span>
                                    </td>
                                    <td>
                                        <?php 
                                            $statusClass = [
                                                'ATIVO' => 'bg-success',
                                                'INATIVO' => 'bg-secondary',
                                                'BLOQUEADO' => 'bg-danger'
                                            ][$u['status']] ?? 'bg-secondary';
                                        ?>
                                        <span class="badge <?= $statusClass ?>"><?= $u['status'] ?></span>
                                    </td>
                                    <td>
                                        <small class="text-muted">
                                            <?= date('d/m/Y', strtotime($u['dataHoraInsercao'])) ?>
                                        </small>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    Nenhum usuário encontrado.
                                </td>
                            </tr>
                        <?php endif; ?>
                        </tbody>

                    </table>
                </div>
            </div>

            <!-- LEGENDA -->
            <div class="card shadow-sm mt-3">
                <div class="card-body">
                    <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Níveis de Acesso</h6>
                    <div class="row">
                        <div class="col-md-4">
                            <span class="badge bg-danger me-2">MASTER</span>
                            <small>Acesso total ao sistema</small>
                        </div>
                        <div class="col-md-4">
                            <span class="badge bg-warning text-dark me-2">ADMIN</span>
                            <small>Gerencia usuários e rotinas</small>
                        </div>
                        <div class="col-md-4">
                            <span class="badge bg-primary me-2">FUNCIONARIO</span>
                            <small>Executa rotinas delegadas</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
// Máscara de CPF
document.querySelector('input[name="cpf"]')?.addEventListener('input', function (e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value.length <= 11) {
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
        e.target.value = value;
    }
});
</script>

</body>
</html>