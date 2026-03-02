<?php
session_start();
require_once 'conexao.php';
require_once 'Usuario.php';

$erro = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $userSession = new Usuario();

    $userSession->createClassUser($pdo,$_POST['email'],$_POST['senha']);
    
    if ($userSession&&$userSession->getAcess($_POST['senha'])) {

        
        if ($userSession->getAtivity()) {
            $erro = "Usuário bloqueado ou inativo.";
        }

        if ($userSession->getNivelAcess()) {
            if ($userSession->createSessionUser()) {
                    header('Location: interface.php');
                    exit;
                } else {
                    $erro = "Falha ao criar sessão do usuário.";
                }
            
        } 
        else {
            $erro = "Acesso negado. Apenas administradores podem fazer login.";

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