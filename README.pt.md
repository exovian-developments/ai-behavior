<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*O framework de desenvolvimento de produtos para a era dos agentes IA*

</div>

## Por que Waves

O desenvolvimento de produtos como conhecíamos mudou. Agentes IA (Claude Code, Codex, Gemini CLI) comprimem o que antes levava 6 meses de desenvolvimento em dias ou semanas. Sprints de 2 semanas já não refletem o ritmo real do trabalho — o desenvolvimento não é mais o gargalo.

Waves substitui sprints fixos por **ondas**: ciclos orgânicos de duração variável onde cada onda leva um incremento de produto desde a validação até a produção. Uma onda dura o tempo que precisa — às vezes 3 dias, às vezes 3 semanas. Sem cerimônias artificiais ou timeboxes arbitrários.

## O que é

Waves é um protocolo estruturado que guia agentes IA pelo **ciclo de vida completo de um produto** — da primeira ideia ao código em produção. Funciona com `Claude Code`, `Codex` e `Gemini CLI` através de comandos interativos e schemas JSON estruturados.

Em vez de dar ao seu agente um prompt em branco e esperar o melhor, Waves o guia por um processo claro: primeiro entender se a ideia é viável, depois definir o que construir, planejar em que ordem, e finalmente escrever o código — com contexto completo em cada passo.

### O Ciclo de Vida do Produto

Waves organiza o trabalho em cinco níveis, onde cada um se constrói sobre o anterior:

**1. Viabilidade** → *Podemos construir isso? Devemos?*
Você descreve sua ideia em linguagem natural. O agente atua como consultor de negócios: analisa o mercado, identifica concorrentes, constrói projeções de receita com simulações Monte Carlo, e te dá números honestos sobre se isso pode funcionar.

**2. Foundation** → *O que aprendemos?*
A viabilidade pode produzir milhares de simulações em múltiplos cenários. O foundation compacta tudo em um resumo executivo: o problema validado, quem são seus usuários, o modelo de receita com unit economics, análise SWOT, capacidades essenciais, restrições de timeline, e um sinal claro de go/no-go.

**3. Blueprint** → *O que estamos construindo e por quê?*
Usando o foundation como input, você define o produto: suas capacidades, fluxos de usuário, princípios de design, regras de produto, métricas de sucesso e stack tecnológico. Cada seção conecta com o caso de negócio. Nada especulativo.

**4. Roadmap** → *Quando construímos e em que ordem?*
O roadmap pega as capacidades do blueprint e as organiza em fases com milestones, dependências e pontos de decisão. Usa a convenção de ondas: `roadmap_w0.json` (foundation), `roadmap_w1.json`+ (ondas de negócio).

**5. Logbook** → *Como implementamos esta peça específica?*
Para cada ticket ou tarefa, um logbook divide o trabalho em objetivos principais e secundários com guias de completação. O agente os implementa continuamente, atualiza o progresso em tempo real, e preserva o contexto completo entre sessões.

```
viabilidade → foundation → blueprint → roadmap → logbook
 PODEMOS?     O QUE         O QUÊ/POR  QUANDO?   COMO?
              APRENDEMOS?   QUÊ?
```

Cada nível alimenta o próximo. Você pode começar em qualquer nível — se já tem um produto e só precisa de logbooks para o trabalho diário, comece aí.

---

## Características

| Característica | Descrição |
|----------------|-----------|
| **Contexto Global** | Manifestos de projeto, regras de codificação, preferências de usuário |
| **Contexto Focado** | Logbooks de desenvolvimento por tickets/tarefas com objetivos e acompanhamento |
| **Multi-Agente** | Os mesmos arquivos funcionam com Claude Code, Codex e Gemini CLI |
| **Multi-Sessão** | Logbooks preservam contexto entre sessões |
| **Software + Geral** | Suporta projetos de software E acadêmicos, criativos, de negócio |

---

## Início Rápido (Plugin Cowork)

### Instalar

Baixe `waves.plugin` de [Releases](https://github.com/exovian-developments/waves/releases) e clique duas vezes para instalar no Claude desktop. Ou compile do código:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

### Uso

O plugin auto-carrega o contexto do projeto ao iniciar sessão. Use os comandos:

```
/project-init          # Inicializar preferências e contexto
/manifest-create       # Analisar projeto e criar manifesto
/logbook-create        # Criar logbook com objetivos
/logbook-update        # Registrar progresso nos objetivos
```

Veja [`plugin/README.md`](plugin/README.md) para documentação completa.

---

## Início Rápido (Claude Code)

### 1. Instalar

**Opção A: Homebrew (recomendado)**

```bash
brew tap exovian-developments/waves
brew install waves

# Inicializar no seu projeto
cd seu-projeto
waves init claude
```

**Opção B: Manual**

```bash
git clone https://github.com/exovian-developments/waves.git
mkdir -p seu-projeto/.claude/commands
cp -r waves/.claude/commands/* seu-projeto/.claude/commands/
mkdir -p seu-projeto/ai_files/schemas
cp waves/schemas/*.json seu-projeto/ai_files/schemas/
mkdir -p seu-projeto/ai_files/logbooks
```

### 2. Inicializar

No Claude Code:
```
/waves:project-init
```

### 3. Criar Manifesto

```
/waves:manifest-create
```

### 4. Trabalhar com Logbooks

```
/waves:logbook-create TICKET-123.json
/waves:logbook-update TICKET-123.json
```

---

## Comandos Disponíveis

| Comando | Descrição | Status |
|---------|-----------|--------|
| `/waves:project-init` | Inicializar preferências e contexto | 🟢 Pronto |
| `/waves:manifest-create` | Analisar projeto e criar manifesto | 🟢 Pronto |
| `/waves:manifest-update` | Atualizar manifesto com mudanças | 🟢 Pronto |
| `/waves:rules-create` | Extrair regras de codificação | 🟢 Pronto |
| `/waves:rules-update` | Atualizar regras por mudanças no código | 🟢 Pronto |
| `/waves:user-pref-create` | Criar preferências de usuário | 🟢 Pronto |
| `/waves:user-pref-update` | Editar preferências existentes | 🟢 Pronto |
| `/waves:logbook-create` | Criar logbook de desenvolvimento | 🟢 Pronto |
| `/waves:logbook-update` | Atualizar logbook com progresso | 🟢 Pronto |
| `/waves:resolution-create` | Gerar documento de resolução | 🟢 Pronto |
| `/waves:objectives-implement` | Implementar objetivos com auditoria | 🟢 Pronto |
| `/waves:roadmap-create` | Criar roadmap com fases e milestones | 🟢 Pronto |
| `/waves:roadmap-update` | Atualizar progresso e decisões do roadmap | 🟢 Pronto |
| `/waves:feasibility-analyze` | Análise de viabilidade com Monte Carlo e Bayesian | 🟢 Pronto |
| `/waves:foundation-create` | Compactar viabilidade em fatos validados | 🟢 Pronto |
| `/waves:blueprint-create` | Criar blueprint completo a partir do foundation | 🟢 Pronto |

---

## Schemas

| Schema | Propósito | Tipo de Projeto |
|--------|-----------|-----------------|
| `user_pref_schema.json` | Preferências de interação | Ambos |
| `software_manifest_schema.json` | Estrutura e tecnologia do projeto | Software |
| `general_manifest_schema.json` | Estrutura de projeto não-software | Geral |
| `project_rules_schema.json` | Regras e padrões de codificação | Software |
| `project_standards_schema.json` | Padrões para projetos gerais | Geral |
| `logbook_software_schema.json` | Logbook com refs de código | Software |
| `logbook_general_schema.json` | Logbook com refs de documentos | Geral |
| `ticket_resolution_schema.json` | Resumo de fechamento de ticket | Software |
| `logbook_roadmap_schema.json` | Roadmap com fases e milestones | Ambos |
| `feasibility_analysis_schema.json` | Análise de viabilidade | Ambos |
| `product_foundation_schema.json` | Ponte viabilidade → blueprint | Ambos |

---

## Como Funcionam os Schemas

Cada JSON schema usa um padrão de dupla instrução:

- `description` = O que o campo representa, para que o LLM entenda que conteúdo gerar
- `$comment` = Como o LLM deve operar nesse campo, melhorando a precisão e consistência

---

## Estrutura do Repositório

```
waves/
├── schemas/              # Fonte de verdade: 11 JSON schemas
├── subagents/            # Design canônico: 33 especificações de subagentes
├── commands/             # Documentos de design de comandos
├── .claude/commands/     # Comandos executáveis para Claude Code
├── plugin/               # Plugin Cowork (Claude desktop)
│   ├── agents/           #   17 agentes especializados
│   ├── commands/         #   13 comandos
│   ├── skills/           #   Conhecimento do protocolo + refs de schemas
│   └── hooks/            #   Hook SessionStart auto-contexto
├── example_flutter/      # Exemplo: Projeto Flutter
├── example_java/         # Exemplo: Projeto Java
├── example_web/          # Exemplo: Projeto Web
└── CHANGELOG.md          # Histórico de versões
```

---

## Compatibilidade

| Plataforma | Plugin | Slash Commands | Prompts Manuais | Notas |
|------------|--------|---------------|-----------------|-------|
| Claude Desktop (Cowork) | ✅ | ✅ | ✅ | Suporte completo via plugin |
| Claude Code | ❌ | ✅ | ✅ | Suporte completo via .claude/commands/ |
| Codex | ❌ | ❌ | ✅ | Usar prompts diretamente |
| Gemini CLI | ❌ | ❌ | ✅ | Melhor com output em .md |

---

## Licença

- Código e schemas: Apache-2.0 (veja `LICENSE`)
- Documentação: CC BY 4.0 (opcional)
