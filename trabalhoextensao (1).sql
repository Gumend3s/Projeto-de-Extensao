CREATE TABLE empresa (
  idEmpresa int NOT NULL PRIMARY KEY,
  nome varchar(255) NOT NULL
);

CREATE TABLE usuario (
  idUsuario int NOT NULL PRIMARY KEY,
  nome varchar(255) NOT NULL,
  cpf varchar(14) NOT NULL UNIQUE,
  email varchar(255) NOT NULL UNIQUE,
  senhaHash varchar(255),
  nivel enum('MASTER','ADMINISTRADOR','FUNCIONARIO') NOT NULL,
  status enum('ATIVO','INATIVO','ARQUIVADO') NOT NULL DEFAULT 'ATIVO',
  dataHoraInsercao datetime NOT NULL DEFAULT current_timestamp(),
  idEmpresa int,
  provedorSocial varchar(50),
  idSocial varchar(255),
  segredo2FA varchar(100),
  FOREIGN KEY (idEmpresa) REFERENCES empresa (idEmpresa) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE logsistema (
  idLog int NOT NULL PRIMARY KEY,
  nivel enum('INFO','WARNING','ERROR','CRITICAL') NOT NULL,
  mensagem text NOT NULL,
  contexto longtext,
  idUsuarioRelacionado int,
  timestamp datetime NOT NULL DEFAULT current_timestamp(),
  FOREIGN KEY (idUsuarioRelacionado) REFERENCES usuario (idUsuario) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE projeto (
  idProjeto int NOT NULL PRIMARY KEY,
  nome varchar(255) NOT NULL,
  idCriador int NOT NULL,
  FOREIGN KEY (idCriador) REFERENCES usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE rotina (
  idRotina int NOT NULL PRIMARY KEY,
  nome varchar(255) NOT NULL,
  dataHoraCriacao datetime NOT NULL DEFAULT current_timestamp(),
  dataConclusao date NOT NULL,
  horaConclusao time,
  recorrente tinyint(1) NOT NULL DEFAULT 0,
  recorrenciaRegra varchar(100),
  status enum('PENDENTE','CONCLUIDA','NAO_CONCLUIDA','ARQUIVADA') NOT NULL DEFAULT 'PENDENTE',
  prioridade enum('BAIXA','MEDIA','ALTA','URGENTE'),
  idCriador int NOT NULL,
  idProjeto int,
  ultimaModificacao timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  FOREIGN KEY (idCriador) REFERENCES usuario (idUsuario) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (idProjeto) REFERENCES projeto (idProjeto) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE acao (
  idAcao int NOT NULL PRIMARY KEY,
  nome varchar(255) NOT NULL,
  idRotina int NOT NULL,
  idCriador int NOT NULL,
  dataHoraCriacao datetime NOT NULL DEFAULT current_timestamp(),
  horaConclusao time,
  status enum('PENDENTE','CONCLUIDA') NOT NULL DEFAULT 'PENDENTE',
  definicaoConclusao text,
  ultimaModificacao timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  FOREIGN KEY (idRotina) REFERENCES rotina (idRotina) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idCriador) REFERENCES usuario (idUsuario) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE delegacaorotina (
  idDelegacao int NOT NULL PRIMARY KEY,
  idRotina int NOT NULL,
  idFuncionario int NOT NULL,
  statusProgresso enum('PENDENTE','CONCLUIDA','NAO_CONCLUIDA','ATRASADA') NOT NULL DEFAULT 'PENDENTE',
  progressoPercentual float NOT NULL DEFAULT 0,
  UNIQUE KEY (idRotina, idFuncionario),
  FOREIGN KEY (idFuncionario) REFERENCES usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idRotina) REFERENCES rotina (idRotina) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tag (
  idTag int NOT NULL PRIMARY KEY,
  nome varchar(100) NOT NULL,
  cor varchar(7) NOT NULL,
  idCriador int NOT NULL,
  FOREIGN KEY (idCriador) REFERENCES usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE rotinatag (
  idRotina int NOT NULL,
  idTag int NOT NULL,
  PRIMARY KEY (idRotina, idTag),
  FOREIGN KEY (idRotina) REFERENCES rotina (idRotina) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idTag) REFERENCES tag (idTag) ON DELETE CASCADE ON UPDATE CASCADE
);
