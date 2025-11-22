<?php
/*
 * conexao.php
 * Responsável por estabelecer a conexão com o banco de dados MySQL
 */

// Configurações do Banco de Dados
$host = 'localhost';      // Geralmente 'localhost' em servidores locais
$dbname = 'nome_do_seu_banco'; // SUBSTITUA PELO NOME DO SEU BANCO (ex: rotinas_db)
$username = 'root';       // Usuário padrão do XAMPP é 'root'
$password = '';           // Senha padrão do XAMPP é vazia ''

try {
    // Criação da conexão PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    
    // Configura o PDO para lançar exceções em caso de erro (bom para debug)
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
} catch (PDOException $e) {
    // Em caso de erro, para a execução e mostra mensagem
    die("Erro na conexão com o banco de dados: " . $e->getMessage());
}
?>