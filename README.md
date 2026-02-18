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
