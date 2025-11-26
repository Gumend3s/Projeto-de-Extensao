## **Introdução**

O projeto é um **Gerenciador de Rotinas Empresariais**, desenvolvido com o objetivo de facilitar a organização, acompanhamento e execução das atividades internas de uma empresa.
A plataforma permite que **gerentes e supervisores** criem, atribuam e monitorem rotinas de trabalho para seus colaboradores, garantindo maior controle operacional e melhor distribuição das demandas diárias.

Com ele, é possível:
* Criar rotinas e tarefas de forma estruturada.
* Atribuir atividades a funcionários específicos.
* Definir **tempo estimado** para execução.
* Estabelecer **datas limites** de entrega.
* Acompanhar o progresso das rotinas em tempo real.

O sistema foi projetado para melhorar a comunicação interna, aumentar a produtividade e reduzir falhas operacionais, centralizando todas as rotinas em um único ambiente de gestão.

---

## **Modelos e Diagramas do Sistema**

Para representar a estrutura e o comportamento do Gerenciador de Rotinas Empresariais, foram elaborados diversos **diagramas UML** que oferecem uma visão clara e organizada dos componentes do sistema e de suas interações.

Esses diagramas auxiliam na compreensão técnica do projeto, permitindo visualizar desde a lógica interna das classes até o fluxo de execução das rotinas.
A seguir, estão descritos os principais modelos utilizados:

* **Diagrama de Classes:**
  Representa a estrutura estática do sistema, detalhando entidades, atributos, métodos e os relacionamentos entre elas.

* **Diagrama de Sequência:**
  Demonstra a comunicação entre objetos ao longo do tempo, ilustrando a ordem das operações em um determinado fluxo de uso.

* **Diagrama de Atividade:**
  Descreve o fluxo de processos e decisões dentro do sistema, permitindo entender como as rotinas e tarefas são executadas do início ao fim.

* **Diagrama de Caso de Uso:**
  Apresenta as interações entre os usuários (atores) e o sistema, destacando as funcionalidades principais e como cada perfil utiliza a aplicação.

Esses modelos contribuem para uma documentação completa e facilitam futuras manutenções, expansões e integrações do sistema.

---

# Diagrama de Classes

Abaixo está o **Diagrama de Classes** e a descrição técnica das classes, atributos, métodos e relacionamentos extraídos do diagrama.

![Diagrama de Classes](/img/DiagramaClasse.png)

---

## Resumo das classes, atributos e métodos

### `Usuario`

* **Atributos**

  * `int idUsuario`
  * `string nome`
  * `string cpf`
  * `string email`
  * `string senhaHash`
  * `string nivel` // `MASTER`, `ADMIN`, `FUNCIONARIO`
  * `string status` // `ATIVO`, `INATIVO`, `BLOQUEADO`
  * `datetime dataHoraInsercao`
  * `int idEmpresa`
  * `string segredo2FA`
* **Métodos**

  * `autenticar(email, senha)`
  * `redefinirSenha(novaSenha)`
  * `alterarStatus(novoStatus)`

---

### `Empresa`

* **Atributos**

  * `int idEmpresa`
  * `string nome`
* **Métodos**

  * `cadastrarUsuario(usuario)`
  * `listarUsuarios()`

**Relação:** `Empresa` contém 0..* `Usuario` (uma empresa possui vários usuários).

---

### `Projeto`

* **Atributos**

  * `int idProjeto`
  * `string nome`
  * `int idCriador`
* **Métodos**

  * `adicionarRotina(rotina)`
  * `removerRotina(idRotina)`

**Relação:** `Usuario` (criador) → cria 0..*`Projeto`. `Projeto` contém 0..* `Rotina`.

---

### `Rotina`

* **Atributos**

  * `int idRotina`
  * `string nome`
  * `datetime dataHoraCriacao`
  * `date dataConclusao`
  * `time horaConclusao`
  * `boolean recorrente`
  * `string recorrenciaRegra`
  * `string status` // `PENDENTE`, `EM_EXECUCAO`, `CONCLUIDA`, `CANCELADA`
  * `string prioridade` // `BAIXA`, `MEDIA`, `ALTA`
  * `int idCriador`
  * `int idProjeto`
  * `timestamp ultimaModificacao`
  * `timestamp dataLimite`
* **Métodos**

  * `iniciar()`
  * `concluir()`
  * `atualizarStatus(novoStatus)`

**Relações importantes:**

* `Rotina` é **composta por** 0..* `Acao`.
* `Rotina` —< `RotinaTag` >— `Tag` (associação N:N via `RotinaTag`).
* `Rotina` pode ser **atribuída** a usuários via `DelegacaoRotina` (delegação).

---

### `Acao`

* **Atributos**

  * `int idAcao`
  * `string nome`
  * `int idRotina`
  * `int idCriador`
  * `datetime dataHoraCriacao`
  * `time horaConclusao`
  * `string status` // `PENDENTE`, `EM_EXECUCAO`, `CONCLUIDA`
  * `text definicaoConclusao`
  * `timestamp ultimaModificacao`
* **Métodos**

  * `executar()`
  * `atualizar()`
  * `marcarConcluida()`

---

### `Tag`

* **Atributos**

  * `int idTag`
  * `string nome`
  * `string cor`
  * `int idCriador`
* **Métodos**

  * `aplicarEmRotina(rotina)`
  * `removerDeRotina(rotina)`

**Relação:** usada em 0..* `Rotina` via `RotinaTag`.

---

### `RotinaTag` (entidade associativa)

* **Atributos**

  * `int idRotina`
  * `int idTag`
* **Observação:** tabela de ligação N:N entre `Rotina` e `Tag`.

---

### `DelegacaoRotina`

* **Atributos**

  * `int idDelegacao`
  * `int idRotina`
  * `int idFuncionario` (usuário ao qual a rotina foi atribuída)
  * `string statusProgresso` // `NAO_INICIADO`, `EM_ANDAMENTO`, `CONCLUIDO`
  * `float progressoPercentual`
* **Métodos**

  * `atualizarProgresso(percentual)`

**Relação:** relaciona `Rotina` ↔ `Usuario` (funcionário) — permite delegar rotinas e acompanhar progresso por usuário.

---

### `LogSistema`

* **Atributos**

  * `int idLog`
  * `string nivel` // `INFO`, `ALERTA`, `ERRO`
  * `text mensagem`
  * `longtext contexto`
  * `int idUsuarioRelacionado`
  * `datetime timestamp`
* **Métodos**

  * `registrar(mensagem, nivel)`

**Relação:** `LogSistema` é gerado por ações de `Usuario` e outros eventos do sistema.

---

## Observações sobre relacionamentos e multiplicidades (resumo)

* `Empresa (1)` contém `Usuario (0..*)`.
* `Usuario (1)` cria `Projeto (0..*)`.
* `Projeto (1)` contém `Rotina (0..*)`.
* `Rotina (1)` é composta por `Acao (0..*)`.
* `Rotina (0..*)` ↔ `Tag (0..*)` via `RotinaTag` (N:N).
* `Rotina (0..*)` ↔ `Usuario (funcionário)` via `DelegacaoRotina` (N:N com atributos de progresso).
* `LogSistema` se relaciona com `Usuario` (opcionalmente referente ao usuário que originou o log).

---

## **Diagrama de Atividade — Processo de Login**

### **Visão Geral**

O diagrama de atividade abaixo representa o fluxo básico do processo de autenticação de um usuário no sistema. Ele descreve, passo a passo, como ocorre a interação desde o momento em que o usuário acessa a tela inicial de login até o resultado final da validação das credenciais.

Esse fluxo garante que apenas usuários com **dados corretos e válidos** possam acessar o sistema, enquanto credenciais incorretas resultam na interrupção imediata do processo.

### **Imagem do Diagrama**

![Diagrama de Atividade — Login](/img/DiagramaAtividade-1.png)

---

## **Descrição detalhada do fluxo**

### **I. Início do Processo**

Tudo começa com o ponto inicial do fluxo, representado pelo nó negro (●).
Este nó indica o início da atividade de autenticação.

---

### **II. Acesso à Tela de Login**

O usuário é direcionado para a **Tela de Login**, onde poderá inserir suas credenciais.
Essa etapa representa a chegada do usuário na interface destinada à autenticação.

---

### **III. Inserção de Usuário e Senha**

Nesta atividade, o usuário informa:

* **Nome de usuário / e-mail**
* **Senha correspondente**

Essa etapa é essencial para que o sistema tenha dados suficientes para validar a identidade do usuário.

---

### **IV. Validação das Credenciais**

Após a entrada dos dados, o fluxo chega ao **ponto de decisão**.
Aqui o sistema verifica duas informações fundamentais:

* O e-mail/usuário existe no sistema?
* A senha fornecida corresponde à senha armazenada?

Com base nessa verificação, dois caminhos possíveis são definidos.

---

### **V. Caminho positivo — Dados válidos**

Caso as informações estejam corretas, o fluxo segue para **“Usuário liberado”**, significando que:

* As credenciais são válidas;
* O usuário está autorizado a acessar o sistema;
* O fluxo segue para o estado final de conclusão.

Isso representa o acesso concedido.

---

### **VI. Caminho negativo — Dados inválidos**

Se a validação falhar, o fluxo segue para **“Usuário barrado”**, representando que:

* O usuário digitou dados incorretos;
* O sistema impede o acesso;
* O fluxo é encerrado com o símbolo de cancelamento (✖).

Essa ação protege a segurança do sistema contra acessos indevidos.

---

### **VII. Finalização do Processo**

Cada caminho termina em um nó de fim apropriado:

* **Concluído** quando o login é bem-sucedido.
* **Cancelado** quando as credenciais estão incorretas.

Essa separação deixa claro o resultado final do processo.

---

## **Diagrama de Atividade — Criação / Edição de Usuário**

### **Imagem do Diagrama**

![Diagrama de Atividade — Criação/Edição de Usuário](/img/DiagramaAtividade-2.png)

---

### **Visão Geral**

Este diagrama descreve o fluxo de criação e edição de usuários no sistema. Ele contempla dois caminhos principais que partem de uma mesma interface inicial: **Criar novo usuário** e **Pesquisar/editar usuário existente**. Ambos os caminhos convergem para a etapa de salvar as alterações no sistema e envio de confirmação.

O objetivo do fluxo é garantir que gestores ou administradores possam cadastrar novos colaboradores e também localizar e atualizar usuários já existentes, mantendo consistência dos dados e gerando confirmação (e.g., e-mail, notificação interna) após a operação.

---

### **Fluxo detalhado (passo a passo)**

### **I. Início**

   * Ponto inicial: a ação é iniciada por um usuário com permissão (por exemplo: administrador ou gerente).
   * Pré-condição: usuário autenticado e com permissão adequada para criar/editar usuários.

### **II. Decisão inicial — Criar ou Pesquisar?**

   * Interface apresenta a opção de **Criar** novo usuário ou **Pesquisar** um usuário já cadastrado.
   * Com base na escolha, o fluxo segue por duas trilhas distintas: criação (esquerda) ou pesquisa/edição (direita).

### **III. Trilha: Criar Usuário**

   * **Ir para a criação de usuário**: o sistema redireciona para o formulário de cadastro.
   * **Preencher dados do usuário**: campos típicos:

     * Nome completo
     * CPF (ou outro identificador)
     * E-mail
     * Empresa / Filial
     * Nível/permissão (MASTER, ADMIN, FUNCIONARIO)
     * Status inicial (ATIVO/INATIVO)
     * Dados opcionais (telefone, setor, cargo)
   * Validações imediatas no front-end (formato de e-mail, máscara de CPF) e checagens no backend (CPF/e-mail já cadastrados).
   * Ao terminar, o fluxo converge para **Salvar no sistema**.

### **IV. Trilha: Pesquisar → Editar Usuário**

   * **Ir para a pesquisa de usuário**: o sistema mostra a tela de busca/filtragem.
   * **Inserir parâmetros de pesquisa**: possíveis parâmetros: nome, CPF, e-mail, empresa, nível.
   * **Selecionar um usuário**: a lista de resultados permite escolher o registro a editar.
   * **Ir para a edição do usuário selecionado**: abrir o formulário preenchido com os dados atuais.
   * **Preencher/alterar dados do usuário**: o administrador faz as alterações necessárias (mesmos campos da criação).
   * Após a edição, o fluxo converge para **Salvar no sistema**.

### **V. Salvar no Sistema**

   * Operação transacional: todas as alterações devem ser salvas de forma atômica (rollback em caso de erro).
   * Regras aplicadas no momento do save:

     * Validação de unicidade (CPF, e-mail).
     * Validação de permissões (não permitir elevação indevida de privilégios sem autorização).
     * Auditoria: registrar quem realizou a alteração e timestamp.
   * Em caso de conflito (e.g., edição concorrente), exibir aviso ao usuário e apresentar opção de forçar salvar ou cancelar.

### **VI. Enviar Mensagem de Confirmação**

   * Ao salvar com sucesso:

     * Enviar notificação por e-mail para o novo usuário (se criado) ou para o administrador (se edição) contendo resumo das informações e instruções (ex.: redefinição de senha, link para login).
     * Registrar log/auditoria no `LogSistema`.
   * Em caso de falha no envio de notificação, a criação/edição continua válida — notificação pode ser reprocessada em background, mas o usuário deve ser alertado.

### **VII. Fim**

   * Ponto final do fluxo: confirmação visível na interface (toast/modal) e redirecionamento opcional (ex.: lista de usuários, perfil do usuário).

---

### **Regras de Negócio e Considerações Técnicas**

* **Permissões**: somente perfis com autorização (ex.: MASTER, ADMIN) devem enxergar as ações de criação/edição. Usuários comuns não devem ter acesso.
* **Validações obrigatórias**:

  * CPF e e-mail com formato válido.
  * CPF/e-mail não podem estar duplicados (salvar falha com erro informativo).
  * Campos obrigatórios: `nome`, `cpf`, `email`, `nível`.
* **Segurança**:

  * Nunca retornar ou exibir `senhaHash`. Ao criar usuário, enviar link de criação de senha via e-mail.
  * Registros sensíveis auditados (quem criou/alterou e quando).
* **UX**:

  * Formulário com feedback em tempo real (erro de validação inline).
  * Busca com paginação e filtros capazes de lidar com grandes volumes.
  * Mensagens claras em caso de conflito (edição concorrente) ou erro de validação.
* **Resiliência**:

  * Salvar em transação para garantir integridade.
  * Retry para envio de e-mail; fallback para enfileirar notificação em um job (fila).
* **Auditoria e Logs**:

  * Registrar no `LogSistema` ações de criação, edição e falhas críticas (e.g., duplicidade detectada).
* **Casos de exceção notáveis**:

  * Tentativa de criar usuário com CPF já cadastrado → bloqueio e sugestão de editar registro existente.
  * Edição simultânea por dois administradores → detectar versão (optimistic locking) e avisar.
  * Mudança de nível para MASTER → exigir confirmação adicional (ou autenticação multifator do solicitante).

---

### **Pré-condições**

* Usuário autenticado com permissão adequada.
* Serviços de validação (ex.: banco de dados, serviço de e-mail) disponíveis.

### **Pós-condições**

* Usuário criado/atualizado no banco.
* Registro de auditoria persistido.
* Notificação de confirmação disparada (ou enfileirada).

---

## **Diagrama de Atividade — Criação / Edição de Empresa**

### **Imagem do Diagrama**

![Diagrama de Atividade — Criação/Edição de Empresa](/img/DiagramaAtividade-3.png)

---

## **Descrição Detalhada do Fluxo**

### **I. Início**

O processo se inicia com o usuário acessando o módulo de gestão de empresas, representado pelo ponto inicial do diagrama.
Somente perfis autorizados (como MASTER ou ADMIN) podem iniciar esse fluxo.

---

### **II. Decisão Inicial — Criar ou Pesquisar Empresa**

O sistema apresenta ao usuário duas opções:

* Criar uma nova empresa
* Pesquisar uma empresa já cadastrada

Essa escolha define o caminho inicial do fluxo, mas ambos convergem posteriormente para o salvamento final.

---

### **III. Criar Empresa — Ir para a criação de empresa**

Caso o usuário selecione a opção **Criar**, o sistema redireciona imediatamente para a tela de cadastro de empresa.
Essa tela contém todos os campos necessários para registrar um novo registro empresarial.

---

### **IV. Preencher dados da empresa (Nome, CNPJ, e-mail, etc.)**

O usuário preenche os dados essenciais da empresa, que geralmente incluem:

* Nome da empresa
* CNPJ (ou identificador equivalente)
* E-mail corporativo
* Telefone
* Endereço
* Campos adicionais internos (ex.: área responsável, setor, observações)

Validações típicas ocorrem tanto no front-end quanto no backend, como:

* Formato correto de CNPJ
* CNPJ duplicado
* E-mail válido

Após isso, o fluxo avança para o salvamento.

---

### **V. Pesquisar Empresa — Ir para a pesquisa de empresa**

Caso o usuário selecione **Pesquisar**, o sistema abre a interface de busca.
Essa tela permite localizar empresas existentes por filtros como nome, CNPJ ou e-mail.

---

### **VI. Inserir parâmetros da pesquisa**

O usuário informa os critérios desejados — por exemplo:

* Nome completo ou parcial
* CNPJ
* E-mail
* Tipo de empresa, filial, unidade (caso aplicável)

O sistema executa a busca e retorna a lista de empresas compatíveis.

---

### **VII. Selecionar uma empresa para editar**

Após o sistema exibir os resultados, o usuário escolhe qual empresa deseja editar.
Essa seleção encaminha o fluxo para a tela de edição.

---

### **VIII. Ir para a edição da empresa selecionada**

O sistema abre o formulário já preenchido com os dados atuais da empresa selecionada.
Aqui o usuário pode atualizar qualquer campo, exceto identificadores imutáveis (como ID interno).

---

### **IX. Preencher dados da empresa (Nome, CNPJ, e-mail, etc.)**

Nesta etapa, o usuário altera os dados necessários.
São aplicadas as mesmas validações da etapa de criação, incluindo:

* Unicidade de CNPJ
* E-mail válido
* Preenchimento obrigatório dos campos essenciais

Concluído o preenchimento, o fluxo converge com o processo de criação para o passo seguinte.

---

### **X. Salvar no sistema**

O sistema executa uma operação transacional para registrar:

* Nova empresa (no caso de criação)
* Alterações (no caso de edição)

Durante o salvamento, ocorre:

* Verificação de duplicidades (CNPJ/e-mail)
* Registro de histórico ou auditoria
* Validações adicionais definidas pelo negócio

Se qualquer erro ocorrer, a operação é cancelada e o usuário é notificado.

---

### **XI. Enviar mensagem de confirmação**

Após o sucesso do salvamento, o sistema envia uma confirmação, que pode ser:

* Notificação interna
* E-mail de confirmação
* Mensagem de sucesso na interface
* Registro no LogSistema para auditoria

Isso conclui o processo com segurança e rastreabilidade.

---

### **XII. Fim**

O fluxo termina após a confirmação, finalizando com sucesso tanto a criação quanto a edição de empresas.

---

## **Diagrama de Atividade — Criação / Edição de Rotina**

### **Imagem do Diagrama**

![Diagrama de Atividade — Criação/Edição de Rotina](/img/DiagramaAtividade-4.png)

---

## **Descrição Detalhada do Fluxo**

### **I. Início**

O fluxo se inicia quando o usuário acessa o módulo de gerenciamento de rotinas.
Somente usuários autorizados (gerentes, administradores ou responsáveis por fluxos internos) podem criar ou editar rotinas.

---

### **II. Decisão Inicial — Criar ou Pesquisar Rotina**

O sistema apresenta duas opções:

* Criar uma nova rotina
* Pesquisar uma rotina já existente para editar

Cada opção segue caminhos distintos, mas ambos convergem no final para o salvamento dos dados.

---

## **Fluxo da Esquerda — Criação de Rotina**

### **III. Ir para a criação de rotina**

Se o usuário optar por **Criar**, o sistema redireciona para uma tela de cadastro de rotina.

---

### **IV. Preencher dados da rotina (Título, Data, etc.)**

O usuário preenche informações essenciais da rotina, como:

* Título da rotina
* Data de criação
* Data final desejada
* Descrição
* Prioridade (Baixa, Média, Alta)
* Atribuição ao projeto ou setor
* Responsável pela rotina

Essa etapa é fundamental para estabelecer o escopo e o propósito da rotina.

---

### **V. Hora de conclusão definida? (Decisão)**

O sistema verifica se o usuário deseja registrar uma hora de conclusão prevista.

* Se **sim**, o fluxo avança para definir a hora.
* Se **não**, a decisão é ignorada e o fluxo segue adiante.

---

### **VI. Definir Hora da conclusão**

O usuário informa uma hora específica de entrega da rotina.
Essa informação ajuda no controle da produtividade e cumprimento dos prazos.

---

### **VII. A rotina é recorrente? (Decisão)**

A rotina pode ser única ou repetitiva.

* Se **sim**, o usuário deve definir a recorrência.
* Se **não**, o fluxo segue para a etapa de ações.

---

### **VIII. Definir intervalo da recorrência**

O usuário determina:

* Periodicidade (diária, semanal, mensal, personalizada)
* Data limite da recorrência
* Regras adicionais

Isso permite criar rotinas repetitivas de forma automatizada.

---

### **IX. Adicionar Ações**

Aqui, o usuário cria as ações que compõem a rotina.
Cada rotina pode possuir diversas ações, cada uma com:

* Nome
* Descrição
* Ordem
* Tempo estimado
* Responsável (opcional)

As ações formam o fluxo interno da rotina.

---

### **X. Adicionar Tags**

O usuário pode aplicar tags para classificar e organizar rotinas.
As tags ajudam na filtragem e categorização, como por exemplo:

* “Urgente”, “Financeiro”, “RH”, “Recorrente”, etc.

---

## **Fluxo da Direita — Pesquisa e Edição de Rotina**

### **XI. Ir para a pesquisa de rotina**

Se a opção escolhida for **Pesquisar**, o sistema abre a interface de busca.

---

### **XII. Inserir os parâmetros da pesquisa**

Possíveis parâmetros:

* Título
* Data
* Status da rotina
* Responsável
* Tags associadas
* Projetos vinculados

O sistema retorna os resultados correspondentes.

---

### **XIII. Selecionar uma rotina para editar**

Após visualizar a lista resultante, o usuário escolhe qual rotina deve ser modificada.

---

### **XIV. Ir para a edição da rotina selecionada**

O sistema abre o formulário já preenchido com todos os dados atuais da rotina.

---

### **XV. Preencher dados da rotina (Título, Data, etc.)**

O usuário altera os campos desejados, aplicando correções ou melhorias.

---

### **XVI. Hora de conclusão definida? (Decisão)**

Mesma lógica do fluxo de criação:

* Se definida, a hora deve ser especificada.
* Se não, o sistema ignora esse passo.

---

### **XVII. Definir Hora da conclusão**

O usuário ajusta ou define a hora de conclusão da rotina.

---

### **XVIII. A rotina é recorrente? (Decisão)**

O usuário pode tornar a rotina recorrente ou alterar sua recorrência.

---

### **XIX. Definir intervalo da recorrência**

Mesma lógica da criação:

* Escolher periodicidade
* Intervalos
* Data limite
* Regras personalizadas

---

### **XX. Editar Ações**

O usuário pode:

* Adicionar uma nova ação
* Editar ações existentes
* Remover ações que não serão mais utilizadas
* Reordenar a sequência das ações

---

### **XXI. Adicionar/Remover Tags**

O usuário atualiza as tags da rotina, podendo:

* Registrar novas tags
* Remover tags obsoletas
* Aplicar tags que facilitem o agrupamento

---

## **Conclusão do Fluxo (Comum aos Dois Caminhos)**

### **XXII. Salvar no sistema**

O sistema valida todos os dados e executa o salvamento transacional.
Validações incluem:

* Campos obrigatórios
* Ações vinculadas
* Tags associadas
* Regras de recorrência coerentes
* Relacionamentos com projetos/usuários

Em caso de erro, a operação é cancelada e o usuário é notificado.

---

### **XXIII. Enviar mensagem de confirmação**

Após salvar com sucesso, o sistema envia uma confirmação como:

* Notificação visual
* E-mail informando a criação ou atualização da rotina
* Registro em LogSistema para auditoria
* Atualização de dashboards internos

---

### **XXIV. Fim**

O fluxo se encerra após a confirmação, finalizando a operação com sucesso.

---
## **Diagrama de Atividade — Conclusão de Rotina (Execução pelo Funcionário)**

### **Imagem do Diagrama**

![Diagrama de Atividade — Concluir Rotina](/img/DiagramaAtividade-5.png)

---

## **Descrição detalhada do fluxo**

### **I. Início**

O fluxo começa quando o usuário (normalmente um funcionário ou colaborador) acessa o módulo de rotinas do sistema para verificar tarefas atribuídas.
Pré-condição: usuário autenticado e com permissões para visualizar suas delegações.

---

### **II. Visualizar Rotinas pendentes**

O sistema apresenta uma lista de rotinas pendentes atribuídas ao usuário.
Essa tela pode oferecer filtros (por projeto, prioridade, data limite, tags) e ordenação (mais recente, mais urgente).

---

### **III. Selecionar Rotina**

O usuário escolhe uma rotina específica da lista para visualizar detalhes e suas ações relacionadas.
Ao selecionar, a interface abre o painel com todas as informações da rotina (título, descrição, data limite, responsáveis, tags, ações).

---

### **IV. Visualizar Ações da rotina selecionada**

Nesta etapa, o usuário vê a lista de ações que compõem a rotina — cada ação com seu status, descrição, tempo estimado e, possivelmente, subtarefas.
O usuário pode clicar em cada ação para ver detalhes ou instruções adicionais.

---

### **V. Concluir as Ações**

O colaborador executa e marca como concluídas as ações pertinentes.
Regras típicas (dependem da configuração do sistema):

* A marcação de uma ação como concluída pode requerer evidência (comentário, anexo, foto).
* A conclusão de todas as ações necessárias é condição para fechar a rotina.

---

### **VI. Fechar a Rotina**

Com as ações concluídas, o usuário encerra (fecha) a rotina.
Ao fechar:

* O status da rotina muda para `CONCLUIDA` (se todas as condições foram atendidas).
* Pode ser registrado o tempo efetivamente gasto, comentários finais e anexos.
* O sistema gera log de conclusão e notifica o responsável/gestor (se configurado).

---

### **VII. Fim**

Fluxo finalizado — rotina concluída e auditoria registrada.

---

## **Diagrama de Sequência — Gerenciamento de Rotina**

### **Imagem do Diagrama**

![Diagrama de Sequência — Gerenciamento de Rotina](/img/DiagramaSequencia-1.png)

---

## **Descrição Detalhada do Fluxo (Versão Completa e Equilibrada)**

### **I. Início da Ação — Solicitação do Usuário**

O fluxo começa quando o **usuário solicita criar ou editar uma rotina** através da interface.
Essa requisição é capturada pelo Front End, que inicia o processo de comunicação com o Back End.

---

### **II. Verificação de Permissão**

O Front End envia a intenção de ação ao Back End para garantir que o usuário tem nível de acesso adequado.
O Back End então:

1. Valida autenticação (token, sessão, JWT).
2. Consulta o banco para confirmar o nível de permissão.
3. Retorna ao Front End se o usuário está autorizado.

Se não tiver permissão, o fluxo termina com mensagem de erro.

---

### **III. Exibição do Formulário**

Com a permissão validada:

* O Front End exibe o formulário completo da rotina.
* O usuário insere dados como:

  * Título
  * Datas
  * Ações
  * Tags
  * Recorrência
  * Prioridade
  * Projeto associado

Após preencher, o usuário envia os dados para processamento.

---

### **IV. Validação de Dados pelo Back End**

O Back End recebe o conjunto de informações e realiza validações importantes:

* Campos obrigatórios preenchidos
* Datas válidas (início, limite, recorrência)
* Formato correto dos dados
* Checagem das ações fornecidas
* Verificação se o projeto associado existe e está ativo
* Regras de recorrência, caso existam
* Estrutura geral do payload

Se qualquer dado estiver incorreto → o Back End retorna mensagem de erro ao Front End.

---

### **V. Salvamento da Rotina (Caso os Dados Sejam Válidos)**

Se os dados estiverem corretos:

1. O Back End grava a rotina no banco de dados.
2. As ações e tags associadas também são salvas.
3. O sistema gera registro de auditoria (quem criou/editou, quando e o que).
4. O Back End retorna confirmação de salvamento.

O Front End então exibe mensagem de sucesso ao usuário.

---

### **VI. Retorno de Erro (Caso os Dados Sejam Inválidos)**

Se as validações falharem:

* O Back End retorna os erros encontrados.
* O Front End apresenta mensagens claras para que o usuário possa corrigir.
* O fluxo volta ao ponto de edição para ajuste das informações.

Esse caminho não altera o banco de dados.

---

### **VII. Finalização**

O fluxo termina quando:

* A rotina é criada/atualizada com sucesso,
  **ou**
* O formulário é exibido com mensagens de erro para correção.

Em caso de sucesso, o sistema pode ainda acionar mecanismos adicionais como:

* Envio de notificações
* Atualização de dashboards
* Registro em logs
* Disparo de eventos internos

---

# **Caso de Uso — Gerenciamento de Empresas**

## **Imagem do Diagrama**

![Diagrama de Sequência — Gerenciamento de Rotina](/img/CasoUso-1.png)

---

## **Descrição do Caso de Uso**

### **I. Visão Geral**

O caso de uso **Gerenciamento de Empresas** reúne as funcionalidades voltadas à criação, busca e manutenção de empresas dentro do sistema.
Os atores **MASTER** e **Administrador** possuem permissão para executar essas operações, garantindo o controle centralizado das informações institucionais.

---

## **II. Atores Envolvidos**

### **II.1. MASTER**

* Acesso completo ao módulo.
* Pode cadastrar, pesquisar e manter qualquer empresa.

### **II.2. Administrador**

* Pode executar as mesmas ações que o MASTER, exceto operações mais sensíveis (dependendo das regras internas do sistema).

---

## **III. Casos de Uso**

---

### **III.A — Cadastrar Empresa**

**Objetivo:** Criar um novo registro empresarial no sistema.

**Fluxo Principal:**

1. O ator acessa *Gerenciamento de Empresas* e escolhe **Cadastrar Empresa**.
2. O sistema exibe o formulário de cadastro.
3. O ator preenche dados como nome, CNPJ e e-mail.
4. O sistema valida os dados (formato, duplicidade etc.).
5. Em caso de sucesso, a empresa é salva e uma mensagem de confirmação aparece.

**Fluxos Alternativos:**

* CNPJ inválido/duplicado → erro.
* Falta de permissão → acesso negado.

---

### **III.B — Pesquisar Empresa**

**Objetivo:** Permitir a localização de empresas já cadastradas.

**Fluxo Principal:**

1. O ator acessa a opção **Pesquisar Empresa**.
2. Informa os filtros desejados (nome, CNPJ, e-mail…).
3. O sistema retorna a lista correspondente.
4. O ator seleciona uma empresa para visualizar detalhes ou editar.

**Fluxos Alternativos:**

* Nenhum resultado encontrado → sistema informa.
* Filtros insuficientes (dependendo da regra) → solicitar mais critérios.

---

### **III.C — Manter Empresa (extends Pesquisar Empresa)**

**Objetivo:** Editar ou atualizar dados de uma empresa existente.

**Fluxo Principal:**

1. Após encontrar a empresa, o ator escolhe **Manter Empresa**.
2. O sistema exibe o formulário com as informações atuais.
3. O ator modifica dados desejados.
4. O sistema valida e salva as alterações.
5. Mensagem de sucesso é exibida.

**Fluxos Alternativos:**

* Dados inválidos → erro.
* Empresa inativa ou inexistente → ação bloqueada.

---

## **IV. Observações Importantes**

* O caso **Manter Empresa** depende de **Pesquisar Empresa**, por isso aparece como *extends* no diagrama.
* Ambos os atores podem executar as ações, mas certos cenários (como desativação) podem ser restritos ao MASTER.
* Todas as ações executadas geram registro de auditoria no sistema.

---

# **Caso de Uso — Gerenciamento de Usuários**

## **Imagem do Diagrama**

![Caso de Uso – Gerenciamento de Usuários](/img/CasoUso-2.png)

---

## **Descrição do Caso de Uso**

### **I. Visão Geral**

O módulo **Gerenciamento de Usuários** permite que atores com privilégios administrativos — **MASTER** e **Administrador** — realizem operações de cadastro, busca e manutenção de usuários dentro do sistema.
Ele é essencial para controlar quem pode acessar o sistema, quais permissões cada um possui e como cada usuário se relaciona com empresas e rotinas.

---

## **II. Atores Envolvidos**

### **II.1. MASTER**

* Permissão total sobre usuários.
* Pode criar, pesquisar, editar, redefinir status e alterar níveis de acesso.

### **II.2. Administrador**

* Pode realizar operações de cadastro, pesquisa e manutenção de usuários, exceto ações críticas que dependem exclusivamente do MASTER (como redefinir nível para MASTER, suspensão total etc.).

---

## **III. Casos de Uso**

---

### **III.A — Cadastrar Usuário**

**Objetivo:** Criar um novo usuário no sistema, definindo seus dados pessoais e nível de acesso.

**Fluxo Principal:**

1. O ator acessa o módulo e seleciona **Cadastrar Usuário**.
2. O sistema exibe o formulário com campos como nome, e-mail, CPF, empresa e nível.
3. O ator preenche as informações.
4. O sistema valida dados obrigatórios, formato e duplicidade (ex.: e-mail já existente).
5. Caso tudo esteja correto, o usuário é salvo no banco de dados.
6. O sistema confirma a criação e exibe mensagem de sucesso.

**Fluxos Alternativos:**

* E-mail/CPF duplicado → bloqueia cadastro.
* Dados inválidos → exibe erros no formulário.
* Permissão insuficiente → nega ação.

---

### **III.B — Pesquisar Usuário**

**Objetivo:** Permitir filtrar e localizar usuários cadastrados no sistema.

**Fluxo Principal:**

1. O ator acessa **Pesquisar Usuário**.
2. Informa filtros como nome, e-mail, CPF, empresa ou status.
3. O sistema retorna lista dos usuários que correspondem à busca.
4. O ator seleciona um usuário para visualizar ou editar.

**Fluxos Alternativos:**

* Nenhum resultado encontrado → sistema informa.
* Filtros incompletos (se a regra exigir) → solicitar definição melhor.

---

### **III.C — Manter Usuário (extends Pesquisar Usuário)**

**Objetivo:** Atualizar dados de um usuário existente.

**Fluxo Principal:**

1. Após localizar o usuário, o ator seleciona **Manter Usuário**.
2. O sistema exibe os dados atuais (nome, e-mail, status, nível etc.).
3. O ator edita os campos desejados.
4. O sistema valida e salva as alterações.
5. Exibe mensagem de sucesso e registra auditoria.

**Fluxos Alternativos:**

* Tentativa de editar usuário inexistente → erro.
* Alterações inválidas (e-mail já usado, CPF incompatível) → erro.
* Ações de alto risco (como mudar nível para MASTER) podem exigir confirmação especial.

---

## **IV. Observações Importantes**

* O caso **Manter Usuário** depende da busca, por isso está ligado como **extends** a **Pesquisar Usuário**.
* O MASTER pode editar qualquer usuário; o Administrador pode estar limitado a usuários da mesma empresa.
* Toda alteração deve gerar log no sistema para fins de rastreamento.

---

# **Caso de Uso — Login e Acesso ao Sistema**

## **Imagem do Diagrama**
>
![Caso de Uso – Login](/img/CasoUso-3.png)

---

## **Descrição do Caso de Uso**

### **I. Visão Geral**

O módulo **Login** reúne as funcionalidades fundamentais de autenticação e manutenção de sessão dentro do sistema.
Ele é acessado por todos os perfis — **MASTER**, **Administrador** e **Funcionário** — representando o ponto inicial para utilização do sistema e o gerenciamento da credencial do usuário.

As funcionalidades incluídas são:

* **Login**
* **Logout**
* **Trocar Senha**
  Sendo que **Logout** e **Trocar Senha** dependem do usuário estar autenticado, e o caso “Login” é o ponto inicial para todos.

---

## **II. Atores Envolvidos**

### **II.1. MASTER**

Possui acesso ao login e todas as ações posteriores. Pode redefinir sua própria senha e sai da sessão via logout.

### **II.2. Administrador**

Autentica-se para acessar ações administrativas do sistema e também pode trocar sua senha e encerrar sessão.

### **II.3. Funcionário**

Realiza login para acessar suas rotinas, concluir ações e interagir com atividades delegadas. Também pode trocar senha e encerrar a sessão.

---

## **III. Casos de Uso**

---

### **III.A — Login**

**Objetivo:** Autenticar o usuário no sistema permitindo acesso às funcionalidades internas.

**Fluxo Principal:**

1. O usuário acessa a tela inicial e escolhe **Login**.
2. O sistema solicita usuário/e-mail e senha.
3. O usuário informa as credenciais.
4. O sistema valida os dados (autenticação).
5. Em caso de sucesso, a sessão é iniciada e o usuário é direcionado à página principal apropriada ao seu nível.

**Fluxos Alternativos:**

* Credenciais inválidas → sistema exibe erro e permite tentar novamente.
* Usuário bloqueado/inativo → acesso negado.
* Regras adicionais podem ser aplicadas (ex.: autenticação de dois fatores).

---

### **III.B — Logout (extends Login)**

**Objetivo:** Encerrar a sessão do usuário de forma segura.

**Fluxo Principal:**

1. Usuário já autenticado seleciona **Logout**.
2. O sistema invalida o token/sessão atual.
3. O usuário é redirecionado para a tela de Login.

**Fluxos Alternativos:**

* Sessão expirada → o sistema força logout automaticamente e exibe aviso.

---

### **III.C — Trocar Senha**

**Objetivo:** Permitir ao usuário alterar sua própria senha por segurança ou atualização de credenciais.

**Fluxo Principal:**

1. O usuário acessa a opção **Trocar Senha**.
2. O sistema exibe os campos: senha atual, nova senha e confirmação.
3. O usuário informa os dados.
4. O sistema valida:

   * senha atual correta,
   * regras de complexidade,
   * correspondência da confirmação.
5. Senha atualizada com sucesso; mensagem exibida.

**Fluxos Alternativos:**

* Senha atual incorreta → erro.
* Nova senha inválida (complexidade mínima) → erro.
* Duas senhas não coincidem → erro.

---

## **IV. Observações Importantes**

* Todos os atores do sistema compartilham o caso de uso **Login**, pois ele é obrigatório para acesso ao sistema.
* **Logout** depende de uma sessão válida, por isso aparece como extensão após o login.
* **Trocar Senha** pode ser acessado tanto pelo usuário logado quanto em fluxos especiais (recuperação de senha), dependendo da implementação.
* A segurança deste módulo é fundamental, pois controla o acesso geral do sistema.

---

# **Caso de Uso — Execução de Rotinas**

## **Imagem do Diagrama**

![Caso de Uso – Execução de Rotinas](/img/CasoUso-4.png)

---

## **Descrição do Caso de Uso**

### **I. Visão Geral**

O módulo **Execução de Rotinas** descreve como o **Funcionário** interage com as rotinas que lhe foram atribuídas.
Ele engloba ações como visualizar rotinas recebidas, abrir rotinas específicas e executar atividades internas (concluir ações e fechar rotinas).
Esse módulo representa o fluxo principal de trabalho do usuário que executa tarefas no dia a dia.

---

## **II. Ator Envolvido**

### **II.1. Funcionário**

É o ator responsável por receber, abrir e executar rotinas.
Ele não cria rotinas — apenas interage com aquelas delegadas a ele pelo gerente ou administrador.

---

## **III. Casos de Uso**

---

### **III.A — Visualizar Rotinas Recebidas**

**Objetivo:** Permitir que o funcionário veja todas as rotinas delegadas para ele.

**Fluxo Principal:**

1. O funcionário acessa a opção **Visualizar Rotinas Recebidas**.
2. O sistema exibe uma lista com todas as rotinas atribuídas, com informações como status, prioridade, prazo e progresso.
3. O funcionário seleciona uma rotina para abrir.

**Fluxos Alternativos:**

* Nenhuma rotina atribuída → o sistema informa que não há tarefas pendentes.
* Filtros opcionais podem ser utilizados (prioridade, data, projeto, tags).

---

### **III.B — Abrir Rotina**

**Objetivo:** Acessar o conteúdo e as ações internas de uma rotina específica.

**Fluxo Principal:**

1. O funcionário seleciona uma rotina da lista.
2. O sistema carrega os detalhes: descrição, ações, status atual, horários e histórico.
3. A partir daqui, o funcionário pode:

   * Executar ações
   * Acompanhar progresso
   * Concluir ações
   * Fechar a rotina quando terminar tudo

Esse caso de uso serve como ponto central, pois todos os demais se conectam a ele.

---

### **III.C — Concluir Ação (extends Abrir Rotina)**

**Objetivo:** Registrar que uma ação interna da rotina foi realizada.

**Fluxo Principal:**

1. Dentro da rotina aberta, o funcionário escolhe uma ação pendente.
2. O sistema exibe detalhes (observações, instruções, subtarefas).
3. O funcionário marca a ação como concluída.
4. O sistema atualiza o status da ação e associa o registro de conclusão ao funcionário.

**Fluxos Alternativos:**

* Ação já concluída → sistema impede duplicidade.
* Informações obrigatórias (ex.: evidências) podem ser solicitadas dependendo da regra.

---

### **III.D — Fechar Rotina (extends Abrir Rotina)**

**Objetivo:** Encerrar oficialmente a rotina após todas as ações estarem concluídas.

**Fluxo Principal:**

1. Depois que todas as ações estiverem finalizadas, o funcionário escolhe **Fechar Rotina**.
2. O sistema verifica se realmente não há ações pendentes.
3. Caso tudo esteja concluído, a rotina é marcada como **Concluída**.
4. O sistema registra a finalização e atualiza dashboards e relatórios.

**Fluxos Alternativos:**

* Se houver ações pendentes → o sistema bloqueia o fechamento e informa quais tarefas ainda faltam.
* Se a rotina estiver atrasada, o sistema pode registrar automaticamente indicadores de atraso.

---

## **IV. Observações Importantes**

* O caso **Abrir Rotina** é o núcleo do módulo. Por isso, **Concluir Ação** e **Fechar Rotina** aparecem como *extends*, já que dependem da rotina estar aberta.
* A execução de rotinas é um processo cíclico: visualizar → abrir → concluir ações → fechar.
* Toda ação executada pelo funcionário gera eventos de auditoria e atualiza o progresso da rotina.
* Esse módulo normalmente aparece muito no dashboard do funcionário, pois representa sua rotina diária.

---

# **Modelo do Banco de Dados**

## **Imagem do Modelo**


![Modelo de Banco de Dados](/img/ModeloBanco.png)

---

## **Descrição Geral**

O modelo representa o domínio do **Gerenciador de Rotinas**: usuários, empresas, projetos, rotinas, ações, tags e as relações de delegação e categorização. As relações principais são:

* `Empresa` → `Usuario` (uma empresa tem vários usuários)
* `Projeto` → `Rotina` (um projeto contém várias rotinas)
* `Rotina` → `Acao` (uma rotina é composta por várias ações)
* `Rotina` ↔ `Tag` (relação N:N via tabela associativa `RotinaTag`)
* `Rotina` ↔ `Usuario` (delegação: N:N com atributos via `DelegacaoRotina`)
* Logs de sistema capturam eventos relacionados a usuários/ações

Abaixo, a documentação por entidade, com os atributos relevantes, chaves e regras de relacionamento.

---

### **I. Tabela: Empresa**

**Propósito:** representa as empresas/organizações que agrupam usuários, projetos e rotinas.

**Atributos principais**

* `id_empresa` (PK, integer, auto-increment)
* `nome` (varchar)
* `email` (varchar) — contato administrativo
* `data_hora_entrada` (timestamp) — quando a empresa foi criada/registrada
* *(opcionais sugeridos)* `cnpj` (varchar, único), `telefone`, `endereco`

**Regras & índices**

* `cnpj` recomendado como `UNIQUE` se usado no negócio.
* índice em `nome` para busca.

**Relacionamentos**

* 1 `Empresa` — N `Usuario` (FK `usuario.id_empresa` → `empresa.id_empresa`)

---

### **II. Tabela: Usuario**

**Propósito:** representa contas (MASTER, ADMIN, FUNCIONARIO).

**Atributos principais**

* `id_usuario` (PK)
* `nome` (varchar)
* `cpf` (varchar) — identificador (opcional dependendo do país)
* `email` (varchar) — `UNIQUE` recomendado
* `senha_hash` (varchar)
* `role` / `nivel` (enum: `MASTER`, `ADMIN`, `FUNCIONARIO`)
* `status` (enum: `ATIVO`, `INATIVO`, `BLOQUEADO`)
* `data_hora_entrada` (timestamp)
* `id_empresa` (FK → `empresa.id_empresa`)
* `segredo_2fa` (varchar, nullable) — para 2FA

**Regras & índices**

* `email` e `cpf` devem ter índices/constraints de unicidade dependendo da política.
* índice composto possível: `(id_empresa, email)` se e-mail só for único por empresa.
* armazenar `senha_hash` (nunca armazenar senha em plain text).

**Relacionamentos**

* N `Usuario` pertence a 1 `Empresa`.
* 1 `Usuario` cria (FK) `Projeto`, `Rotina`, `Acao`, `Tag` (campo `id_criador` nas respectivas tabelas).
* `Usuario` participa da relação de delegação (`DelegacaoRotina`).

---

### **III. Tabela: Projeto**

**Propósito:** agrupar rotinas por iniciativa, time, ou escopo.

**Atributos principais**

* `id_projeto` (PK)
* `nome` (varchar)
* `id_criador` (FK → `usuario.id_usuario`)
* `status` (opcional: ativo/inativo)
* timestamps (`created_at`, `updated_at`)

**Regras & índices**

* índice em `nome` para busca.
* checar `id_criador` válido.

**Relacionamentos**

* 1 `Projeto` — N `Rotina` (`rotina.id_projeto` → `projeto.id_projeto`).
* `Projeto` pode ser obrigatório ou opcional para `Rotina` (no modelo aparece `0..1`).

---

### **IV. Tabela: Rotina**

**Propósito:** entidade central que descreve uma rotina de trabalho.

**Atributos principais**

* `id_rotina` (PK)
* `nome` / `titulo` (varchar)
* `data_hora_criacao` (timestamp)
* `data_conclusao` (date / timestamp nullable)
* `hora_conclusao` (time nullable)
* `recorrente` (boolean)
* `recorrencia_regra` (varchar/json) — regra/cron para recorrência
* `status` (enum: `PENDENTE`, `EM_EXECUCAO`, `CONCLUIDA`, `CANCELADA`)
* `prioridade` (enum: `BAIXA`, `MEDIA`, `ALTA`)
* `id_criador` (FK → `usuario.id_usuario`)
* `id_projeto` (FK → `projeto.id_projeto`, nullable)
* `ultima_modificacao` (timestamp)
* `data_limite` (timestamp / date nullable)

**Regras & índices**

* índice em `status`, `data_limite` para consultas frequentes.
* `recorrencia_regra` pode ser JSON para flexibilidade (ex.: `{ type: "weekly", every: 1, days: ["Mon"] }`).

**Relacionamentos**

* 1 `Rotina` — N `Acao` (`acao.id_rotina` → `rotina.id_rotina`) (composição: ações fazem parte da rotina).
* `Rotina` — N `Tag` (via `RotinaTag`) (N:N).
* `Rotina` — N `DelegacaoRotina` (várias delegações a usuários).
* `Rotina` pertence opcionalmente a 1 `Projeto`.
* `id_criador` aponta para `Usuario` que criou a rotina.

---

### **V. Tabela: Acao**

**Propósito:** tarefas atômicas que compõem uma rotina.

**Atributos principais**

* `id_acao` (PK)
* `nome` (varchar)
* `id_rotina` (FK → `rotina.id_rotina`)
* `id_criador` (FK → `usuario.id_usuario`)
* `data_hora_criacao` (timestamp)
* `hora_conclusao` (time / timestamp nullable)
* `status` (enum: `PENDENTE`, `EM_EXECUCAO`, `CONCLUIDA`)
* `definicao_conclusao` (text) — evidências / critérios
* `ultima_modificacao` (timestamp)
* `ordem` (int) — posição sequencial dentro da rotina
* `tempo_estimado_min` (integer) — estimativa

**Regras & índices**

* índice por `id_rotina` para recuperar ações por rotina ordenadas por `ordem`.
* restrição: não permitir remoção de ações já concluídas (ou fazer soft delete).

**Relacionamentos**

* N `Acao` pertence a 1 `Rotina`.
* `Acao.id_criador` referencia `Usuario`.

---

### **VI. Tabela: Tag**

**Propósito:** classificar rotinas por categorias livres.

**Atributos principais**

* `id_tag` (PK)
* `nome` (varchar)
* `cor` (varchar — hex / nome)
* `id_criador` (FK → `usuario.id_usuario`)
* timestamps

**Regras & índices**

* `nome` pode ser `UNIQUE` por empresa/escopo (ou global), dependendo do requisito.
* índice em `nome` para busca.

**Relacionamentos**

* N `Tag` ↔ N `Rotina` via `RotinaTag` (table associativa).

---

### **VII. Tabela: RotinaTag** (associativa)

**Propósito:** representa a relação N:N entre `Rotina` e `Tag`.

**Atributos principais**

* `id_rotina` (PK parcial, FK → `rotina.id_rotina`)
* `id_tag` (PK parcial, FK → `tag.id_tag`)
* (opcionais) `criado_em`, `criado_por` — histórico

**Regras**

* PK composta (`id_rotina`, `id_tag`) para evitar duplicatas.
* Índice secundário por `id_tag` para buscar rotinas por tag.

---

### **VIII. Tabela: DelegacaoRotina** (ou `Delega`)

**Propósito:** modela a delegação de uma rotina a um funcionário — relação N:N entre `Rotina` e `Usuario` com atributos (status do progresso, % conclusão).

**Atributos principais**

* `id_delegacao` (PK, integer) — opcional; ou PK composta (`id_rotina`, `id_usuario`)
* `id_rotina` (FK → `rotina.id_rotina`)
* `id_funcionario` / `id_usuario` (FK → `usuario.id_usuario`)
* `status_progresso` (enum: `NAO_INICIADO`, `EM_ANDAMENTO`, `CONCLUIDO`)
* `progresso_percentual` (float / decimal)
* `criado_em` (timestamp)
* `atribuido_por` (FK → `usuario.id_usuario`) — quem delegou (opcional)

**Regras & índices**

* PK composta (`id_rotina`, `id_usuario`) evita duplicar delegações.
* validar `progresso_percentual` entre 0 e 100.
* índice por `id_usuario` para recuperar delegações por funcionário.

**Relacionamentos**

* `Rotina` ↔ `Usuario` via `DelegacaoRotina` (N:N com atributos).

---

### **IX. Tabela: LogSistema**

**Propósito:** armazenar eventos e auditoria de sistema.

**Atributos principais**

* `id_log` (PK)
* `nivel` (enum: `INFO`, `ALERTA`, `ERRO`)
* `mensagem` (text)
* `contexto` (longtext/json) — detalhes adicionais (payload, stacktrace)
* `id_usuario_relacionado` (FK → `usuario.id_usuario`, nullable)
* `timestamp` (timestamp)

**Regras**

* gravar logs de eventos importantes (criação/edição/exclusão/erros).

---

## **X. Resumo dos Principais Relacionamentos (cardinalidades)**

1. **Empresa (1) — (N) Usuario**

   * Uma empresa tem vários usuários; usuário pertence a uma empresa.

2. **Usuario (1) — (N) Projeto / Rotina / Acao / Tag (como criador)**

   * Usuários são autores/gestores dos recursos (campo `id_criador`).

3. **Projeto (1) — (N) Rotina**

   * Um projeto agrupa várias rotinas; associação opcional em rotinas.

4. **Rotina (1) — (N) Acao**

   * Rotina composta por ações; exclusão de rotina deve cascatar ou exigir exclusão/arquivamento de ações.

5. **Rotina (N) — (N) Tag** (via `RotinaTag`)

   * Permite categorização flexível.

6. **Rotina (N) — (N) Usuario** (via `DelegacaoRotina`, com atributos)

   * Delegações possuem `status_progresso` e `progresso_percentual`.

7. **Rotina** — `Log` (eventos) / `Delegacao` / `RotinaTag` — entidades auxiliares que adicionam informações relacionais e de histórico.

---

## **XI. Boas práticas / recomendações de implementação**

* **Chaves e FKs:** definir FKs com `ON DELETE RESTRICT` para evitar exclusões acidentais; em alguns casos usar `ON DELETE CASCADE` (ex.: ao remover rotina, remover `acao` ou marcar soft-delete).
* **Soft delete:** preferir `deleted_at` (timestamp) para preservar histórico e integridade referencial.
* **Auditoria:** manter campos `created_by`, `created_at`, `updated_by`, `updated_at` em todas as tabelas críticas.
* **Índices:** colocar índices em colunas frequentemente filtradas: `status`, `data_limite`, `id_projeto`, `id_usuario` (em delegações).
* **Consistência em concorrência:** usar **optimistic locking** (`version` ou `ultima_modificacao`) nas entidades editáveis (Rotina, Acao).
* **Normalização:** modelo atual está normalizado; se precisar otimizar leitura (dashboards), considerar tabelas de agregação ou materialized views.
* **Tipos e tamanhos:** escolher tipos apropriados (timestamp with timezone se necessário; integers para ids; varchar com limites razoáveis).
* **Validações de negócio:** impor unicidade onde fizer sentido (`email`, `cpf`, `cnpj`) e regras de domínio (ex.: rotina concluída requer todas ações concluídas).

