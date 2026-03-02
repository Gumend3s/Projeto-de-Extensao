<?php
require_once 'conexao.php';

class Usuario {
    private ?int $id;
    private ?string $name;
    private ?string $cpf;
    private ?string $email;
    private ?string $passHash;
    private ?string $nivel;
    private ?string $status;
    private ?string $dataHoraInsercao;
    private ?int $idEmpresa;

    public function __construct(
        ?int $id=null, 
        ?string $name=null, 
        ?string $cpf=null, 
        ?string $email=null, 
        ?string $passHash=null, 
        ?string $nivel=null, 
        ?string $status=null, 
        ?string $dataHoraInsercao=null, 
        ?int $idEmpresa=null
        ) {
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

    private function getUserEmail($pdo,$email) {
        $stmt = $pdo->prepare("SELECT * FROM Usuario WHERE email = :email");
        $stmt->execute([':email' => $email]);
        $exit = $stmt->fetch(PDO::FETCH_ASSOC);
        return $exit;
    }

    public function createClassUser($pdo,$email,$password) {
            $array = $this->getUserEmail($pdo,$email);

            if (!$array) {
                return false;
            }
            $this->id = $array['idUsuario'];
            $this->name = $array['nome'];
            $this->cpf = $array['cpf'];
            $this->email = $array['email'];
            $this->passHash = $array['senhaHash'];
            $this->nivel = $array['nivel'];
            $this->status = $array['status'];
            $this->dataHoraInsercao = $array['dataHoraInsercao'];
            $this->idEmpresa = $array['idEmpresa'];
    }

    public function getAcess($passwordPost) {
        $password = $this->getPassword();
        if($password==$passwordPost){
            return true;
        } else {
            return false;
        }
    }

    public function getAtivity() {
        if($this->getStatus()!='ATIVO'){
            return true;
        } else {
            return false;
        }
    }

    public function getNivelAcess() {
        if($this->getNivel()=='ADMIN' || $this->getNivel()=='MASTER'){
            return true;
        } else {
            return false;
        }
    }
    public function createSessionUser() {
        if ($this->id === null) return false;

        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        $_SESSION['idUsuario'] = $this->id;
        $_SESSION['nome']      = $this->name;
        $_SESSION['idEmpresa'] = $this->idEmpresa;
        $_SESSION['nivel']     = $this->nivel;

        return true;
    }

    private function getPassword() {
        return $this->passHash;
    }
    private function getId() {
        return $this->id;
    }
    private function getName() {
        return $this->name;
    }
    private function getNivel() {
        return $this->nivel;
    }
    private function getStatus() {
        return $this->status;
    }
    private function getIdEmpresa() {
        return $this->idEmpresa;
    }



}


?>