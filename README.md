# Sistema de Gerenciamento de Rotinas, Ações e Empresas

## 1. Visão Geral do Sistema

Este sistema tem como objetivo **gerenciar rotinas, ações e delegações** dentro de uma ou várias empresas, oferecendo controle completo sobre:

* Cadastro e manutenção de empresas
* Cadastro e gerenciamento de usuários
* Criação, edição, delegação e execução de rotinas
* Controle de ações dentro das rotinas
* Tags, projetos, auditoria via logs
* Segurança com níveis de acesso (MASTER, ADMINISTRADOR, FUNCIONÁRIO)

Toda a base segue os requisitos funcionais e não funcionais fornecidos (RF/RNF).

---

# 2. Modelo Conceitual (ER) — Explicação dos Diagramas

O sistema possui as seguintes entidades principais:

### **Usuário**

Representa qualquer pessoa logada no sistema.
Possui:

* id, nome, CPF, email, senha hash
* nível de acesso: **MASTER**, **ADMIN**, **FUNCIONÁRIO**
* status: ATIVO, INATIVO, BLOQUEADO
* empresa à qual pertence
* segredo de 2FA
  Relacionamentos:
* Pertence a uma empresa
* Pode criar projetos, rotinas, ações, tags
* Pode receber rotinas delegadas

---

### **Empresa**

Estrutura superior hierárquica.
Armazena: id, nome, email, data de criação.
Relacionamento:

* 1 empresa → N usuários

---

### **Projeto**

Usado para agrupar rotinas relacionadas.
Relações:

* 1 projeto contém várias rotinas.

---

### **Rotina**

Elemento central do sistema.
Possui:

* nome, data/hora de criação
* data de conclusão
* prioridade
* status (PENDENTE, EM_EXECUCAO, CONCLUIDA, CANCELADA)
* recorrente (sim/não)
* data limite
  Relacionamentos:
* 1 rotina → N ações
* 1 rotina ↔ N tags (via RotinaTag)
* 1 rotina → N delegações
* 1 rotina pertence a um projeto (opcional)

---

### **Ação**

Uma rotina é composta de ações menores.
Possui:

* status
* descrição
* data da criação e conclusão
  Relacionamento:
* Cada ação pertence a uma rotina

---

### **Tag & RotinaTag**

Sistema de categorização.

* Tag tem id, nome, cor
* RotinaTag é a associação N↔N entre rotinas e tags

---

### **DelegacaoRotina**

Registro de que uma rotina foi atribuída a um funcionário.
Armazena:

* id da rotina
* id do funcionário
* status do progresso
* porcentagem concluída

---

# 3. Diagrama de Classes — Responsabilidades

O diagrama de classes define as responsabilidades de cada entidade no código:

### **Usuário**

Métodos:

* autenticar()
* redefinirSenha()
* alterarStatus()

### **Projeto**

Métodos:

* adicionarRotina()
* removerRotina()

### **Rotina**

Métodos:

* iniciar()
* concluir()
* atualizarStatus()

### **Ação**

Métodos:

* executar()
* atualizar()
* marcarConcluida()

### **DelegacaoRotina**

Métodos:

* atualizarProgresso()

### **Tag**

Métodos:

* aplicarEmRotina()
* removerDeRotina()

### **LogSistema**

Métodos:

* registrar()

Cada método corresponde diretamente às operações necessárias para cumprir os requisitos operacionais do sistema.

---

# 4. Diagramas de Caso de Uso — Explicação

Você enviou vários casos de uso, cada um detalhando as permissões:

---

## **Gerenciamento de Empresas**

Atores:

* MASTER
* Administrador (apenas consulta)

Casos:

* Cadastrar Empresa
* Pesquisar Empresa
* Manter Empresa (extends de pesquisa)

---

## **Gerenciamento de Usuários**

Atores:

* MASTER
* Administrador (somente sua empresa)

Casos:

* Cadastrar Usuário
* Pesquisar Usuário
* Manter Usuário (extends)

---

## **Login**

Atores:

* MASTER
* Administrador
* Funcionário

Casos:

* Login
* Logout
* Trocar Senha

---

## **Execução de Rotinas**

Ator:

* Funcionário

Casos:

* Visualizar Rotinas Recebidas
* Abrir Rotina

  * Extends ⇒ Fechar Rotina
  * Extends ⇒ Concluir Ação

---

# 5. Diagramas de Sequência — Funcionamento Interno

O diagrama de sequência descreve o fluxo completo entre:

1. **Usuário**
2. **Frontend**
3. **Backend**
4. **Banco de Dados**

Fluxo típico para criar rotina:

* Usuário solicita criação
* Backend valida permissões
* BD registra rotina
* Sistema retorna confirmação

Inclui tratamento de:

* Erros
* Validações
* Inserção de logs
* Delegações

---

# 6. Diagramas de Atividade — Fluxos Operacionais

Você enviou diagramas detalhados para:

---

## Login

Mostra:

* entrada de credenciais
* validação
* mensagem de sucesso ou erro
* utilização de 2FA

---

## Gerenciamento de Usuários

Inclui:

* escolha entre cadastrar / pesquisar
* fluxo de edição
* validação de permissões

---

## Gerenciamento de Empresas

Fluxo idêntico ao de usuários, mas limitado ao MASTER.

---

## Gerenciamento de Rotinas

* criar rotina
* adicionar ações
* adicionar tags
* marcar recorrência
* salvar

---

## Execução de Rotinas (para funcionários)

Fluxo:

* ver rotinas recebidas
* abrir rotina
* concluir ações
* fechar rotina

---

# 7. Mapeamento com Requisitos (RF / RNF)

Exemplos:

### **RF007 – Login**

Representado nos diagramas:

* Caso de uso de Login
* Diagrama de atividade de Login
* Diagrama de sequência

### **RF010 – Criar Rotina**

Representado em:

* ER
* Classes
* Casos de uso
* Atividades
* Sequência

### **RNF011 – Auditoria**

Representado por:

* Entidade LogSistema
* Chamadas de métodos registrar()

### **RNF013 – Sincronização Offline**

Relaciona-se com:

* DelegacaoRotina
* Progresso
* Timestamp de última modificação
* Lógica de conflitos

---

# 8. Regras Técnicas e Recomendações

* Usar **hash seguro** para senhas (bcrypt/argon2)
* Aplicar **2FA** com segredo armazenado por usuário
* Registrar logs de forma consistente
* Criar índices para acelerar consultas
* Endpoints REST padronizados
* Camada de sincronização para uso offline

---

# 🗄️ **9. Estrutura da Base de Dados (MySQL)**

A base foi construída seguindo o modelo conceitual e o diagrama de classes apresentados na documentação. Ela contém todas as entidades essenciais para o funcionamento do sistema de rotinas.

---

# **9.1. Tabela `usuario`**

Representa todos os usuários cadastrados no sistema.

**Campos principais:**

* `idUsuario`: chave primária
* `idEmpresa`: FK → empresa
* `nome`, `cpf`, `email`: identificação
* `senhaHash`: senha armazenada de forma segura
* `nivel`: MASTER, ADMIN, FUNCIONARIO
* `status`: ATIVO, INATIVO, BLOQUEADO
* `segredo2FA`: chave para autenticação de 2 fatores

**Relacionamentos:**

* 1 empresa → muitos usuários
* Usuário pode ser criador de rotina, ação, projeto ou tag
* Usuário pode receber delegações

---

# **9.2. Tabela `empresa`**

Cadastro das empresas.

**Campos:**

* `idEmpresa`
* `nome`
* `dataHoraCriacao`

Relacionamento:

* Uma empresa possui vários usuários

---

# **9.3. Tabela `projeto`**

Agrupa rotinas relacionadas.

**Campos:**

* `idProjeto`
* `idCriador` (FK para usuário)
* `nome`

Relacionamento:

* 1 projeto → n rotinas

---

# **9.4. Tabela `rotina`**

Tabela central do sistema.

**Campos importantes:**

* `idRotina`
* `idProjeto` (FK)
* `idCriador` (FK)
* `nome`
* `dataHoraCriacao`
* `dataConclusao`
* `dataLimite`
* `horaConclusao`
* `recorrente`, `recorrenciaRegra`
* `status`: PENDENTE, EM_EXECUCAO, CONCLUIDA, CANCELADA
* `prioridade`: BAIXA, MEDIA, ALTA

Relacionamentos:

* 1 rotina → n ações
* 1 rotina → n delegações
* n rotinas ↔ n tags (via rotinatag)

---

# **9.5. Tabela `acao`**

Representa as etapas de uma rotina.

**Campos:**

* `idAcao`
* `idRotina`
* `idCriador`
* `nome`
* `definicaoConclusao`
* `dataHoraCriacao`
* `horaConclusao`
* `status`
* `ultimaModificacao`

Relacionamento:

* 1 rotina → n ações
* Se rotina for removida, ações são removidas automaticamente (`ON DELETE CASCADE`)

---

# **9.6. Tabela `delegacaorotina`**

Indica que uma rotina foi atribuída a um funcionário.

**Campos:**

* `idDelegacao`
* `idRotina`
* `idFuncionario`
* `statusProgresso`: NAO_INICIADO, EM_ANDAMENTO, CONCLUIDO
* `progressoPercentual`

Regras:

* Só pode haver **uma delegação por funcionário por rotina**
  (unique `idRotina`, `idFuncionario`)

---

# **9.7. Tabela `tag`**

Tags para classificação de rotinas.

**Campos:**

* `idTag`
* `idCriador`
* `nome`
* `cor`

---

# **9.8. Tabela `rotinatag`**

Associação N×N entre rotinas e tags.

**Campos:**

* `idRotina`
* `idTag`

Relacionamento:

* FK cascata em ambas as direções

---

# **9.9. Índices e Integridade Referencial**

O SQL usa:

* Chaves primárias em todas as tabelas
* FK com CASCADE para:

  * rotina → ação
  * rotina → delegação
  * rotina ↔ tag
  * projeto → rotina

Isso garante consistência e segue exatamente o modelo do seu diagrama ER.

---

Agora preciso apenas dos códigos para completar esta seção:

# **10.  Funções PHP e Arquitetura Backend**

### 10.1. `conexao.php`

* função de conexão com o banco
* Tratamento de erro

### 10.2. `login.php`

* Fluxo completo de autenticação
* Verificação de senha
* Validação de sessão
* Redirecionamentos

### 10.3. `logout.php`

* Encerramento de sessão
* Segurança
* Limpeza de cookies

### 10.4. `cadastro_usuario.php`

* Sanitização de entrada
* Criação de usuário
* Hash de senha

### 10.5. `interface.php`

* Como rotinas são carregadas
* Consulta SQL
* Perfis de acesso

---
