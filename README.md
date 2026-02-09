![logo](.github/raylib-wave_256x256.png)

# raylib-wave

Wave bindings for raylib 5.5.0.
This library allows you to develop games using raylib with the Wave programming language.

## Requirements

- Wave: v0.1.7-pre-beta or later (or latest master)
- raylib: 5.5.0
- Operating System: Linux (Fedora 43 recommended)

---

## Getting Started

### 1. Clone the repository

You can either clone the repository or copy the `raylib.wave` file directly into your project.

```bash
git clone https://github.com/wavefnd/raylib-wave.git
```

### 2. Install raylib

Install raylib 5.5.0 on your system.
On Fedora:
```bash
sudo dnf install raylib-devel
```

> Make sure `libraylib.so` is available in your system library path.

### 3. Import raylib in Wave

Import `raylib.wave` in your Wave source file:

```wave
import("raylib");
```

You can now use raylib APIs directly from Wave.

---

## License

This project follows the same license as the Zlib.
See the repository for more details.