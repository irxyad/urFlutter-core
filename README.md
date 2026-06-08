# urFlutter_core

A Flutter core package with clean architecture utilities, reusable widgets, and Mason brick templates for code generation.

---

## ⚠️ Known Issue (Mason only)

Fetching bricks directly from Git may cause high memory usage and stuck compilation. Until this is resolved, please clone the repo and reference bricks via local path.

---

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

## Mason Bricks

| Brick | Description |
|---|---|
| `bloc` | Generates BLoC or Cubit with freezed, injectable, and async state |
| `feature` | Generates full clean architecture feature structure with optional BLoC |

### Usage

**1. Clone**
```bash
git clone https://github.com/irxyad/urFlutter-core.git
```

**2. Add to `mason.yaml`**
```yaml
bricks:
  bloc:
    path: /path/to/urFlutter-core/packages/mason_templates/bloc
  feature:
    path: /path/to/urFlutter-core/packages/mason_templates/feature
```

**3. Run**
```bash
mason get
mason make bloc
mason make feature
```

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
