# urFlutter_core

> ⚠️ **Known Issue:** Fetching these bricks directly from Git may cause high memory usage and stuck compilation. Until this is resolved, please clone the repo and reference bricks via local path.

## Features

| Module | Description |
|---|---|
| `core/api` | Base API client, Dio setup, interceptors, error handlers |
| `core/errors` | Failure models and error handling |
| `core/extensions` | Extensions for `DateTime`, `BuildContext`, `Color`, animations |
| `core/logging` | App-wide logger utility |
| `core/typedef` | Common type aliases |
| `core/utils` | `AppDimension`, `ColorUtils`, `DirectoryUtils` |
| `widgets/loading` | Loading overlay via `AppLoading` |
| `widgets/notification` | Toast/notification via `AppNotify` |

---

## Installation

```yaml
dependencies:
  urflutter_core:
    git:
      url: https://github.com/irxyad/urFlutter-core.git
      ref: main
```

---

## License

MIT
