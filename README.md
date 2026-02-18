# cartfest

App Flutter de competencia tuning y red social automotriz.

## Ejecutar local

```bash
flutter pub get
flutter run
```

## Web en GitHub Pages

El proyecto incluye workflow automatico para desplegar Flutter Web en Pages:

- Archivo: `.github/workflows/deploy_web.yml`
- Se ejecuta en cada push a `main`

URL esperada (cuando el workflow termine):

`https://davidzara66.github.io/cartfest/`

Para activarlo en GitHub:

1. Ir a `Settings > Pages` del repo.
2. En `Build and deployment`, seleccionar `GitHub Actions`.
3. Hacer push a `main`.
4. Esperar que termine el workflow `Deploy Flutter Web`.

Con esa URL puedes probar en iPhone (Safari) y otros dispositivos.

## Supabase (SQL listo)

Se incluyo el schema completo en:

- `supabase/schema.sql`

Tablas incluidas:

- `profiles`
- `follows`
- `direct_messages`
- `event_chat`
- `event_registrations`
- `feed_posts`
- `story_items`

Incluye:

- RLS habilitado.
- Politicas para lectura/escritura segun usuario autenticado.
- Validaciones de `classification` (8 niveles) y `origin`.

### Pasos

1. Abrir Supabase > SQL Editor.
2. Ejecutar `supabase/schema.sql`.
3. En Auth > Providers > Email:
   - activar Auto Confirm
   - desactivar confirmacion de email
