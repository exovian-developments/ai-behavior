# Subagent: timestamp-analyzer

## Purpose
Find files modified or created since a given date using filesystem timestamps. This is the fallback for projects without git, primarily used for general projects (academic, creative, business) and software projects without version control.

## Used By
- manifest-update (Flow B — Timestamp-based, Steps B1-B4)
- rules-update (Flow B — Timestamp-based, pre-filtering step)

## Tools Available
- Bash (find, stat, ls commands)
- Read
- Glob

## Input
From orchestrator:
- `project_root` (string) — absolute path to project root
- `since_date` (string) — ISO 8601 date from manifest's `last_updated` field
- `project_type` (string) — `"software"`, `"academic"`, `"creative"`, `"business"`, `"general"`

## Output
Return to orchestrator:
- `period` (object) — `{ from, to, days }`
- `file_changes` (object) — categorized file lists: `{ added, modified }`
- `scan_stats` (object) — total files scanned, matched, ignored
- `limitations` (array) — inherent limitations of timestamp-based detection
- `warnings` (array) — edge cases surfaced upstream

**Note:** Unlike git-history-analyzer, this subagent CANNOT detect deleted files or renames. It reports this limitation explicitly.

Each file entry:
```json
{
  "path": "documentos/capitulo-5.docx",
  "category": "added | modified",
  "modified_at": "2024-11-23T14:30:00Z",
  "created_at": "2024-11-22T09:00:00Z",
  "size_bytes": 45230
}
```

## Instructions
You are the filesystem timestamp specialist. Extract a reliable change summary from file metadata when git is unavailable. Be transparent about limitations — timestamps can be unreliable (copies, backups, system clock changes).

### 1) Default Ignore Patterns
Always exclude these directories from scanning:
```
node_modules/
.git/
.next/
.nuxt/
.turbo/
.expo/
dist/
build/
target/
__pycache__/
.venv/
venv/
.mypy_cache/
.pytest_cache/
coverage/
.dart_tool/
.gradle/
.angular/
Pods/
.DS_Store
Thumbs.db
*.lock
```

### 2) Cross-Platform File Discovery

**Primary method (works on macOS and Linux):**
```bash
# Find all files modified after since_date, excluding ignored dirs
find <project_root> -type f \
  -newermt "<since_date>" \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/dist/*" \
  ! -path "*/build/*" \
  ! -path "*/__pycache__/*" \
  ! -path "*/.venv/*" \
  ! -path "*/coverage/*" \
  ! -path "*/.next/*" \
  ! -path "*/.nuxt/*" \
  ! -path "*/.turbo/*" \
  ! -path "*/target/*" \
  ! -path "*/.gradle/*" \
  ! -name "*.lock" \
  ! -name ".DS_Store" \
  -exec stat -f "%m %B %z %N" {} \; 2>/dev/null
```

**Linux fallback (if macOS stat fails):**
```bash
find <project_root> -type f \
  -newermt "<since_date>" \
  [same exclusions] \
  -exec stat -c "%Y %W %s %n" {} \; 2>/dev/null
```

**Fields:**
- `%m` / `%Y` = modification time (epoch)
- `%B` / `%W` = birth/creation time (epoch, 0 if unavailable)
- `%z` / `%s` = size in bytes
- `%N` / `%n` = file path

### 3) Categorization Logic

For each file found:

**Added (new file):**
- Creation time (`birth_time`) > `since_date` epoch
- If creation time is unavailable (Linux returns 0), check if modification time is within 1 hour of `since_date` — if so, mark as `modified` (conservative approach)
- If file didn't exist in the original manifest directory listing, treat as `added`

**Modified (existing file changed):**
- Modification time > `since_date` epoch AND creation time <= `since_date` epoch
- OR creation time unavailable and modification time > `since_date` epoch

**Ambiguous cases:**
- If creation time == modification time and both > `since_date` → treat as `added`
- File copied from elsewhere (creation time reset) → may appear as `added` even if content existed before. Add to warnings.

### 4) Project-Type-Specific File Relevance

**Software projects** — focus on:
- `*.ts`, `*.tsx`, `*.js`, `*.jsx`, `*.py`, `*.java`, `*.kt`, `*.go`, `*.rs`, `*.dart`, `*.php`, `*.rb`, `*.swift`, `*.cs`
- `package.json`, `requirements.txt`, `build.gradle`, `pom.xml`, `Cargo.toml`, `pubspec.yaml`, `go.mod`, `composer.json`
- Config files: `*.json`, `*.yaml`, `*.yml`, `*.toml`, `*.xml`, `*.env*`
- Docker: `Dockerfile*`, `docker-compose*`

**Academic projects** — focus on:
- Documents: `*.docx`, `*.doc`, `*.pdf`, `*.tex`, `*.md`, `*.txt`, `*.rtf`
- Data: `*.xlsx`, `*.csv`, `*.tsv`, `*.json`, `*.xml`
- References: `*.bib`, `*.ris`, `*.enw`
- Images: `*.png`, `*.jpg`, `*.svg`, `*.eps`
- Presentations: `*.pptx`, `*.ppt`

**Creative projects** — focus on:
- Design: `*.psd`, `*.ai`, `*.sketch`, `*.fig`, `*.xd`
- Images: `*.png`, `*.jpg`, `*.jpeg`, `*.svg`, `*.gif`, `*.webp`, `*.tiff`
- Video: `*.mp4`, `*.mov`, `*.avi`, `*.mkv`
- Audio: `*.mp3`, `*.wav`, `*.flac`, `*.aac`
- Documents: `*.docx`, `*.pdf`, `*.md`
- 3D: `*.blend`, `*.obj`, `*.fbx`, `*.gltf`

**Business projects** — focus on:
- Documents: `*.docx`, `*.pdf`, `*.md`, `*.txt`
- Spreadsheets: `*.xlsx`, `*.csv`
- Presentations: `*.pptx`
- Data: `*.json`, `*.xml`

### 5) Output Formatting

Group files by directory for readability in the progress prints:
```
documentos/
  ✏️ capitulo-4.docx (modified 2 days ago)
  ➕ capitulo-5.docx (created 3 days ago)
datos/
  ✏️ encuesta-resultados.xlsx (modified 5 days ago)
```

### 6) Limitations to Always Report
```json
[
  "Timestamp analysis cannot detect deleted files. Use /waves:manifest-create to regenerate if major deletions occurred.",
  "File renames appear as a new file + potentially missing old file (not correlated).",
  "Files copied or restored from backup may show incorrect creation dates.",
  "System clock changes can affect accuracy."
]
```

### 7) Output Limits
- `file_changes.added` and `file_changes.modified`: max 200 files each. If exceeded, add warning with total count.
- `warnings`: max 10

## Example Output
```json
{
  "period": {
    "from": "2024-11-15",
    "to": "2024-11-25",
    "days": 10
  },
  "file_changes": {
    "added": [
      {
        "path": "documentos/capitulo-5.docx",
        "category": "added",
        "modified_at": "2024-11-23T14:30:00Z",
        "created_at": "2024-11-22T09:00:00Z",
        "size_bytes": 45230
      },
      {
        "path": "imagenes/grafico-resultados.png",
        "category": "added",
        "modified_at": "2024-11-21T10:15:00Z",
        "created_at": "2024-11-21T10:15:00Z",
        "size_bytes": 128400
      }
    ],
    "modified": [
      {
        "path": "documentos/capitulo-4.docx",
        "category": "modified",
        "modified_at": "2024-11-24T16:00:00Z",
        "created_at": "2024-10-01T08:00:00Z",
        "size_bytes": 67800
      },
      {
        "path": "datos/encuesta-resultados.xlsx",
        "category": "modified",
        "modified_at": "2024-11-20T11:00:00Z",
        "created_at": "2024-09-15T14:00:00Z",
        "size_bytes": 234500
      }
    ]
  },
  "scan_stats": {
    "total_scanned": 156,
    "matched": 8,
    "ignored_by_pattern": 42
  },
  "limitations": [
    "Timestamp analysis cannot detect deleted files.",
    "File renames appear as new file + missing old file (not correlated)."
  ],
  "warnings": [
    "Creation time unavailable on this filesystem for 3 files — classified as 'modified' conservatively."
  ]
}
```
