# T-015 · Add Dependabot configuration
- Estado: Bloqueada (por T-014) · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `ci/T-015-add-dependabot` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-014 (CI en verde en `main`) · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca CI)

## Por qué
No hay actualizaciones automáticas de dependencias (40 vulnerabilidades en npm al 2026-10-10). Dependabot solo sirve con CI en verde que valide cada PR.

## Objetivo
Dependabot abre PRs semanales agrupados para Maven, npm y GitHub Actions, con títulos que pasan el check de Conventional Commits.

## Alcance
- Incluye: crear `.github/dependabot.yml` **exactamente** con el contenido de abajo; agregar en `CONTRIBUTING.md` §8 la línea "Activo desde T-015".
- **No incluye:** mergear PRs de Dependabot; cambiar versiones a mano.

```yaml
version: 2
updates:
  - package-ecosystem: maven
    directory: /backend/coworkProject
    schedule: { interval: weekly, day: monday }
    commit-message: { prefix: "build(deps)" }
    groups:
      maven-minor-patch: { update-types: [minor, patch] }
    open-pull-requests-limit: 5
  - package-ecosystem: npm
    directory: /frontend
    schedule: { interval: weekly, day: monday }
    commit-message: { prefix: "build(deps)" }
    groups:
      npm-minor-patch: { update-types: [minor, patch] }
    open-pull-requests-limit: 5
  - package-ecosystem: github-actions
    directory: /
    schedule: { interval: weekly, day: monday }
    commit-message: { prefix: "ci(deps)" }
```

## Leer antes
- `CONTRIBUTING.md` §8 · `.github/workflows/pr-title.yml` (tipos permitidos: `build` y `ci` están)

## Archivos previstos
- crear: `.github/dependabot.yml` · modificar: `CONTRIBUTING.md`

## Tests
- No aplica (configuración). Validación de sintaxis por GitHub (criterios).

## Criterios de aceptación
- [ ] `python3 -c "import yaml,sys; yaml.safe_load(open('.github/dependabot.yml'))"` no da error.
- [ ] Después del merge (👤): GitHub → Insights → Dependency graph → Dependabot muestra los 3 ecosistemas sin errores.
- [ ] `./scripts/verify.sh` pasa (no cambió nada del código).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Pendientes → nuevas tareas: …
