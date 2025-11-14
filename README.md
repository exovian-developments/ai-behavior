# ai-behavior

Especificación mínima para operar con IA en proyectos reales: conservar contexto (bitácora), capturar reglas existentes, describir el stack y producir entregables consistentes. Patrón: cada campo usa `description` (qué es) y `$comment` (cómo operar). Versión: JSON Schema 2020-12.

## Instalación (copy/paste)
- Crea en el root del proyecto:
  - `.ai_files/schemas/`
  - `.ai_files/profiles/` (opcional)
- Copia los schemas a `.ai_files/schemas/`:
  - `logbook_schema.json`
  - `project_manifest_schema.json`
  - `project_rules_schema.json`
  - `ticket_resolution_schema.json`
  - `user_pref.json` (opcional, si usas perfiles)
- Opcional: copia tu YAML de preferencias a `.ai_files/profiles/user_interaction_pref.yaml` con:
  - `$schema: "https://exovian.dev/schemas/user_pref.schema.json"`

## Cuándo usarlo
- Proyectos iniciados (OnGoing-Projects): extrae manifiesto y reglas desde el código; luego usa la bitácora y el esquema de resolución de tickets.
- Proyectos nuevos (Greenfield): define manifiesto y reglas base; evoluciona conforme el código crece.

## Flujo — Proyectos Iniciados

1) Project Manifest
- Archivo: `project_manifest.json`
- Esquema: `.ai_files/schemas/project_manifest_schema.json`
- Prompt:
```
Inspecciona el repo y produce project_manifest.json validando contra
.ai_files/schemas/project_manifest_schema.json. Usa solo hechos observables
(lenguaje, framework, build, arquitectura, features). Mantén descripciones
conscisas. Devuelve solo JSON válido.
```

2) Project Rules (por capas + pruebas)
- Archivo: `project_rules.json`
- Esquema: `.ai_files/schemas/project_rules_schema.json`
- Recomendación: prompts separados por cada `layer` de `manifest.technical_details.architecture_identified` y otro para pruebas (unit/integration/e2e).
- Reglas del schema: `id` entero incremental (>=1), `created_at` (UTC) requerido, `updated_at` opcional, `description` ≤ 280 chars.
- Prompt (por capa):
```
Analiza la capa <layer> según el manifiesto y el código. Extrae reglas de
arquitectura, naming, acoplamientos y límites. Actualiza project_rules.json
siguiendo .ai_files/schemas/project_rules_schema.json. Agrega reglas con
id=max(id)+1, created_at=UTC actual; updated_at solo si editas. Evita
duplicados y valida.
Devuelve JSON válido.
```
- Prompt (testing):
```
Analiza los tests (unit/integration/e2e) y extrae patrones de naming,
organización, herramientas y aserciones. Agrega reglas en la sección
"testing" respetando .ai_files/schemas/project_rules_schema.json.
Valida y devuelve JSON válido.
```

3) Conectar al agente
- En `AGENTS.md`/`CLAUDE.md`/`GEMINI.md` del proyecto:
  - Indica: “Usa `.ai_files/schemas/` y respeta `$comment` (prepend, truncado, inmutabilidad, etc.).”
  - Referencia explícita a `project_manifest.json` y `project_rules.json` como contexto.
  - Si no son enormes, puedes pegarlos minificados (ej. toon) directamente en el `.md` del agente.

4) Mantenimiento
- Repite Manifest + Rules cuando el proyecto crezca para mantener el contexto actualizado.

## Flujo — Proyectos Nuevos
1) Manifiesto inicial
- Crea `project_manifest.json` con el stack previsto. Usa `llm_notes` para supuestos y confirma después.

2) Reglas base
- Crea `project_rules.json` con SOPs mínimos (naming, testing, arquitectura prevista). Usa `id` incremental y `created_at` requerido.

3) Evolución
- A medida que hay código, re-ejecuta Manifest y enriquece Rules desde el repo (como en OnGoing).

## Flujo — Bitácora (tickets/historias)
- Archivo sugerido: `.ai_files/logs/logbook.json`
- Esquema: `.ai_files/schemas/logbook_schema.json`

1) Iniciar sesión de trabajo
- Prompt:
```
Crea/actualiza .ai_files/logs/logbook.json siguiendo .ai_files/schemas/logbook_schema.json.
Completa ticket.title, ticket.url y ticket.description con contenido del ticket.
(Si hay MCP/Jira, puedes leer el ticket directamente.) No modifiques entradas previas.
```

2) Rastrear y planificar
- Prompt:
```
Según el ticket, rastrea archivos/clases/constantes/tests relevantes en el repo.
Usa el manifiesto para guiar por capas. Genera una lista de acciones ordenada
para cumplir el objetivo. Preséntala para revisión humana.
```

3) Confirmar plan (revisión humana)
- El usuario ajusta y aprueba; solicita versión “confirmada”.

4) Crear/actualizar bitácora
- Prompt:
```
Inicializa/actualiza .ai_files/logs/logbook.json. Registra el plan aprobado en
recent_context (prepend en índice 0); respeta maxItems y las reglas de resumen.
```

5) Iterar durante el desarrollo
- En cada checkpoint:
  - Prepend a `recent_context` con avances/hallazgos.
  - Si excede `maxItems`, resume la más antigua (≤140) y muévela a `history_summary` con `id` incremental y `created_at`.
  - Verifica objetivos cumplidos; mueve a `objectives_past` con `status`.
- Prompt (iterativo):
```
Actualiza .ai_files/logs/logbook.json: agrega entrada en recent_context (índice 0).
Si excede maxItems, resume la última (≤140) y muévela a history_summary (nuevo id y created_at).
Actualiza objetivos según corresponda. Devuelve JSON válido.
```

6) Cierre de ticket
- Archivo: `ticket_resolution.json`
- Esquema: `.ai_files/schemas/ticket_resolution_schema.json`
- Prompt:
```
Genera ticket_resolution.json cumpliendo .ai_files/schemas/ticket_resolution_schema.json
con narrativa problema → causas → fixes → detalles técnicos → validación → resultado.
Mantén límites de longitud. Llena files_modified con rutas relativas y resúmenes.
Devuelve JSON válido y luego el documento Markdown final listo para pegar.
```

## Validación rápida
- Node (AJV): `npx ajv validate -s .ai_files/schemas/<schema>.json -d <data>.json`
- Python: `python -c "import json,sys,jsonschema as j; j.validate(json.load(open(sys.argv[2])), json.load(open(sys.argv[1])))" .ai_files/schemas/<schema>.json <data>.json`

## Convenciones
- IDs: `integer` con `minimum: 1`, estables una vez creados.
- Tiempos: `created_at` (UTC ISO 8601) inmutable; `updated_at` (UTC) solo cuando cambie el contenido.
- Respeta `$comment`: prepend, límites, resúmenes, inmutabilidad.

## Licencia
- Código y schemas: Apache-2.0 (ver `LICENSE`).
- Documentación: puedes optar por CC BY 4.0 si separas la licencia de docs.
