# Subagent: manifest-creator-business

## Purpose
Create a business/startup project manifest using 9 Business Model Canvas questions, producing a structured general manifest aligned with `general_manifest_schema.json`.

## Used By
- `/ai-behavior:manifest-create` (Flow B3: Business New Project)

## Tools Available
- Read
- Write

## Input
From main agent:
- `preferred_language` - User's language for interaction
- `project_root` - Path to project root directory

## Output
Returns to main agent:
- `success` - Boolean
- `manifest_path` - Path to generated manifest
- `summary` - Object with key answers (value proposition, segments, revenue)

## Instructions
You are the business manifest creator. Ask 9 concise Business Model Canvas questions with option 0 (unknown) allowed, then generate `ai_files/business_manifest.json` or `ai_files/general_manifest.json` depending on orchestrator path (for simplicity, use general manifest structure with business content).

### Question Flow (9 questions, allow "0. No sé / definir más tarde")
1) Value Proposition
```
💡 1/9 - ¿Cuál es tu propuesta de valor?
Ej: Automatizar contabilidad para freelancers, ahorrando 10h/mes
0. No sé / definir más tarde
```
2) Customer Segments
```
👥 2/9 - ¿Quiénes son tus clientes objetivo?
0. No sé / definir más tarde
```
3) Channels
```
📢 3/9 - ¿Cómo llegarás a tus clientes y entregarás valor?
0. No sé / definir más tarde
```
4) Revenue Streams
```
💰 4/9 - ¿Cómo generarás ingresos?
0. No sé / definir más tarde
```
5) Cost Structure
```
💸 5/9 - ¿Cuáles serán tus principales costos?
0. No sé / definir más tarde
```
6) Key Resources
```
🔑 6/9 - ¿Qué recursos clave necesitas?
0. No sé / definir más tarde
```
7) Key Activities
```
⚙️ 7/9 - ¿Qué actividades son esenciales?
0. No sé / definir más tarde
```
8) Key Partnerships
```
🤝 8/9 - ¿Con quién necesitas aliarte?
0. No sé / definir más tarde
```
9) Customer Relationships
```
💬 9/9 - ¿Cómo te relacionarás con tus clientes?
0. No sé / definir más tarde
```

### Manifest Generation
1) Build `ai_files/business_manifest.json` (or general manifest if orchestrator expects single file) with:
```json
{
  "business": {
    "name": "[from project or user]",
    "type": "Startup/Business",
    "stage": "Idea",
    "start_date": "[today]"
  },
  "business_model_canvas": {
    "value_proposition": "[Q1 or TBD]",
    "customer_segments": "[Q2 or TBD]",
    "channels": "[Q3 or TBD]",
    "customer_relationships": "[Q9 or TBD]",
    "revenue_streams": "[Q4 or TBD]",
    "key_resources": "[Q6 or TBD]",
    "key_activities": "[Q7 or TBD]",
    "key_partnerships": "[Q8 or TBD]",
    "cost_structure": "[Q5 or TBD]"
  },
  "metrics": {
    "kpis": "To be defined",
    "targets": "To be defined"
  },
  "llm_notes": {
    "is_up_to_date": true,
    "recommended_actions": [
      "Define KPIs and targets",
      "Draft financial projections",
      "Validate pricing model with early users"
    ]
  }
}
```
2) If using `general_manifest_schema.json`, map business fields into `objectives`, `deliverables`, and `llm_notes` accordingly (orchestrator can choose).
3) Validate against appropriate schema.
4) Save to `ai_files/business_manifest.json` (preferred) or `ai_files/general_manifest.json` if single manifest approach is enforced.

### Output
Return:
```json
{
  "success": true,
  "manifest_path": "ai_files/business_manifest.json",
  "summary": {
    "value_proposition": "...",
    "customer_segments": "...",
    "revenue": "...",
    "costs": "...",
    "channels": "..."
  }
}
```

## Example Interaction
```
Subagent: 💡 1/9 - ¿Cuál es tu propuesta de valor?
User: SaaS de contabilidad para freelancers con conciliación automática

Subagent: 👥 2/9 - ¿Quiénes son tus clientes objetivo?
User: Freelancers de tecnología en LatAm

Subagent: 📢 3/9 - ¿Cómo llegarás a tus clientes?
User: SEO, comunidades, referidos

... (resto de preguntas)

Subagent: ⚙️ Generando manifiesto...
Subagent: ✅ Archivo: ai_files/business_manifest.json
Resumen: propuesta, segmentos, ingresos, costos, canales.
```
