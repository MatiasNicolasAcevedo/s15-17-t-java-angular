# T-011 · Rotate the JWT secret in production and check the deploy
- Estado: Bloqueada (por T-001) · Prioridad: P0 · Esfuerzo: S · Ejecuta: 👤 dueño
- Fase: P0 Estabilizar
- Rama: — (configuración del proveedor) · Depende de: T-001 mergeada · Spec/ADR: —
- Revisa: — (no bloquea la cola)

## Por qué
El secreto JWT anterior está en el historial público de git (`JwtService.java:22` hasta T-001): borrarlo del código no alcanza. Además no se pudo verificar si el deploy de Render (back) y Netlify/Vercel (front) sigue vivo (el proxy de la sesión de auditoría lo bloqueó).

## Pasos
1. Generá un secreto nuevo (no lo pegues en ningún archivo del repo ni en chats):
   ```bash
   openssl rand -base64 32
   ```
2. Render → servicio del back → **Environment** → agregá `JWT_SECRET` con ese valor. Revisá que estén `DB_*`, `CLOUDINARY_*` y (desde T-009) `APP_WAKEUP_ENABLED=true`. **Save, rebuild and deploy.**
3. Chequeá: `curl https://woodwork.onrender.com/v1/api/render/health` → `Server is awake and running!` (el primer request puede tardar ~1 min si estaba dormido).
4. Iniciá sesión en el front desplegado (los tokens viejos dejan de valer: es esperado).
5. Si el deploy ya no existe o no lo querés mantener: anotalo en "Decisiones pendientes" de `docs/STATUS.md` (sirve para la tarea de demo online de P3).
6. Recomendado: rotá también la API key de Cloudinary si alguna vez se compartió por chat/Discord del equipo.

## Criterios de aceptación
- [ ] Health de producción responde (o está documentado que el deploy no existe).
- [ ] Login en producción funciona con un usuario nuevo.
- [ ] `JWT_SECRET` definido en Render y en ningún archivo del repo.

## Resultado
- Fecha: … · Estado del deploy: … · Notas: …
