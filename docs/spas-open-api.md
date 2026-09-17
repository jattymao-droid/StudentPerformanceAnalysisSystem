# SPAS Parent OpenAPI

Base path: `/open/v1/**`  
Auth is isolated from system JWT. Enable via `spas.open.enabled=true`.

## Config

```yaml
spas:
  open:
    enabled: false          # master switch
    token-ttl-minutes: 120
```

## Demo seed

Run `sql/spas_open_seed.sql`:

| Field | Value |
| --- | --- |
| appId | `parent-demo` |
| appSecret | `spas-open-demo-secret` |
| mobile | `13800138000` |

Parent is auto-bound to the first active student when available.

## Auth

### POST `/open/v1/oauth/token`

Request:

```json
{
  "appId": "parent-demo",
  "appSecret": "spas-open-demo-secret",
  "mobile": "13800138000"
}
```

Response `data`:

```json
{
  "accessToken": "...",
  "tokenType": "Bearer",
  "expiresIn": 7200,
  "parentId": 1,
  "parentName": "Demo Parent",
  "mobile": "13800138000"
}
```

Use header on subsequent calls:

```http
Authorization: Bearer <accessToken>
```

## Resources

All require Bearer token. Access is limited to students bound to the parent.

| Method | Path | Description |
| --- | --- | --- |
| GET | `/open/v1/students` | Bound children |
| GET | `/open/v1/students/{studentId}/portfolio?subjectId=` | Portfolio (no coach logs) |
| GET | `/open/v1/students/{studentId}/warnings` | Open warnings |
| GET | `/open/v1/students/{studentId}/radar?subjectId=` | Knowledge radar |
| GET | `/open/v1/students/{studentId}/trend?subjectId=` | Score trend |
| GET | `/open/v1/students/{studentId}/weak-top?subjectId=&limit=10` | Weak knowledge top |

## Error cases

| Case | HTTP / code | Message |
| --- | --- | --- |
| `enabled=false` | 503 | Open API is disabled |
| Missing/invalid token | 401 | Missing / Invalid or expired token |
| Unbound student | 500 | Student is not bound to current parent |
| Bad client/mobile | 500 | Invalid appId / Parent not found |

## curl examples

```bash
# 1) token
curl -s -X POST http://localhost:8080/open/v1/oauth/token \
  -H "Content-Type: application/json" \
  -d "{\"appId\":\"parent-demo\",\"appSecret\":\"spas-open-demo-secret\",\"mobile\":\"13800138000\"}"

# 2) students
curl -s http://localhost:8080/open/v1/students \
  -H "Authorization: Bearer <accessToken>"

# 3) portfolio
curl -s "http://localhost:8080/open/v1/students/1/portfolio" \
  -H "Authorization: Bearer <accessToken>"
```

## Postman

Import `docs/spas-open-api.postman_collection.json`.
