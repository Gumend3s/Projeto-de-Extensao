-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 23/11/2025 às 20:50
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
-- Banco de dados: `teste`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `acao`
--

CREATE TABLE `acao` (
  `idAcao` int(11) NOT NULL,
  `idRotina` int(11) NOT NULL,
  `idCriador` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `definicaoConclusao` text DEFAULT NULL,
  `dataHoraCriacao` datetime DEFAULT current_timestamp(),
  `horaConclusao` time DEFAULT NULL,
  `status` enum('PENDENTE','EM_EXECUCAO','CONCLUIDA') NOT NULL DEFAULT 'PENDENTE',
  `ultimaModificacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `acao`
--

INSERT INTO `acao` (`idAcao`, `idRotina`, `idCriador`, `nome`, `definicaoConclusao`, `dataHoraCriacao`, `horaConclusao`, `status`, `ultimaModificacao`) VALUES
(1, 1, 1, 'Verificar logs de erro', 'Logs devem estar vazios ou justificados', '2024-01-20 08:05:00', '23:15:00', 'PENDENTE', '2024-11-23 02:15:00'),
(2, 1, 1, 'Upload para S3', 'Arquivo .dump deve estar no bucket', '2024-01-20 08:05:00', '23:30:00', 'PENDENTE', '2024-11-23 02:30:00'),
(3, 2, 1, 'Atualizar Quadro Kanban', 'Mover cards feitos ontem', '2024-02-01 08:35:00', '09:15:00', 'CONCLUIDA', '2024-10-15 12:15:00'),
(4, 3, 2, 'Escrever Draft do E-mail', 'Texto aprovado pelo marketing', '2024-02-10 14:05:00', '09:30:00', 'CONCLUIDA', '2024-11-20 12:30:00'),
(5, 5, 4, 'Lubrificar Eixos X e Y', 'Utilizar óleo sintético tipo A', '2024-11-01 07:05:00', '07:00:00', 'PENDENTE', '2024-11-01 10:05:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `delegacaorotina`
--

CREATE TABLE `delegacaorotina` (
  `idDelegacao` int(11) NOT NULL,
  `idRotina` int(11) NOT NULL,
  `idFuncionario` int(11) NOT NULL,
  `statusProgresso` enum('NAO_INICIADO','EM_ANDAMENTO','CONCLUIDO') NOT NULL DEFAULT 'NAO_INICIADO',
  `progressoPercentual` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `delegacaorotina`
--

INSERT INTO `delegacaorotina` (`idDelegacao`, `idRotina`, `idFuncionario`, `statusProgresso`, `progressoPercentual`) VALUES
(1, 1, 2, 'EM_ANDAMENTO', 50),
(2, 2, 3, 'NAO_INICIADO', 0),
(3, 3, 2, 'CONCLUIDO', 100),
(4, 4, 3, 'EM_ANDAMENTO', 75.5),
(5, 5, 4, 'NAO_INICIADO', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `empresa`
--

CREATE TABLE `empresa` (
  `idEmpresa` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `dataHoraCriacao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `empresa`
--

INSERT INTO `empresa` (`idEmpresa`, `nome`, `dataHoraCriacao`) VALUES
(1, 'Tech Solutions Ltda', '2024-01-10 08:00:00'),
(2, 'Consultoria Silva & Associados', '2024-01-12 09:30:00'),
(3, 'Indústria Metalúrgica Beta', '2024-02-01 14:00:00'),
(4, 'StartUp Inova Rápido', '2024-03-15 10:00:00'),
(5, 'Comércio Varejista Global', '2024-01-20 11:15:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `projeto`
--

CREATE TABLE `projeto` (
  `idProjeto` int(11) NOT NULL,
  `idCriador` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `projeto`
--

INSERT INTO `projeto` (`idProjeto`, `idCriador`, `nome`) VALUES
(1, 1, 'Migração de Servidores Cloud'),
(2, 1, 'Desenvolvimento App Mobile'),
(3, 2, 'Campanha de Marketing Q3'),
(4, 3, 'Auditoria Financeira 2024'),
(5, 4, 'Automação da Linha de Montagem'),
(6, 2, 'asd');

-- --------------------------------------------------------

--
-- Estrutura para tabela `rotina`
--

CREATE TABLE `rotina` (
  `idRotina` int(11) NOT NULL,
  `idProjeto` int(11) NOT NULL,
  `idCriador` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `dataHoraCriacao` datetime DEFAULT current_timestamp(),
  `dataConclusao` date DEFAULT NULL,
  `dataLimite` timestamp NULL DEFAULT NULL,
  `horaConclusao` time DEFAULT NULL,
  `recorrente` tinyint(1) DEFAULT 0,
  `recorrenciaRegra` varchar(255) DEFAULT NULL,
  `status` enum('PENDENTE','EM_EXECUCAO','CONCLUIDA','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  `prioridade` enum('BAIXA','MEDIA','ALTA') NOT NULL DEFAULT 'MEDIA',
  `ultimaModificacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `rotina`
--

INSERT INTO `rotina` (`idRotina`, `idProjeto`, `idCriador`, `nome`, `dataHoraCriacao`, `dataConclusao`, `dataLimite`, `horaConclusao`, `recorrente`, `recorrenciaRegra`, `status`, `prioridade`, `ultimaModificacao`) VALUES
(1, 1, 1, 'Backup Diário do Banco', '2024-01-20 08:00:00', '2024-12-31', '2025-01-01 02:59:59', '23:00:00', 1, 'Diariamente', 'PENDENTE', 'ALTA', '2025-11-23 18:04:40'),
(2, 2, 1, 'Reunião de Daily Scrum', '2024-02-01 08:30:00', '2024-10-15', '2024-10-15 12:30:00', '09:00:00', 1, 'Segunda a Sexta', 'EM_EXECUCAO', 'MEDIA', '2025-11-23 18:04:40'),
(3, 3, 2, 'Envio de Newsletter Semanal', '2024-02-10 14:00:00', '2024-11-20', '2024-11-20 20:00:00', '10:00:00', 1, 'Sexta', 'CONCLUIDA', 'BAIXA', '2025-11-23 18:04:40'),
(4, 4, 3, 'Conferência de Notas Fiscais', '2024-10-01 09:00:00', '2024-10-30', '2024-10-31 21:00:00', '18:00:00', 0, NULL, 'PENDENTE', 'ALTA', '2024-10-31 13:00:00'),
(5, 5, 4, 'Manutenção Preventiva Robôs', '2024-11-01 07:00:00', '2024-12-01', '2024-12-05 15:00:00', '06:00:00', 1, 'Mensalmente', 'CANCELADA', 'MEDIA', '2025-11-23 18:04:40');

-- --------------------------------------------------------

--
-- Estrutura para tabela `rotinatag`
--

CREATE TABLE `rotinatag` (
  `idRotina` int(11) NOT NULL,
  `idTag` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `rotinatag`
--

INSERT INTO `rotinatag` (`idRotina`, `idTag`) VALUES
(1, 1),
(1, 2),
(2, 1),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tag`
--

CREATE TABLE `tag` (
  `idTag` int(11) NOT NULL,
  `idCriador` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `cor` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tag`
--

INSERT INTO `tag` (`idTag`, `idCriador`, `nome`, `cor`) VALUES
(1, 1, 'Urgente', '#FF0000'),
(2, 1, 'Backend', '#0000FF'),
(3, 2, 'Frontend', '#00FF00'),
(4, 3, 'Financeiro', '#FFFF00'),
(5, 4, 'Manutenção', '#808080');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `idEmpresa` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `email` varchar(255) NOT NULL,
  `senhaHash` varchar(255) NOT NULL,
  `nivel` enum('MASTER','ADMIN','FUNCIONARIO') NOT NULL,
  `status` enum('ATIVO','INATIVO','BLOQUEADO') NOT NULL DEFAULT 'ATIVO',
  `segredo2FA` varchar(255) DEFAULT NULL,
  `dataHoraInsercao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `idEmpresa`, `nome`, `cpf`, `email`, `senhaHash`, `nivel`, `status`, `segredo2FA`, `dataHoraInsercao`) VALUES
(1, 1, 'Ana Pereira', '11122233344', 'ana.pereira@tech.com', '123', 'FUNCIONARIO', 'ATIVO', NULL, '2024-01-11 09:00:00'),
(2, 1, 'Carlos Souza', '22233344455', 'carlos.souza@tech.com', '123', 'ADMIN', 'ATIVO', NULL, '2024-01-15 10:30:00'),
(3, 2, 'Beatriz Lima', '33344455566', 'bia.lima@consultoria.com', '123', 'FUNCIONARIO', 'ATIVO', NULL, '2024-01-13 08:45:00'),
(4, 3, 'Daniel Oliveira', '44455566677', 'daniel.o@metalbeta.com', '123', 'ADMIN', 'BLOQUEADO', NULL, '2024-02-02 13:20:00'),
(5, 4, 'Eduardo Santos', '55566677788', 'edu.santos@inova.com', '123', 'FUNCIONARIO', 'INATIVO', NULL, '2024-03-16 11:00:00');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `acao`
--
ALTER TABLE `acao`
  ADD PRIMARY KEY (`idAcao`),
  ADD KEY `fk_acao_rotina` (`idRotina`),
  ADD KEY `fk_acao_criador` (`idCriador`);

--
-- Índices de tabela `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  ADD PRIMARY KEY (`idDelegacao`),
  ADD UNIQUE KEY `uk_rotina_funcionario` (`idRotina`,`idFuncionario`),
  ADD KEY `fk_delegacao_funcionario` (`idFuncionario`);

--
-- Índices de tabela `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idEmpresa`);

--
-- Índices de tabela `projeto`
--
ALTER TABLE `projeto`
  ADD PRIMARY KEY (`idProjeto`),
  ADD KEY `fk_projeto_criador` (`idCriador`);

--
-- Índices de tabela `rotina`
--
ALTER TABLE `rotina`
  ADD PRIMARY KEY (`idRotina`),
  ADD KEY `fk_rotina_projeto` (`idProjeto`),
  ADD KEY `fk_rotina_criador` (`idCriador`);

--
-- Índices de tabela `rotinatag`
--
ALTER TABLE `rotinatag`
  ADD PRIMARY KEY (`idRotina`,`idTag`),
  ADD KEY `fk_rt_tag` (`idTag`);

--
-- Índices de tabela `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`idTag`),
  ADD KEY `fk_tag_criador` (`idCriador`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cpf` (`cpf`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_usuario_empresa` (`idEmpresa`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `acao`
--
ALTER TABLE `acao`
  MODIFY `idAcao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  MODIFY `idDelegacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idEmpresa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `projeto`
--
ALTER TABLE `projeto`
  MODIFY `idProjeto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `rotina`
--
ALTER TABLE `rotina`
  MODIFY `idRotina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `tag`
--
ALTER TABLE `tag`
  MODIFY `idTag` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `acao`
--
ALTER TABLE `acao`
  ADD CONSTRAINT `fk_acao_criador` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `fk_acao_rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE;

--
-- Restrições para tabelas `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  ADD CONSTRAINT `fk_delegacao_funcionario` FOREIGN KEY (`idFuncionario`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `fk_delegacao_rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE;

--
-- Restrições para tabelas `projeto`
--
ALTER TABLE `projeto`
  ADD CONSTRAINT `fk_projeto_criador` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `rotina`
--
ALTER TABLE `rotina`
  ADD CONSTRAINT `fk_rotina_criador` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`),
  ADD CONSTRAINT `fk_rotina_projeto` FOREIGN KEY (`idProjeto`) REFERENCES `projeto` (`idProjeto`) ON DELETE CASCADE;

--
-- Restrições para tabelas `rotinatag`
--
ALTER TABLE `rotinatag`
  ADD CONSTRAINT `fk_rt_rotina` FOREIGN KEY (`idRotina`) REFERENCES `rotina` (`idRotina`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rt_tag` FOREIGN KEY (`idTag`) REFERENCES `tag` (`idTag`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `fk_tag_criador` FOREIGN KEY (`idCriador`) REFERENCES `usuario` (`idUsuario`) ON DELETE SET NULL;

--
-- Restrições para tabelas `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_empresa` FOREIGN KEY (`idEmpresa`) REFERENCES `empresa` (`idEmpresa`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
