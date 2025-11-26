<div align="center">

# ai-behavior

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

</div>

## ¿Qué es?
Es un protocolo de trabajo para agentes (`Claude Code`, `Codex`, `Gemini CLI`) compatible con todo tipo de proyectos de software basado en un grupo de archivos `.json` (json_schema) que ofrecen guía para la operación y generación de contextos para trabajar con precisión en proyectos reales.

**Patrón:** Cada `json_schema` que contiene lo siguiente por cada objeto de la estructura:
- `description` = Descripción del campo / propiedad, así la LLM tiene claro el contenido que debe generar.
- `$comment` = Cómo la LLM debe operar ese campo, sin inferencias y mejorando la precisión del resultado.

## Resultados comprobados
Estos schemas se han usado y depurado con `Claude Code`, `Codex` y `Gemini CLI`* y son capaces de:  

**1. Generar y trabajar el contexto global del proyecto**
- Generar un manifiesto estructurado del proyecto (lenguaje, framework, arquitectura, patrones por capas, features, etc).
- Generar reglas de codificación (Patrones y estándares) y seguirlas.
- Seguir el estilo de trabajo del usuario a cargo.

**2. Generar y trabajar el contexto enfocado en tareas / tickets / historias** 
- Generación de contexto "enfocado" por tickets de desarrollo que puede ser extendido entre varias LLMs y varias sesiones (bitácora). 
- Producir código siguiendo las reglas del proyecto (generadas previamente)
- Crear un comentario resolutivo estructurado por ticket basado en la bitácora del ticket.

**Nota: Gemini CLI** En muchos intentos se comprobó que `Gemini CLI` funciona mejor produciendo resultados en formato `.md` porque en `.json` suele presentar problemas con las anclas para agregar y modificar elementos del `.json`.

## 🛠️ Instalación

### Opción 1: Homebrew (Recomendado para macOS/Linux)
```bash
brew tap exovian-developments/tap
brew install ai-behavior

# Desde la raíz de tu proyecto
ai-behavior
```

### Opción 2: Script de Instalación
```bash
# Descarga el script primero (SIEMPRE inspecciona scripts antes de ejecutarlos)
curl -O https://raw.githubusercontent.com/exovian-developments/ai-behavior/main/install.sh

# Inspecciona el contenido
cat install.sh

# Si te parece seguro, ejecútalo desde la raíz de tu proyecto
bash install.sh
```

⚠️ **Nota de Seguridad:** Nunca ejecutes scripts de internet sin revisarlos primero.

### Opción 3: Instalación Manual

**1.** Checkout del repositorio `ai-behavior`.
```bash
git clone https://github.com/exovian-developments/ai-behavior.git
```

**2.** En la raíz de tu proyecto crea el directorio `ai_files` y los siguientes subdirectorios:
```bash
mkdir -p ai_files/{schemas,logbooks}
```

**3.** Copia los schemas ubicados en `ai-behavior/schemas/` al directorio `ai_files/schemas/` de tu proyecto:
```bash
cp ai-behavior/schemas/*.json ai_files/schemas/
```

Schemas incluidos:
  - `logbook_schema.json`
  - `project_manifest_schema.json`
  - `project_rules_schema.json`
  - `ticket_resolution_schema.json`
  - `user_pref_schema.json`

**4.** Agrega la siguiente sección al inicio del archivo de tu agente `CLAUDE.md`, `AGENT.md`, `GEMINI.md`.
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

    - path: "ai_files/schemas/project_manifest_schema.json"
      description: "Json file with structure and guidance about how to create or update a project manifest"
      when: "when_user_ask"

    - path: "ai_files/schemas/project_rules_schema.json"
      description: "Json file with structure and guidance about how to create coding rules, standards and criterias"
      when: "when_user_ask"

    - path: "ai_files/schemas/logbook_schema.json"
      description: "Json file with structure and guidance about how to create a logbook to track and maintain conversational context for long-term memory and task tracking."
      when: "when_user_ask"

    - path: "ai_files/schemas/ticket_resolution_schema.json"
      description: "Json file with structure and guidance about how to create a summary of the resolution of the work done"
      when: "when_user_ask"

    - path: "ai_files/schemas/user_pref_schema.json"
      description: "Json file with structure and guidance about how to create a profile with guidance about how the interaction between the agent and the user"
      when: "when_user_ask"

```

**5.** _(Opcional)_ Agrega a tu `.gitignore` el directorio `ai_files/logbooks/` para no commitear las bitácoras de trabajo:
```bash
echo "ai_files/logbooks/" >> .gitignore
```

## 🧭 Cuándo Usarlo
- Proyectos iniciados (OnGoing-Projects): Inicia por crear el manifiesto y reglas desde el código; luego usa la bitácora y el esquema de resolución de tickets para el trabajo diario con tickets de desarrollo.
  
- Proyectos nuevos (Greenfield): Usa los schemas para generar un manifiesto y las reglas base de tu proyecto; evoluciona conforme el código crece.

> [!IMPORTANT] Sobre los Prompts:
> Los prompts incluidos son guías probadas que puedes copiar y usar directamente. También puedes crear tus propios prompts manteniendo o mejorando la idea según tu contexto.

## 🌎 Cómo Crear el Contexto Global

**1.** Crea tus preferencias de interacción:
- Archivo resultante: `user_pref.json`
- Esquema: `ai_files/schemas/user_pref_schema.json`
- Prompt _(Copia y pega en la conversación con tu agente)_:
```
Analiza todo el archivo user_pref_schema.json y basado en la estructura y descripción de cada propiedad y objeto del archivo, hazme las preguntas para generar el archivo ai_files/user_pref.json, una vez terminadas las preguntas, genera el archivo cumpliendo el objetivo semántico de cada propiedad indicada en el schema. Se el moderador de la conversación, se conciso en las preguntas, no modifiques el objeto final y si vez que me desvío de alguna pregunta, se proactivo y retoma el hilo de la conversación para generar el archivo. 
```

**2.** Crea el Project Manifest (Actualiza de vez en cuando)
- Archivo resultante: `project_manifest.json`
- Esquema: `ai_files/schemas/project_manifest_schema.json`
- Prompt _(Copia y pega en la conversación con tu agente)_:
```
Analiza todo el archivo project_manifest_schema.json, luego basado en la estructura y descripción de cada propiedad y objeto del archivo, analiza el proyecto actual e identifica estrictamente lo que se pide en el archivo; para hacer el análisis, ve a cada directorio y archivo del proyecto; no ignores rutas ni archivos porque pueden ser relevantes para descubrir patrones, arquitectura o features del proyecto. Al final genera el archivo ai_files/project_manifest.json cumpliendo el objetivo semántico de cada propiedad indicada en el schema.
```

**3.** Crea el Project Rules: Ya sea que sea un proyecto iniciado o uno nuevo, se recomienda crear las reglas por capas, de manera que se puedan crear o identificar reglas según las buenas prácticas específicas de la capa y que se puedan abordar con atención las particularidades. Se recomienda tener apoyo o experiencia para evitar sobreingeniería en este proceso. 
- Archivo resultante: `project_rules.json`
- Esquema: `ai_files/schemas/project_rules_schema.json`
- Recomendación: Envía un prompt separado por cada `layer` de `project_manifest.technical_details.architecture_identified`.
- Riesgos: Se detectó sobreingeniería, pero si se refuerza el principio YAGNI en el prompt hace una buena mejora.
- Prompt _(indicar capa a analizar según lo detectado en el `project_manifest`)_:
```
Analiza todo el archivo project_rules_schema.json, luego analiza la capa <layer> y todo lo relacionado según el ai_files/project_manifest.json y luego ve al código del proyecto y busca las clases, objetos, funciones y métodos relacionasdo, rastrea todo lo relacionado y según el contenido encontrado identifica patrones, genera reglas de arquitectura que se hayan aplicado, extrae y genera convenciones de nombramiento, convenciones de estructura de clases, incluso considera patrones que no sean una buena práctica pero que se hayan implementado a lo largo del contenido analizado. Siempre sigue los criterios indicado en el project_rules_schema.json cuando crees una regla y siempre aplica el principio YAGNI. Finalmente actualiza el archivo ai_files/project_rules.json siguiendo las instrucciones del ai_files/schemas/project_rules_schema.json, si el archivo project_rules.json aún no existe, entonces créalo basado en la estructura indicada en el project_rules_schema.json y en el contenido analizado. 
```

## 🎯 Contexto Enfocado - ¡El verdadero poder!
**La Bitácora**

La bitácora del ticket / historia es el archivo `.json` que contiene el contexto enfocado en objetivo primarios, secundarios y registros de hallazgos/avances/problemas encontrados a medida que se trabaja, el resultado es un archivo universal y útil para cualquier agente, reutilizable por cualquier LLM, incluso puedes empezar con un agente (por ejemplo `claude code`) y pasarte a `codex` si no logra resolver correctamente un problema. 

Puedes tener abiertas dos sesiones con agentes diferentes que siempre que no estén modificando archivos al mismo turno / tiempo, se puede trabajar en simultáneo, lo importante es que cada agente agregue sus registros al arreglo del contexto reciente de la bitácora.
- Archivo resultante: `ai_files/logbooks/{logbookName}.json`
- Esquema: `ai_files/schemas/logbook_schema.json`

**1.** Iniciar sesión de trabajo con tu agente: `claude`, `codex` o `gemini`.

**2.** Provee un prompt con detalles del ticket / historia a desarrollar. _(Copiar / Pegar el contenido o conectar MCP tool y pegarle la URL del ticket al agente)_.
- __Prompt de ejemplo__:
```
(Este es un prompt de ejemplo) Estaremos trabajando en crear un nuevo endpoint para que las aplicaciones frontend (web y mobile) puedan obtener los detalles de un producto, este es el schema que debemos cumplir: ...[contenido técnico del API] ... y estos son los criterios de aceptación del ticket: ...[Criterios de aceptación]..., tienes alguna pregunta?
``` 

**3.** Rastrear código relacionado y planificar el trabajo:
- Prompt _(Copia y pega en la conversación con tu agente)_:
```
Según el ticket que te he compartido, ve al código y rastrea archivos/clases/funciones/métodos/constantes/tests relecionadas con el ticket. Usa el ai_files/project_manifest como guía inicial a alto nivel. Luego genera una lista de acciones para cumplir el objetivo, ordénala en orden de resolución de dependencias primero. Preséntala para revisión, ajuste y confirmación humana.
```

**4.** Confirmar plan _(revisión humana)_:
- El usuario ajusta la lista, removiendo o agregando detalles para una ejecución limpia y preparada para las modificaciones en cuestión. 
- El usuario solicita ver la versión “confirmada” de la lista de acciones. Confirma que los pasos tengan un orden lógico.

**5.** Crear bitácora _(Se debe indicar el nombre del archivo a ser creado)_
- Prompt _(Ajusta este prompt, copia y pega en la conversación con tu agente)_:
```
Analiza todo el archivo ai_files/schemas/logbook_schema.json, luego basado en la lista de acciones que fue revisada y aprobada, crea la bitácora ai_files/logbooks/{nombreArchivo}.json cumpliendo el objetivo semántico de cada propiedad del schema. De ahora en adelante serás el moderador que mantiene los objetivos de la bitácora actualizados, por lo tanto, si detectas que aparece un nuevo objetivo (primario o secundario) agrégalo o sise cumple alguno, muévelo a su respectiva estructura.
```

**6.** Cada cierto tiempo o avance _(Cómo si guardaras el avance en un videojuego)_:
- Prompt (iterativo):
```
Basado en el avance, hallazgos y problemas que hemos tenido, actualiza la bitácora según las reglas del schema y crea comentarios concisos en el contexto reciente, actualiza los objetivos y ponla al día.
```

## Al terminar un ticket / historia de desarrollo (Opcional)

**Comentario de Resolución Técnico**

Se ha convertido en una buena práctica dejar un resumen nutrido del trabajo realizado para cerrar cada ticket, para ello:

**1.** Creación del comentario resolutivo del ticket:
- Archivo: No aplica - Se entrega un comentario en pantalla.
- Esquema: `ai_files/schemas/ticket_resolution_schema.json`
- Prompt _(Se debe indicar el nombre de la bitácora a analizar)_:
```
Analiza el archivo ai_files/schemas/ticket_resolution_schema.json y basado en la bitácora ai_files/logbooks/{nombreBitacora}.json crea un comentario resolutivo en formato Markdown para copiar y pegar en la plataforma donde gestionamos los tickets de desarollo.
```



## ✅ Validación rápida
- Node (AJV): `npx ajv validate -s .ai_files/schemas/<schema>.json -d <data>.json`
- Python: `python -c "import json,sys,jsonschema as j; j.validate(json.load(open(sys.argv[2])), json.load(open(sys.argv[1])))" .ai_files/schemas/<schema>.json <data>.json`

## 🧩 Convenciones
- IDs: `integer` con `minimum: 1`, estables una vez creados.
- Tiempos: `created_at` (UTC ISO 8601) inmutable; `updated_at` (UTC) solo cuando cambie el contenido.
- Respeta `$comment`: prepend, límites, resúmenes, inmutabilidad.

## 📜 Licencia
- Código y schemas: Apache-2.0 (ver `LICENSE`).
- Documentación: puedes optar por CC BY 4.0 si separas la licencia de docs.
