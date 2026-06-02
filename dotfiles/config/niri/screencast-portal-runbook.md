# Niri Screencast Portal Runbook

## Что ломалось

В Brave/Chromium screen sharing на Wayland падал с ошибкой вида:

```text
No such interface "org.freedesktop.portal.ScreenCast"
on object at path /org/freedesktop/portal/desktop
```

Это означает, что основной `xdg-desktop-portal` не экспортирует
`org.freedesktop.portal.ScreenCast`. Для `niri` этот интерфейс должен
появляться через `xdg-desktop-portal-gnome`, который подключается к
`org.gnome.Mutter.ScreenCast`, экспортируемому самим `niri`.

## Общая причина

Проблема была не в Brave и не в PipeWire. Ломался порядок старта
user systemd services:

- `xdg-desktop-portal` стартовал слишком рано;
- `xdg-desktop-portal-gnome` стартовал до готового `niri.service`;
- GNOME portal видел несовместимую/неполную сессию;
- в логах появлялось:

```text
Non-compatible display server, exposing settings only.
```

В этом режиме `xdg-desktop-portal-gnome` экспортирует только часть
интерфейсов и не даёт `ScreenCast`, поэтому `xdg-desktop-portal`
остаётся без screencast backend.

Раньше также встречался вариант:

```text
xdg-desktop-portal-gnome.service: Job ... failed with result 'dependency'
```

Это происходило, когда portal пытался стартовать до
`graphical-session.target`.

## Что сделано

Добавлены user systemd drop-in override-ы.

Основной portal:

```text
/home/unbot/.config/systemd/user/xdg-desktop-portal.service.d/override.conf
```

```ini
[Unit]
Wants=graphical-session.target xdg-desktop-portal-gnome.service
After=niri.service graphical-session.target xdg-desktop-portal-gnome.service
Requisite=niri.service graphical-session.target
```

GNOME portal:

```text
/home/unbot/.config/systemd/user/xdg-desktop-portal-gnome.service.d/override.conf
```

```ini
[Unit]
After=niri.service graphical-session.target
Requisite=niri.service graphical-session.target
```

Смысл фикса: оба portal-сервиса должны стартовать после `niri.service`
и после `graphical-session.target`, чтобы GNOME portal увидел
`org.gnome.Mutter.ScreenCast` от niri.

## Быстрая проверка

Проверить окружение:

```bash
env | rg '^(XDG_CURRENT_DESKTOP|XDG_SESSION_TYPE|WAYLAND_DISPLAY|DESKTOP_SESSION)='
```

Ожидаемо:

```text
XDG_CURRENT_DESKTOP=niri
XDG_SESSION_TYPE=wayland
DESKTOP_SESSION=niri
```

Проверить, что niri экспортирует Mutter ScreenCast:

```bash
gdbus introspect --session \
  --dest org.gnome.Mutter.ScreenCast \
  --object-path /org/gnome/Mutter/ScreenCast \
  | rg 'org.gnome.Mutter.ScreenCast|Version'
```

Проверить публичный portal ScreenCast:

```bash
gdbus introspect --session \
  --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  | rg 'org.freedesktop.portal.(ScreenCast|RemoteDesktop|Screenshot)'
```

Ожидаемо:

```text
interface org.freedesktop.portal.ScreenCast
```

Проверить сервисы:

```bash
systemctl --user --no-pager --plain status \
  niri.service \
  graphical-session.target \
  xdg-desktop-portal.service \
  xdg-desktop-portal-gnome.service
```

## Breadcrumbs для агента

Смотреть сюда в первую очередь:

```bash
journalctl --user \
  -u xdg-desktop-portal.service \
  -u xdg-desktop-portal-gnome.service \
  -u niri.service \
  -b --no-pager -n 200
```

Ключевые плохие признаки:

- `No such interface "org.freedesktop.portal.ScreenCast"`;
- `Non-compatible display server, exposing settings only`;
- `failed with result 'dependency'`;
- `Choosing gtk.portal ... as a last-resort fallback`;
- `xdg-desktop-portal-gnome` стартует раньше `niri.service`;
- в `org.freedesktop.portal.Desktop` нет `ScreenCast`;
- в `org.gnome.Mutter.ScreenCast` нет ответа от niri.

## Ручное восстановление

Если после обновления или ребута снова сломалось:

```bash
systemctl --user daemon-reload
systemctl --user stop xdg-desktop-portal.service xdg-desktop-portal-gnome.service
systemctl --user start xdg-desktop-portal.service
```

Потом снова проверить:

```bash
gdbus introspect --session \
  --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  | rg 'ScreenCast'
```

Если `ScreenCast` появился, нужно полностью перезапустить Brave.

## Важные замечания

- Звук при этой диагностике не трогать.
- `pipewire` и `wireplumber` нужны для screencast, но в этой проблеме
  они не были первопричиной.
- Для `niri` нужен `xdg-desktop-portal-gnome` и запуск через
  `niri --session` / `niri-session`.
- `set-dynamic-cast-monitor` в `config.kdl` не чинит сам portal. Он
  только меняет цель уже работающего dynamic cast.
