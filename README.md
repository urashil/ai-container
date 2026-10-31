# ai-container

`container` starts an Alpine box for AI coding agents (Claude Code, Gemini CLI) in the current folder, on Arch Linux.

- The current folder is mounted at the same path; you are the same uid inside, so files keep your ownership.
- Password-less `sudo` inside the box. Container root (and every uid but yours) is mapped to your unprivileged `/etc/subuid`
  range, so root in the box has no rights on the host.
- One shared, persistent 16 GB root for every box (an ext4 image at `/var/lib/aibox/root.img`): installed packages and the
  sign-ins in its home (`~/.claude`, `~/.claude.json`, `~/.gemini`) survive.
- No unprivileged user namespaces needed (kept off on linux-hardened): podman runs as root through a small fixed helper,
  `aibox-run`, which sudo allows without a password. It builds every podman command itself and only takes your uid and folder.
- Network through pasta in a namespace of its own: no host firewall rules, no access to services on the host's loopback.

## Install

```
git clone https://github.com/urashil/ai-container && cd ai-container && ./install.sh
```

`install.sh` links `container` into `~/.local/bin` and runs `container setup` (podman, the helper and its sudoers rule,
a uid range, the 16 GB image and its mount unit). Run `container setup` again after pulling changes to `aibox-run`.

## Use

```
container                      a shell in the box
container claude [args]        any command
container sync [--host]        copy the Claude Code sign-in into the box (--host: back out)
container git on|off           give boxes your git identity + GitHub push (gh token as git credential)
container gh on|off            give boxes the gh CLI sign-in (GH_TOKEN)
container clipboard on|off     share images you copy with running boxes, so Ctrl+V works in Claude Code (default on)
container --git --no-gh ...    for one run only (also --clipboard / --no-clipboard)
container status | df          switches | space used in the shared root
container reset [--all]        rebuild the shared root from fresh Alpine (keeps /home unless --all)
```

Credentials handed over with `git` / `gh` live in a private tmpfs folder mounted read-only into that box only, and are removed
when it ends. Your `~/.ssh` is never mounted.
The clipboard share never exposes text or the Wayland socket: only the current clipboard image, as a read-only file, and only
while a box is open. The box refuses to start in `/`, `/home` or your home folder itself.
