-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 27/11/2025 às 21:53
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `trabalhoextensao2`
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
(1, 1, 1, 'Executar script de backup', 'Rodar script no servidor principal', '2025-11-27 17:50:23', '22:30:00', 'PENDENTE', '2025-11-27 20:50:23'),
(2, 1, 1, 'Verificar integridade dos arquivos', 'Checar logs de backup', '2025-11-27 17:50:23', '22:45:00', 'PENDENTE', '2025-11-27 20:50:23'),
(3, 2, 2, 'Gerar relatório financeiro', 'Exportar dados do ERP', '2025-11-27 17:50:23', '17:00:00', 'PENDENTE', '2025-11-27 20:50:23'),
(4, 2, 2, 'Enviar relatório ao gestor', 'Enviar por e-mail ao Master', '2025-11-27 17:50:23', '17:30:00', 'PENDENTE', '2025-11-27 20:50:23'),
(5, 3, 4, 'Atualizar preços', 'Inserir novos valores no sistema', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(6, 3, 4, 'Revisar catálogo', 'Checar consistência dos dados', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(7, 4, 1, 'Revisar logs de acesso', 'Checar registros de login e logout', '2025-11-27 17:50:23', '14:00:00', 'PENDENTE', '2025-11-27 20:50:23'),
(8, 4, 1, 'Emitir relatório de auditoria', 'Gerar documento com achados', '2025-11-27 17:50:23', '15:00:00', 'PENDENTE', '2025-11-27 20:50:23'),
(9, 5, 2, 'Preparar material de treinamento', 'Criar slides e apostilas', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(10, 5, 2, 'Agendar sala de reunião', 'Reservar espaço físico', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(11, 6, 4, 'Criar peças publicitárias', 'Design de banners e posts', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(12, 6, 4, 'Planejar cronograma de posts', 'Definir datas de publicação', '2025-11-27 17:50:23', NULL, 'PENDENTE', '2025-11-27 20:50:23'),
(13, 7, 1, 'Testar firewall', 'Executar testes de vulnerabilidade', '2025-11-27 17:50:23', '09:00:00', 'PENDENTE', '2025-11-27 20:50:23'),
(14, 7, 1, 'Atualizar senhas administrativas', 'Trocar credenciais críticas', '2025-11-27 17:50:23', '09:30:00', 'PENDENTE', '2025-11-27 20:50:23'),
(15, 1, 1, 'Enviar relatório de backup', 'Enviar relatório automático para o administrador', '2025-11-27 17:51:58', '23:00:00', 'PENDENTE', '2025-11-27 20:51:58'),
(18, 4, 1, 'Revisar permissões de usuários', 'Checar se níveis de acesso estão corretos', '2025-11-27 17:51:58', '14:30:00', 'PENDENTE', '2025-11-27 20:51:58'),
(20, 6, 4, 'Definir orçamento da campanha', 'Aprovar valores com diretoria', '2025-11-27 17:51:58', NULL, 'PENDENTE', '2025-11-27 20:51:58'),
(21, 6, 4, 'Monitorar engajamento inicial', 'Checar métricas após primeira semana', '2025-11-27 17:51:58', NULL, 'PENDENTE', '2025-11-27 20:51:58');

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
(1, 1, 3, 'NAO_INICIADO', 0),
(2, 1, 5, 'NAO_INICIADO', 0),
(3, 2, 3, 'EM_ANDAMENTO', 50),
(4, 3, 5, 'NAO_INICIADO', 0),
(5, 4, 3, 'NAO_INICIADO', 0),
(6, 5, 3, 'NAO_INICIADO', 0),
(7, 6, 5, 'NAO_INICIADO', 0);

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
(1, 'Tech Solutions Ltda', '2025-11-27 17:50:23'),
(2, 'InovaCorp SA', '2025-11-27 17:50:23'),
(3, 'AgroMais Brasil', '2025-11-27 17:50:23');

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
(1, 1, 'Sistema de Gestão Interna'),
(2, 2, 'Automação de Processos'),
(3, 4, 'Plataforma de Vendas');

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
(1, 1, 1, 'Backup Diário', '2025-11-27 17:50:23', '2025-11-30', NULL, '23:00:00', 1, 'DIARIO', 'PENDENTE', 'ALTA', '2025-11-27 20:50:23'),
(2, 2, 2, 'Relatório Semanal', '2025-11-27 17:50:23', '2025-12-01', NULL, '18:00:00', 1, 'SEMANAL', 'PENDENTE', 'MEDIA', '2025-11-27 20:50:23'),
(3, 3, 4, 'Atualização de Catálogo', '2025-11-27 17:50:23', '2025-12-05', NULL, NULL, 0, NULL, 'PENDENTE', 'BAIXA', '2025-11-27 20:50:23'),
(4, 1, 1, 'Auditoria Mensal', '2025-11-27 17:50:23', '2025-12-10', NULL, '15:00:00', 1, 'MENSAL', 'PENDENTE', 'ALTA', '2025-11-27 20:50:23'),
(5, 2, 2, 'Treinamento de Equipe', '2025-11-27 17:50:23', '2025-12-15', NULL, NULL, 0, NULL, 'PENDENTE', 'MEDIA', '2025-11-27 20:50:23'),
(6, 3, 4, 'Campanha de Marketing', '2025-11-27 17:50:23', '2025-12-20', NULL, NULL, 0, NULL, 'PENDENTE', 'ALTA', '2025-11-27 20:50:23'),
(7, 1, 1, 'Revisão de Segurança', '2025-11-27 17:50:23', '2025-12-25', NULL, '10:00:00', 0, NULL, 'PENDENTE', 'ALTA', '2025-11-27 20:50:23');

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
(2, 2),
(3, 3),
(4, 1),
(6, 3);

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
(2, 2, 'Financeiro', '#0000FF'),
(3, 4, 'Marketing', '#00FF00');

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
(1, 1, 'Carlos Silva', '123.456.789-00', 'carlos@tech.com', 'hash_senha1', 'MASTER', 'ATIVO', NULL, '2025-11-27 17:50:23'),
(2, 1, 'Ana Pereira', '987.654.321-00', 'ana@tech.com', 'hash_senha2', 'ADMIN', 'ATIVO', NULL, '2025-11-27 17:50:23'),
(3, 1, 'João Souza', '111.222.333-44', 'joao@tech.com', 'hash_senha3', 'FUNCIONARIO', 'ATIVO', NULL, '2025-11-27 17:50:23'),
(4, 2, 'Mariana Costa', '555.666.777-88', 'mariana@inova.com', 'hash_senha4', 'ADMIN', 'ATIVO', NULL, '2025-11-27 17:50:23'),
(5, 2, 'Pedro Lima', '999.888.777-66', 'pedro@inova.com', 'hash_senha5', 'FUNCIONARIO', 'ATIVO', NULL, '2025-11-27 17:50:23'),
(6, 3, 'Lucas Andrade', '222.333.444-55', 'lucas@agromais.com', 'hash_senha6', 'FUNCIONARIO', 'ATIVO', NULL, '2025-11-27 17:50:23');

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
  MODIFY `idAcao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de tabela `delegacaorotina`
--
ALTER TABLE `delegacaorotina`
  MODIFY `idDelegacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
  MODIFY `idRotina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `tag`
--
ALTER TABLE `tag`
  MODIFY `idTag` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
