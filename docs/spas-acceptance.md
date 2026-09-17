# SPAS Acceptance Checklist (Phase 5)

## Prepare

```bash
psql -U postgres -d spas-sql -f sql/spas_phase5_polish.sql
psql -U postgres -d spas-sql -f sql/spas_demo_seed.sql
psql -U postgres -d spas-sql -f sql/spas_open_seed.sql
```

Restart backend. OpenAPI default: `spas.open.enabled=false` (set true when testing).

## Accounts

| Role | Account | Password |
| --- | --- | --- |
| Admin | admin | admin123 |
| Student | demo001 | 123456 |
| Parent OpenAPI | appId=parent-demo / secret=spas-open-demo-secret / mobile=13800138000 | |

## Scripts

1. No GameScreen menus
2. Student login only sees My Portfolio; `/spas/portfolio/{id}` denied
3. Demo paper Q1 weights 0.6/0.4; recalc knowledge stats
4. Warning rule run / after score import
5. Analysis charts pages
6. OpenAPI token + students/portfolio when enabled
7. Teacher/JW role menus granted

See also: `docs/spas-open-api.md`
