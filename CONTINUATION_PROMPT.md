# Prompt de Continuación: waves

**Fecha de última actualización:** 2024-12-03

---

## 1. Qué es este proyecto

**Repositorio:** `/Users/avm/Repositories/ai_files/schemas/waves`

**Archivo de referencia principal:** `README.md`

**waves** es un protocolo de contexto estructurado para agentes AI (Claude Code, Codex, Gemini CLI) que proporciona:
- **Contexto global** → manifiestos de proyecto, reglas de código, preferencias de usuario
- **Contexto enfocado** → logbooks (bitácoras) para continuidad entre sesiones de trabajo

El protocolo usa JSON schemas con un patrón específico:
- `description` = Explica QUÉ es el campo
- `$comment` = Instruye CÓMO operar en ese campo

**Referencia de aprendizaje:** `/Users/avm/agent-os` - Usamos este proyecto como inspiración para flujos interactivos.

---

## 2. Plan de desarrollo / Roadmap

**Archivo de referencia:** `IMPLEMENTATION_GUIDE.md`

### Comandos diseñados (10 total):
1. `/waves:project-init` - Configuración inicial ✅ EJECUTABLE
2. `/waves:manifest-create` - Crear manifest (8 flujos)
3. `/waves:manifest-update` - Actualizar manifest
4. `/waves:rules-create` - Crear reglas/estándares
5. `/waves:rules-update` - Actualizar reglas
6. `/waves:user-pref-create` - Preferencias completas
7. `/waves:user-pref-update` - Editar preferencias
8. `/waves:resolution-create` - Resolución de ticket (solo software)
9. `/waves:logbook-create` - Crear bitácora
10. `/waves:logbook-update` - Actualizar bitácora

### Fases de implementación de subagents:

| Fase | Descripción | Estado |
|------|-------------|--------|
| **Fase 1** | Core (4 subagents) | ✅ COMPLETA |
| **Fase 2** | Software Analysis (8 subagents) | 🔄 EN PROGRESO (2/8) |
| **Fase 3** | Rules (5 subagents) | ⏳ Pendiente |
| **Fase 4** | General Projects (6 subagents) | ⏳ Pendiente |
| **Fase 5** | Updates (6 subagents) | ⏳ Pendiente |

---

## 3. Qué hemos logrado hasta ahora

**Archivo de referencia:** `subagents/README.md` (ver tabla con columna Status ✅/⏳)

### Schemas creados (8 de 8): ✅ COMPLETO
```
schemas/
├── user_pref_schema.json           ✅
├── software_manifest_schema.json   ✅
├── general_manifest_schema.json    ✅
├── project_rules_schema.json       ✅
├── project_standards_schema.json   ✅
├── logbook_software_schema.json    ✅
├── logbook_general_schema.json     ✅
└── ticket_resolution_schema.json   ✅
```

### Diseños de comandos (10 de 10): ✅ COMPLETO
```
commands/
├── 01-project-init.md          ✅
├── 02-manifest-create.md       ✅ (8 flujos: A1, A2.1, A2.2, B1, B2, B3, B4, BE)
├── 03-manifest-update.md       ✅
├── 04-rules-create.md          ✅
├── 05-rules-update.md          ✅
├── 06-user-pref-create.md      ✅
├── 07-user-pref-update.md      ✅
├── 08-resolution-create.md     ✅
├── 09-logbook-create.md        ✅
└── 10-logbook-update.md        ✅
```

### Subagents implementados (6 de 29):
```
subagents/
├── 01-project-initializer.md              ✅ Fase 1
├── 02-manifest-creator-new-software.md    ✅ Fase 1
├── 03-manifest-creator-known-software.md  ✅ Fase 2 (incluye antipatterns + architecture health)
├── 04-manifest-creator-unknown-software.md ✅ Fase 2 (incluye antipatterns + architecture health)
├── 28-secondary-objective-generator.md    ✅ Fase 1
└── 29-context-summarizer.md               ✅ Fase 1
```

### Comando ejecutable creado:
```
.claude/commands/
└── waves:project-init.md    ✅ (con banner ASCII en degradado azul→cian)
```

### Directorio de prueba configurado:
```
/Users/avm/Repositories/ai_files/waves-test/
├── .claude/commands/waves:project-init.md
├── ai_files/schemas/*.json
└── ai_files/logbooks/
```

---

## 4. Qué estábamos haciendo y por qué quedó incompleto

### Tarea en progreso:
**Fase 2 - Software Analysis subagents**

### Lo que completamos en esta sesión:

**Subagent 03 - manifest-creator-known-software:**
- 2 checkpoint questions con opción "0. No sé" para auto-detectar
- Invoca 6 analizadores en paralelo
- Post-análisis de features con validación del usuario
- **NUEVO:** Detección de antipatrones por lenguaje
- **NUEVO:** Framework Health Check (acoplamiento, sobreingeniería, mal uso)
- Principio: "99.9% de proyectos tienen issues, SIEMPRE encontrar 1-5 críticos"

**Subagent 04 - manifest-creator-unknown-software:**
- Zero questions (el usuario no conoce el proyecto)
- Progress prints durante análisis
- Invoca 6 analizadores en paralelo
- **NUEVO:** Detección de antipatrones por lenguaje
- **NUEVO:** Framework Health Check
- Output educativo para enseñar al usuario sobre su nuevo proyecto

### Lo que quedó pendiente:

Los **6 analizadores especializados** que son invocados en paralelo:

| # | Archivo a crear | Propósito |
|---|-----------------|-----------|
| 11 | `11-entry-point-analyzer.md` | Encuentra puntos de entrada (main, index, app) |
| 12 | `12-navigation-mapper.md` | Mapea rutas y navegación (frontend) |
| 13 | `13-flow-tracker.md` | Rastrea flujos de API y eventos (backend) |
| 14 | `14-dependency-auditor.md` | Audita dependencias, versiones, seguridad |
| 15 | `15-architecture-detective.md` | Detecta capas, patrones, separación de concerns |
| 16 | `16-feature-extractor.md` | Extrae features user-facing del código |

### Por qué quedó incompleto:
Se agotó el contexto de la sesión (90%+ tokens usados).

---

## 5. Cómo retomar el trabajo

### Paso 1: Leer archivos de contexto (en orden)
```
1. README.md                                          # Entender el proyecto
2. subagents/README.md                                # Ver estado de implementación
3. subagents/03-manifest-creator-known-software.md    # Ver cómo se invocan los 6 analizadores
4. commands/02-manifest-create.md                     # Ver descripción detallada de cada analizador (buscar "Subagent")
```

### Paso 2: Crear los 6 analizadores especializados

Cada analizador debe seguir esta estructura:
```markdown
# Subagent: [nombre]

## Purpose
[1-2 oraciones de qué hace]

## Used By
- manifest-creator-known-software (Flow A2.1)
- manifest-creator-unknown-software (Flow A2.2)

## Tools Available
- Read, Glob, Grep (principalmente lectura y búsqueda)

## Input
[Qué recibe del orquestador: project_root, framework, etc.]

## Output
[Qué retorna: JSON estructurado con hallazgos]

## Instructions
[Instrucciones detalladas de QUÉ analizar y CÓMO]

## Example Output
[JSON de ejemplo del output]
```

### Paso 3: Orden de creación sugerido
1. `11-entry-point-analyzer.md` - Más simple, buen punto de partida
2. `14-dependency-auditor.md` - Lectura de package.json, requirements.txt
3. `15-architecture-detective.md` - Análisis de estructura de directorios
4. `12-navigation-mapper.md` - Específico de frontend
5. `13-flow-tracker.md` - Específico de backend
6. `16-feature-extractor.md` - Requiere cross-reference de los anteriores

### Paso 4: Actualizar estado
Después de crear cada subagent, actualizar `subagents/README.md`:
- Cambiar ⏳ a ✅ en la fila correspondiente

---

## 6. Referencia rápida de archivos

| Archivo | Para qué consultarlo |
|---------|---------------------|
| `README.md` | Overview del proyecto y qué es waves |
| `IMPLEMENTATION_GUIDE.md` | Roadmap completo, decisiones de diseño |
| `subagents/README.md` | **Estado actual de implementación** (tabla con ✅/⏳) |
| `commands/02-manifest-create.md` | **Descripción de los 6 analizadores** (buscar STEP 10A2.1) |
| `subagents/03-manifest-creator-known-software.md` | Ejemplo de cómo invocar analizadores |
| `subagents/04-manifest-creator-unknown-software.md` | Ejemplo con progress prints |
| `schemas/*.json` | Estructura de datos que generan los comandos |

---

## 7. Comando para empezar la próxima sesión

```
Lee estos archivos en orden:
1. subagents/README.md (ver qué falta)
2. subagents/03-manifest-creator-known-software.md (ver Phase 3 donde invoca los 6 analizadores)
3. commands/02-manifest-create.md (buscar "entry-point-analyzer" para ver qué debe hacer cada uno)

Luego crea el primer analizador:
subagents/11-entry-point-analyzer.md
```

---

## 8. Notas técnicas importantes

### Antipatterns Detection (ya implementado en 03 y 04)
Los orquestadores ya incluyen detección de:
- Antipatrones por lenguaje (JS/TS, Python, Java/Kotlin)
- Antipatrones genéricos (dead code, magic numbers, god classes)
- Framework health (acoplamiento, sobreingeniería, library misuse)

### Principio crítico de análisis
> "99.9% de proyectos de software tienen malas prácticas. SIEMPRE encontrar al menos 1-5 issues críticos. No asumir que el código es perfecto."

Este principio ya está documentado en los subagents 03 y 04.

### Convención de preguntas al usuario
Todas las preguntas incluyen opción `0. No sé / Lo desconozco (detectar automáticamente)` para no bloquear al usuario si no tiene la respuesta.
