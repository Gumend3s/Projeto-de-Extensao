<?php
session_start();
require_once 'conexao.php';

$erro = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $senha = $_POST['senha'];

    // Busca o usuário pelo email
    $stmt = $pdo->prepare("SELECT * FROM Usuario WHERE email = :email");
    $stmt->execute([':email' => $email]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    // Verifica se usuário existe E se a senha bate com o hash
    if ($usuario && $senha === $usuario['senhaHash']) {

        // Verifica se o status é ATIVO
        if ($usuario['status'] != 'ATIVO') {
            $erro = "Usuário bloqueado ou inativo.";
        } else {

            // Salva dados na sessão
            $_SESSION['idUsuario'] = $usuario['idUsuario'];
            $_SESSION['nome'] = $usuario['nome'];
            $_SESSION['idEmpresa'] = $usuario['idEmpresa'];
            $_SESSION['nivel'] = $usuario['nivel'];

            // Redireciona para o painel
            header('Location: interface.php');
            exit;
        }

    } else {
        $erro = "E-mail ou senha incorretos.";
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Login - Sistema de Rotinas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card-login { width: 100%; max-width: 400px; }
    </style>
</head>
<body>
    <div class="card card-login shadow">
        <div class="card-body p-4">
            <h4 class="text-center mb-4">Acesso ao Sistema</h4>
            
            <?php if($erro): ?>
                <div class="alert alert-danger"><?= $erro ?></div>
            <?php endif; ?>

            <form method="POST">
                <div class="mb-3">
                    <label class="form-label">E-mail</label>
                    <input type="email" name="email" class="form-control" required placeholder="admin@empresa.com">
                </div>
                <div class="mb-3">
                    <label class="form-label">Senha</label>
                    <input type="password" name="senha" class="form-control" required placeholder="******">
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Entrar</button>
                </div>
            </form>
            <div class="text-center mt-3">
                <small class="text-muted">Use: ana.pereira@tech.com / 123</small>
            </div>
        </div>
    </div>
</body>
</html>