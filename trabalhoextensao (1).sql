-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 11/11/2025 às 21:38
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `trabalhoextensao`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `acao`
--

CREATE TABLE `acao` (
  `idAcao` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `idRotina` int(11) NOT NULL,
  `idCriador` int(11) NOT NULL,
  `dataHoraCriacao` datetime NOT NULL DEFAULT current_timestamp(),
  `horaConclusao` time DEFAULT NULL,
  `status` enum('PENDENTE','CONCLUIDA') NOT NULL DEFAULT 'PENDENTE',
  `definicaoConclusao` text DEFAULT NULL,
  `ultimaModificacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `delegacaorotina`
--

CREATE TABLE `delegacaorotina` (
  `idDelegacao` int(11) NOT NULL,
  `idRotina` int(11) NOT NULL,
  `idFuncionario` int(11) NOT NULL,
  `statusProgresso` enum('PENDENTE','CONCLUIDA','NAO_CONCLUIDA','ATRASADA') NOT NULL DEFAULT 'PENDENTE',
  `progressoPercentual` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `empresa`
--

CREATE TABLE `empresa` (
  `idEmpresa` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `logsistema`
--

CREATE TABLE `logsistema` (
  `idLog` int(11) NOT NULL,
  `nivel` enum('INFO','WARNING','ERROR','CRITICAL') NOT NULL,
  `mensagem` text NOT NULL,
  `contexto` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`contexto`)),
  `idUsuarioRelacionado` int(11) DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `projeto`
--

CREATE TABLE `projeto` (
  `idProjeto` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `idCriador` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `rotina`
--

CREATE TABLE `rotina` (
  `idRotina` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `dataHoraCriacao` datetime NOT NULL DEFAULT current_timestamp(),
  `dataConclusao` date NOT NULL,
  `horaConclusao` time DEFAULT NULL,
  `recorrente` tinyint(1) NOT NULL DEFAULT 0,
  `recorrenciaRegra` varchar(100) DEFAULT NULL,
  `status` enum('PENDENTE','CONCLUIDA','NAO_CONCLUIDA','ARQUIVADA') NOT NULL DEFAULT 'PENDENTE',
  `prioridade` enum('BAIXA','MEDIA','ALTA','URGENTE') DEFAULT NULL,
  `idCriador` int(11) NOT NULL,
  `idProjeto` int(11) DEFAULT NULL,
  `ultimaModificacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `rotinatag`
--

CREATE TABLE `rotinatag` (
  `idRotina` int(11) NOT NULL,
  `idTag` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tag`
--

CREATE TABLE `tag` (
  `idTag` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cor` varchar(7) NOT NULL,
  `idCriador` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `email` varchar(255) NOT NULL,
  `senhaHash` varchar(255) DEFAULT NULL,
  `nivel` enum('MASTER','ADMINISTRADOR','FUNCIONARIO') NOT NULL,
  `status` enum('ATIVO','INATIVO','ARQUIVADO') NOT NULL DEFAULT 'ATIVO',
  `dataHoraInsercao` datetime NOT NULL DEFAULT current_timestamp(),
  `idEmpresa` int(11) DEFAULT NULL,
  `provedorSocial` varchar(50) DEFAULT NULL,
  `idSocial` varchar(255) DEFAULT NULL,
  `segredo2FA` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `acao`
--
ALTER TABLE `acao`
  ADD PRIMARY KEY (`idAcao`),
  ADD KEY `fk_Acao_Rotina_idx` (`idRotina`),
  ADD KEY `fk_Acao_Usuario_idx` (`idCriador`);

--
-- Índices de tabela `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  ADD PRIMARY KEY (`idDelegacao`),
  ADD UNIQUE KEY `idx_rotina_funcionario_unique` (`idRotina`,`idFuncionario`),
  ADD KEY `fk_Delegacao_Rotina_idx` (`idRotina`),
  ADD KEY `fk_Delegacao_Funcionario_idx` (`idFuncionario`);

--
-- Índices de tabela `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idEmpresa`);

--
-- Índices de tabela `logsistema`
--
ALTER TABLE `logsistema`
  ADD PRIMARY KEY (`idLog`),
  ADD KEY `fk_Log_Usuario_idx` (`idUsuarioRelacionado`);

--
-- Índices de tabela `projeto`
--
ALTER TABLE `projeto`
  ADD PRIMARY KEY (`idProjeto`),
  ADD KEY `fk_Projeto_Usuario_idx` (`idCriador`);

--
-- Índices de tabela `rotina`
--
ALTER TABLE `rotina`
  ADD PRIMARY KEY (`idRotina`),
  ADD KEY `fk_Rotina_Usuario_idx` (`idCriador`),
  ADD KEY `fk_Rotina_Projeto_idx` (`idProjeto`);

--
-- Índices de tabela `rotinatag`
--
ALTER TABLE `rotinatag`
  ADD PRIMARY KEY (`idRotina`,`idTag`),
  ADD KEY `fk_RotinaTag_Tag_idx` (`idTag`),
  ADD KEY `fk_RotinaTag_Rotina_idx` (`idRotina`);

--
-- Índices de tabela `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`idTag`),
  ADD KEY `fk_Tag_Usuario_idx` (`idCriador`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  ADD UNIQUE KEY `email_UNIQUE` (`email`),
  ADD KEY `fk_Usuario_Empresa_idx` (`idEmpresa`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acao`
--
ALTER TABLE `acao`
  MODIFY `idAcao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  MODIFY `idDelegacao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idEmpresa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `logsistema`
--
ALTER TABLE `logsistema`
  MODIFY `idLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `projeto`
--
ALTER TABLE `projeto`
  MODIFY `idProjeto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `rotina`
--
ALTER TABLE `rotina`
  MODIFY `idRotina` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tag`
--
ALTER TABLE `tag`
  MODIFY `idTag` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `acao`
--
ALTER TABLE `acao`
  ADD CONSTRAINT `fk_Acao_Rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Acao_Usuario` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Restrições para tabelas `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  ADD CONSTRAINT `fk_Delegacao_Funcionario` FOREIGN KEY (`idFuncionario`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Delegacao_Rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `logsistema`
--
ALTER TABLE `logsistema`
  ADD CONSTRAINT `fk_Log_Usuario` FOREIGN KEY (`idUsuarioRelacionado`) REFERENCES `usuario` (`idUsuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Restrições para tabelas `projeto`
--
ALTER TABLE `projeto`
  ADD CONSTRAINT `fk_Projeto_Usuario` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `rotina`
--
ALTER TABLE `rotina`
  ADD CONSTRAINT `fk_Rotina_Projeto` FOREIGN KEY (`idProjeto`) REFERENCES `projeto` (`idProjeto`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Rotina_Usuario` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Restrições para tabelas `rotinatag`
--
ALTER TABLE `rotinatag`
  ADD CONSTRAINT `fk_RotinaTag_Rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_RotinaTag_Tag` FOREIGN KEY (`idTag`) REFERENCES `tag` (`idTag`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `fk_Tag_Usuario` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_Usuario_Empresa` FOREIGN KEY (`idEmpresa`) REFERENCES `empresa` (`idEmpresa`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
