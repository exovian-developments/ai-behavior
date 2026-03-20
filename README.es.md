<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*El framework de desarrollo de productos para la era de los agentes IA*

</div>

## Por qué Waves

El desarrollo de productos como lo conocíamos cambió. Los agentes IA (Claude Code, Codex, Gemini CLI) comprimen lo que antes tomaba 6 meses de desarrollo en días o semanas. Los sprints de 2 semanas ya no reflejan el ritmo real del trabajo — el desarrollo ya no es el cuello de botella.

Waves reemplaza los sprints fijos por **olas**: ciclos orgánicos de duración variable donde cada ola lleva un incremento de producto desde la validación hasta producción. Una ola dura lo que necesita durar — a veces 3 días, a veces 3 semanas. No hay ceremonias artificiales ni timeboxes arbitrarios.

## Qué es

Waves es un protocolo estructurado que guía a los agentes IA a través del **ciclo de vida completo de un producto** — desde la primera idea hasta el código en producción. Funciona con `Claude Code`, `Codex` y `Gemini CLI` mediante comandos interactivos y schemas JSON estructurados.

En vez de darle a tu agente un prompt en blanco y esperar lo mejor, Waves lo guía por un proceso claro: primero entender si la idea es viable, luego definir qué construir, planificar en qué orden, y finalmente escribir el código — con contexto completo en cada paso.

### El Ciclo de Vida del Producto

Waves organiza el trabajo en cinco niveles, donde cada uno se construye sobre el anterior:

**1. Factibilidad** → *¿Podemos construir esto? ¿Deberíamos?*
Describes tu idea en lenguaje natural. El agente actúa como consultor de negocios: analiza el mercado, identifica competidores, construye proyecciones de ingresos con simulaciones Monte Carlo, y te da números honestos sobre si esto puede funcionar.

**2. Foundation** → *¿Qué aprendimos?*
La factibilidad puede producir miles de simulaciones en múltiples escenarios. El foundation compacta todo en un resumen ejecutivo: el problema validado, quiénes son tus usuarios, el modelo de ingresos con unit economics, análisis SWOT, capacidades esenciales, restricciones de timeline, y una señal clara de go/no-go.

**3. Blueprint** → *¿Qué estamos construyendo y por qué?*
Usando el foundation como input, defines el producto: sus capacidades, flujos de usuario, principios de diseño, reglas de producto, métricas de éxito y stack tecnológico. Cada sección conecta con el caso de negocio. Nada especulativo.

**4. Roadmap** → *¿Cuándo lo construimos y en qué orden?*
El roadmap toma las capacidades del blueprint y las organiza en fases con milestones, dependencias y puntos de decisión. Usa la convención de olas: `roadmap_w0.json` (foundation), `roadmap_w1.json`+ (olas de negocio).

**5. Logbook** → *¿Cómo implementamos esta pieza específica?*
Para cada ticket o tarea, un logbook desglosa el trabajo en objetivos principales y secundarios con guías de completado. El agente los implementa continuamente, actualiza el progreso en tiempo real, y preserva el contexto completo entre sesiones.

```
factibilidad → foundation → blueprint → roadmap → logbook
 ¿PODEMOS?    ¿QUÉ          ¿QUÉ/POR   ¿CUÁNDO?  ¿CÓMO?
              APRENDIMOS?    QUÉ?
```

Cada nivel alimenta al siguiente. Puedes empezar en cualquier nivel — si ya tienes un producto y solo necesitas logbooks para el trabajo diario, empieza ahí.

---

## Características

| Característica | Descripción |
|----------------|-------------|
| **Contexto Global** | Manifiestos de proyecto, reglas de codificación, preferencias de usuario |
| **Contexto Enfocado** | Logbooks de desarrollo por tickets/tareas con objetivos y seguimiento |
| **Multi-Agente** | Los mismos archivos funcionan con Claude Code, Codex y Gemini CLI |
| **Multi-Sesión** | Los logbooks preservan contexto entre sesiones |
| **Software + General** | Soporta proyectos de software Y académicos, creativos, de negocio |

---

## Inicio Rápido (Plugin Cowork)

### Instalar

Descarga `waves.plugin` de [Releases](https://github.com/exovian-developments/waves/releases) y doble clic para instalar en Claude desktop. O compila desde código:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

### Uso

El plugin auto-carga el contexto del proyecto al iniciar sesión. Usa los comandos:

```
/project-init          # Inicializar preferencias y contexto
/manifest-create       # Analizar proyecto y crear manifiesto
/logbook-create        # Crear logbook con objetivos
/logbook-update        # Registrar progreso en objetivos
```

Ver [`plugin/README.md`](plugin/README.md) para documentación completa.

---

## Inicio Rápido (Claude Code)

### 1. Instalar

**Opción A: Homebrew (recomendado)**

```bash
brew tap exovian-developments/waves
brew install waves

# Inicializar en tu proyecto
cd tu-proyecto
waves init claude
```

**Opción B: Manual**

```bash
git clone https://github.com/exovian-developments/waves.git
mkdir -p tu-proyecto/.claude/commands
cp -r waves/.claude/commands/* tu-proyecto/.claude/commands/
mkdir -p tu-proyecto/ai_files/schemas
cp waves/schemas/*.json tu-proyecto/ai_files/schemas/
mkdir -p tu-proyecto/ai_files/logbooks
```

### 2. Inicializar

En Claude Code:
```
/waves:project-init
```

### 3. Crear Manifiesto

```
/waves:manifest-create
```

### 4. Trabajar con Logbooks

```
/waves:logbook-create TICKET-123.json
/waves:logbook-update TICKET-123.json
```

---

## Comandos Disponibles

| Comando | Descripción | Estado |
|---------|-------------|--------|
| `/waves:project-init` | Inicializar preferencias y contexto | 🟢 Listo |
| `/waves:manifest-create` | Analizar proyecto y crear manifiesto | 🟢 Listo |
| `/waves:manifest-update` | Actualizar manifiesto con cambios | 🟢 Listo |
| `/waves:rules-create` | Extraer reglas de codificación | 🟢 Listo |
| `/waves:rules-update` | Actualizar reglas por cambios en código | 🟢 Listo |
| `/waves:user-pref-create` | Crear preferencias de usuario | 🟢 Listo |
| `/waves:user-pref-update` | Editar preferencias existentes | 🟢 Listo |
| `/waves:logbook-create` | Crear logbook de desarrollo | 🟢 Listo |
| `/waves:logbook-update` | Actualizar logbook con progreso | 🟢 Listo |
| `/waves:resolution-create` | Generar documento de resolución | 🟢 Listo |
| `/waves:objectives-implement` | Implementar objetivos con auditoría | 🟢 Listo |
| `/waves:roadmap-create` | Crear roadmap con fases y milestones | 🟢 Listo |
| `/waves:roadmap-update` | Actualizar progreso y decisiones del roadmap | 🟢 Listo |
| `/waves:feasibility-analyze` | Análisis de factibilidad con Monte Carlo y Bayesian | 🟢 Listo |
| `/waves:foundation-create` | Compactar factibilidad en hechos validados | 🟢 Listo |
| `/waves:blueprint-create` | Crear blueprint completo desde foundation | 🟢 Listo |

---

## Schemas

| Schema | Propósito | Tipo de Proyecto |
|--------|-----------|------------------|
| `user_pref_schema.json` | Preferencias de interacción | Ambos |
| `software_manifest_schema.json` | Estructura y tecnología del proyecto | Software |
| `general_manifest_schema.json` | Estructura de proyecto no-software | General |
| `project_rules_schema.json` | Reglas y patrones de codificación | Software |
| `project_standards_schema.json` | Estándares para proyectos generales | General |
| `logbook_software_schema.json` | Logbook con refs de código | Software |
| `logbook_general_schema.json` | Logbook con refs de documentos | General |
| `ticket_resolution_schema.json` | Resumen de cierre de ticket | Software |
| `logbook_roadmap_schema.json` | Roadmap con fases y milestones | Ambos |
| `feasibility_analysis_schema.json` | Análisis de factibilidad | Ambos |
| `product_foundation_schema.json` | Puente factibilidad → blueprint | Ambos |

---

## Cómo Funcionan los Schemas

Cada JSON schema usa un patrón de doble instrucción:

- `description` = Qué representa el campo, para que la LLM entienda qué contenido generar
- `$comment` = Cómo la LLM debe operar ese campo, mejorando la precisión y consistencia

---

## Estructura del Repositorio

```
waves/
├── schemas/              # Fuente de verdad: 11 JSON schemas
├── subagents/            # Diseño canónico: 33 especificaciones de subagentes
├── commands/             # Documentos de diseño de comandos
├── .claude/commands/     # Comandos ejecutables para Claude Code
├── plugin/               # Plugin Cowork (Claude desktop)
│   ├── agents/           #   17 agentes especializados
│   ├── commands/         #   13 comandos
│   ├── skills/           #   Conocimiento del protocolo + refs de schemas
│   └── hooks/            #   Hook SessionStart auto-contexto
├── example_flutter/      # Ejemplo: Proyecto Flutter
├── example_java/         # Ejemplo: Proyecto Java
├── example_web/          # Ejemplo: Proyecto Web
└── CHANGELOG.md          # Historial de versiones
```

---

## Compatibilidad

| Plataforma | Plugin | Slash Commands | Prompts Manuales | Notas |
|------------|--------|---------------|------------------|-------|
| Claude Desktop (Cowork) | ✅ | ✅ | ✅ | Soporte completo via plugin |
| Claude Code | ❌ | ✅ | ✅ | Soporte completo via .claude/commands/ |
| Codex | ❌ | ❌ | ✅ | Usar prompts directamente |
| Gemini CLI | ❌ | ❌ | ✅ | Mejor con output en .md |

---

## Licencia

- Código y schemas: Apache-2.0 (ver `LICENSE`)
- Documentación: CC BY 4.0 (opcional)
