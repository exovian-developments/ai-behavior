<div align="center">

# ai-behavior

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

</div>

## O que é?
Um protocolo de trabalho para agentes de IA (`Claude Code`, `Codex`, `Gemini CLI`) compatível com todos os tipos de projetos de software, baseado em um conjunto de arquivos `.json` (json_schema) que fornecem orientação para operação e geração de contextos para trabalhar com precisão em projetos reais.

**Padrão:** Cada `json_schema` contém o seguinte para cada objeto na estrutura:
- `description` = Descrição do campo/propriedade, para que o LLM entenda claramente qual conteúdo gerar.
- `$comment` = Como o LLM deve operar nesse campo, sem inferências e melhorando a precisão do resultado.

## Resultados Comprovados
Estes schemas foram usados e refinados com `Claude Code`, `Codex` e `Gemini CLI`* e são capazes de:

**1. Gerar e trabalhar com contexto global do projeto**
- Gerar um manifesto estruturado do projeto (linguagem, framework, arquitetura, padrões por camadas, funcionalidades, etc).
- Gerar regras de codificação (padrões e standards) e segui-las.
- Seguir o estilo de trabalho do usuário responsável.

**2. Gerar e trabalhar com contexto focado em tarefas/tickets/histórias**
- Geração de contexto "focado" por ticket de desenvolvimento que pode ser estendido entre vários LLMs e sessões (logbook).
- Produzir código seguindo as regras do projeto (geradas previamente).
- Criar um comentário de resolução estruturado por ticket baseado no logbook do ticket.

**Nota: Gemini CLI** Em muitos testes, foi comprovado que `Gemini CLI` funciona melhor produzindo resultados em formato `.md` porque em `.json` frequentemente tem problemas com âncoras para adicionar e modificar elementos no `.json`.

## 🛠️ Instalação

### Opção 1: Homebrew (Recomendado para macOS/Linux)
```bash
brew tap exovian-developments/tap
brew install ai-behavior

# Da raiz do seu projeto
ai-behavior
```

### Opção 2: Script de Instalação
```bash
# Baixe o script primeiro (SEMPRE inspecione scripts antes de executá-los)
curl -O https://raw.githubusercontent.com/exovian-developments/ai-behavior/main/install.sh

# Inspecione o conteúdo
cat install.sh

# Se parecer seguro, execute-o da raiz do seu projeto
bash install.sh
```

⚠️ **Nota de Segurança:** Nunca execute scripts da internet sem revisá-los primeiro.

### Opção 3: Instalação Manual

**1.** Faça checkout do repositório `ai-behavior`.
```bash
git clone https://github.com/exovian-developments/ai-behavior.git
```

**2.** Na raiz do seu projeto, crie o diretório `ai_files` e os seguintes subdiretórios:
```bash
mkdir -p ai_files/{schemas,logbooks}
```

**3.** Copie os schemas localizados em `ai-behavior/schemas/` para o diretório `ai_files/schemas/` do seu projeto:
```bash
cp ai-behavior/schemas/*.json ai_files/schemas/
```

Schemas incluídos:
  - `logbook_software_schema.json`
  - `software_manifest_schema.json`
  - `project_rules_schema.json`
  - `ticket_resolution_schema.json`
  - `user_pref_schema.json`

**4.** Adicione a seguinte seção no início do arquivo do seu agente `CLAUDE.md`, `AGENT.md`, `GEMINI.md`.
```
# Key files to review on session start:
  required_reading:
    - path: "ai_files/project_manifest.json"
      description: "Detailed explanation about structure, technologies, architecture and features of the current project"
      when: "always"

    - path: "ai_files/project_rules.json"
      description: "This file contains the coding expectation, always follow these coding rules to keep the code consistency and cohesion"
      when: "always"

    - path: "ai_files/user_pref.json"
      description: "This file contains the user interaction preferences when working, always follow this instructions"
      when: "always"

    - path: "ai_files/logbooks/"
      description: "Directory to create and read logbooks related to development tickets. Ask for the logbook to read or create"
      when: "always"

    - path: "ai_files/schemas/software_manifest_schema.json"
      description: "Json file with structure and guidance about how to create or update a project manifest"
      when: "when_user_ask"

    - path: "ai_files/schemas/project_rules_schema.json"
      description: "Json file with structure and guidance about how to create coding rules, standards and criterias"
      when: "when_user_ask"

    - path: "ai_files/schemas/logbook_software_schema.json"
      description: "Json file with structure and guidance about how to create a logbook to track and maintain conversational context for long-term memory and task tracking."
      when: "when_user_ask"

    - path: "ai_files/schemas/ticket_resolution_schema.json"
      description: "Json file with structure and guidance about how to create a summary of the resolution of the work done"
      when: "when_user_ask"

    - path: "ai_files/schemas/user_pref_schema.json"
      description: "Json file with structure and guidance about how to create a profile with guidance about how the interaction between the agent and the user"
      when: "when_user_ask"

```

**5.** _(Opcional)_ Adicione o diretório `ai_files/logbooks/` ao seu `.gitignore` para evitar commitar logbooks de trabalho:
```bash
echo "ai_files/logbooks/" >> .gitignore
```

## 🧭 Quando Usar
- Projetos em Andamento: Comece criando o manifesto e regras a partir do código; depois use o logbook e o schema de resolução de tickets para o trabalho diário com tickets de desenvolvimento.

- Projetos Novos (Greenfield): Use os schemas para gerar um manifesto e regras base para seu projeto; evolua conforme o código cresce.

> [!IMPORTANT] Sobre os Prompts:
> Os prompts incluídos são guias comprovados que você pode copiar e usar diretamente. Você também pode criar seus próprios prompts mantendo ou melhorando a ideia de acordo com seu contexto.

## 🌎 Como Criar o Contexto Global

**1.** Crie suas preferências de interação:
- Arquivo resultante: `user_pref.json`
- Schema: `ai_files/schemas/user_pref_schema.json`
- Prompt _(Copie e cole na conversa com seu agente)_:
```
Analise todo o arquivo user_pref_schema.json e com base na estrutura e descrição de cada propriedade e objeto no arquivo, faça-me perguntas para gerar o arquivo ai_files/user_pref.json. Depois de terminar as perguntas, gere o arquivo cumprindo o objetivo semântico de cada propriedade indicada no schema. Seja o moderador da conversa, seja conciso nas perguntas, não modifique o objeto final e se você ver que eu me desvio de alguma pergunta, seja proativo e retome o fio da conversa para gerar o arquivo.
```

**2.** Crie o Manifesto do Projeto (Atualize de tempos em tempos)
- Arquivo resultante: `project_manifest.json`
- Schema: `ai_files/schemas/software_manifest_schema.json`
- Prompt _(Copie e cole na conversa com seu agente)_:
```
Analise todo o arquivo software_manifest_schema.json, depois com base na estrutura e descrição de cada propriedade e objeto no arquivo, analise o projeto atual e identifique estritamente o que é solicitado no arquivo; para fazer a análise, vá a cada diretório e arquivo do projeto; não ignore caminhos ou arquivos porque podem ser relevantes para descobrir padrões, arquitetura ou funcionalidades do projeto. Finalmente gere o arquivo ai_files/project_manifest.json cumprindo o objetivo semântico de cada propriedade indicada no schema.
```

**3.** Crie as Regras do Projeto: Seja um projeto em andamento ou novo, é recomendado criar regras por camadas, para que você possa criar ou identificar regras de acordo com as boas práticas específicas da camada e abordar particularidades com atenção. É recomendado ter suporte ou experiência para evitar over-engineering neste processo.
- Arquivo resultante: `project_rules.json`
- Schema: `ai_files/schemas/project_rules_schema.json`
- Recomendação: Envie um prompt separado para cada `layer` de `project_manifest.technical_details.architecture_identified`.
- Riscos: Over-engineering foi detectado, mas se você reforçar o princípio YAGNI no prompt, melhora bastante.
- Prompt _(indique a camada a analisar de acordo com o detectado no `project_manifest`)_:
```
Analise todo o arquivo project_rules_schema.json, depois analise a camada <layer> e tudo relacionado de acordo com ai_files/project_manifest.json e depois vá ao código do projeto e busque classes, objetos, funções e métodos relacionados, rastreie tudo relacionado e de acordo com o conteúdo encontrado identifique padrões, gere regras de arquitetura que foram aplicadas, extraia e gere convenções de nomenclatura, convenções de estrutura de classes, até considere padrões que não sejam boas práticas mas que foram implementados ao longo do conteúdo analisado. Sempre siga os critérios indicados em project_rules_schema.json quando criar uma regra e sempre aplique o princípio YAGNI. Finalmente atualize o arquivo ai_files/project_rules.json seguindo as instruções em ai_files/schemas/project_rules_schema.json, se o arquivo project_rules.json ainda não existe, então crie-o baseado na estrutura indicada em project_rules_schema.json e no conteúdo analisado.
```

## 🎯 Contexto Focado - O Verdadeiro Poder!
**O Logbook**

O logbook do ticket/história é o arquivo `.json` que contém o contexto focado em objetivos primários, secundários e registros de descobertas/progresso/problemas encontrados enquanto você trabalha, o resultado é um arquivo universal útil para qualquer agente, reutilizável por qualquer LLM, você pode até começar com um agente (por exemplo `claude code`) e mudar para `codex` se ele não resolver um problema corretamente.

Você pode ter duas sessões abertas com agentes diferentes desde que não estejam modificando arquivos no mesmo turno/tempo, você pode trabalhar simultaneamente, o importante é que cada agente adicione seus registros ao array de contexto recente do logbook.
- Arquivo resultante: `ai_files/logbooks/{logbookName}.json`
- Schema: `ai_files/schemas/logbook_software_schema.json`

**1.** Inicie a sessão de trabalho com seu agente: `claude`, `codex` ou `gemini`.

**2.** Forneça um prompt com detalhes do ticket/história a desenvolver. _(Copie/Cole o conteúdo ou conecte MCP tool e cole a URL do ticket ao agente)_.
- __Prompt de exemplo__:
```
(Este é um prompt de exemplo) Estaremos trabalhando na criação de um novo endpoint para que aplicações frontend (web e mobile) possam obter detalhes de produtos, este é o schema que devemos cumprir: ...[conteúdo técnico da API] ... e estes são os critérios de aceitação do ticket: ...[Critérios de aceitação]..., você tem alguma pergunta?
```

**3.** Rastreie código relacionado e planeje o trabalho:
- Prompt _(Copie e cole na conversa com seu agente)_:
```
De acordo com o ticket que compartilhei com você, vá ao código e rastreie arquivos/classes/funções/métodos/constantes/testes relacionados ao ticket. Use ai_files/project_manifest como guia inicial de alto nível. Depois gere uma lista de ações para alcançar o objetivo, ordene-a em ordem de resolução de dependências primeiro. Apresente para revisão, ajuste e confirmação humana.
```

**4.** Confirme o plano _(revisão humana)_:
- Usuário ajusta a lista, removendo ou adicionando detalhes para execução limpa preparada para as modificações em questão.
- Usuário solicita ver a versão "confirmada" da lista de ações. Confirma que os passos têm uma ordem lógica.

**5.** Crie o logbook _(Nome do arquivo a ser criado deve ser indicado)_
- Prompt _(Ajuste este prompt, copie e cole na conversa com seu agente)_:
```
Analise todo o arquivo ai_files/schemas/logbook_software_schema.json, depois com base na lista de ações que foi revisada e aprovada, crie o logbook ai_files/logbooks/{fileName}.json cumprindo o objetivo semântico de cada propriedade do schema. De agora em diante você será o moderador que mantém os objetivos do logbook atualizados, portanto, se você detectar que um novo objetivo aparece (primário ou secundário) adicione-o ou se algum for completado, mova-o para sua respectiva estrutura.
```

**6.** De tempos em tempos ou progresso _(Como salvar progresso em um videogame)_:
- Prompt (iterativo):
```
Com base no progresso, descobertas e problemas que tivemos, atualize o logbook de acordo com as regras do schema e crie comentários concisos no contexto recente, atualize os objetivos e o mantenha atualizado.
```

## Ao Finalizar um Ticket/História de Desenvolvimento (Opcional)

**Comentário de Resolução Técnica**

Tornou-se boa prática deixar um resumo rico do trabalho realizado para fechar cada ticket, para isso:

**1.** Criação do comentário de resolução do ticket:
- Arquivo: Não aplicável - Um comentário é entregue na tela.
- Schema: `ai_files/schemas/ticket_resolution_schema.json`
- Prompt _(Nome do logbook a analisar deve ser indicado)_:
```
Analise o arquivo ai_files/schemas/ticket_resolution_schema.json e com base no logbook ai_files/logbooks/{logbookName}.json crie um comentário de resolução em formato Markdown para copiar e colar na plataforma onde gerenciamos tickets de desenvolvimento.
```

## ✅ Validação Rápida
- Node (AJV): `npx ajv validate -s .ai_files/schemas/<schema>.json -d <data>.json`
- Python: `python -c "import json,sys,jsonschema as j; j.validate(json.load(open(sys.argv[2])), json.load(open(sys.argv[1])))" .ai_files/schemas/<schema>.json <data>.json`

## 🧩 Convenções
- IDs: `integer` com `minimum: 1`, estáveis uma vez criados.
- Tempos: `created_at` (UTC ISO 8601) imutável; `updated_at` (UTC) somente quando o conteúdo muda.
- Respeite `$comment`: prepend, limites, resumos, imutabilidade.

## 📜 Licença
- Código e schemas: Apache-2.0 (veja `LICENSE`).
- Documentação: você pode optar por CC BY 4.0 se separar a licença dos docs.
