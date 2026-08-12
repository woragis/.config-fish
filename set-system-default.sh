#!/usr/bin/env bash
# Set fish as the login shell for existing users and as the default for new ones.
# Usage: sudo bash ~/.config/fish/set-system-default.sh

set -euo pipefail

FISH=/usr/bin/fish

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

if [[ ! -x $FISH ]]; then
  echo "fish not found at $FISH" >&2
  exit 1
fi

if ! grep -qxF "$FISH" /etc/shells && ! grep -qxF /bin/fish /etc/shells; then
  echo "$FISH" >> /etc/shells
fi

# Existing accounts
for user in root woragis browser; do
  if id "$user" &>/dev/null; then
    usermod -s "$FISH" "$user"
    echo "shell → $FISH  ($user)"
  else
    echo "skip missing user: $user"
  fi
done

# Default for future useradd(8) accounts (Arch/systemd)
if [[ -f /etc/default/useradd ]]; then
  if grep -qE '^#?SHELL=' /etc/default/useradd; then
    sed -i 's|^#\?SHELL=.*|SHELL=/usr/bin/fish|' /etc/default/useradd
  else
    printf '\nSHELL=/usr/bin/fish\n' >> /etc/default/useradd
  fi
  echo "updated /etc/default/useradd"
fi

# Debian/Ubuntu adduser(8), if present
if [[ -f /etc/adduser.conf ]]; then
  if grep -qE '^#?DSHELL=' /etc/adduser.conf; then
    sed -i 's|^#\?DSHELL=.*|DSHELL=/usr/bin/fish|' /etc/adduser.conf
  else
    printf '\nDSHELL=/usr/bin/fish\n' >> /etc/adduser.conf
  fi
  echo "updated /etc/adduser.conf"
fi

echo
echo "Current shells:"
getent passwd root woragis browser | cut -d: -f1,7
echo
grep -E '^SHELL=' /etc/default/useradd 2>/dev/null || true
echo "Done. Log out/in (or open a new session) for login shells to refresh."
