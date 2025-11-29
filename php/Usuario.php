<?php

class Usuario {
    private $id;
    private $name;
    private $cpf;
    private $email;
    private $passHash;
    private $nivel;
    private $status;
    private $dataHoraInsercao;
    private $idEmpresa;

    public function __construct($id, $name, $cpf, $email, $passHash, $nivel, $status, $dataHoraInsercao, $idEmpresa) {
        $this->id = $id;
        $this->name = $name;
        $this->cpf = $cpf;
        $this->email = $email;
        $this->passHash = $passHash;
        $this->nivel = $nivel;
        $this->status = $status;
        $this->dataHoraInsercao = $dataHoraInsercao;
        $this->idEmpresa = $idEmpresa;
    }

    public function __construct($email, $passHash) {
        $this->email = $email;
        $this->passHash = $passHash;
    }

    public function getUser($email) {
        $stmt = $pdo->prepare("SELECT * FROM Usuario WHERE email = :email");
        $stmt->execute([':email' => $email]);
        $exit = $stmt->fetch(PDO::FETCH_ASSOC);
        return $exit;
    }



}


?>