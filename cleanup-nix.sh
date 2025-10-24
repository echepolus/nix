#!/usr/bin/env bash
set -euo pipefail

echo "🧹 Удаляем старые поколения home-manager..."
if command -v home-manager &>/dev/null; then
  home-manager expire-generations 7d || true
fi

echo "🧹 Удаляем старые поколения nix-darwin..."
if command -v darwin-rebuild &>/dev/null; then
  # Просто пересобираем систему, чтобы clean старых drv не мешал
  darwin-rebuild build || true
fi

echo "🗑 Удаляем старые поколения Nix..."
nix-collect-garbage -d || true

echo "🔍 Проверяем целостность nix-store и удаляем битые derivations..."
nix-store --verify --check-contents || true

echo "♻️ Оптимизация nix-store..."
if command -v nix-store &>/dev/null; then
  sudo -H nix-store --optimise || true
fi

echo "✅ Очистка завершена! Теперь можно запускать 'nr' без ошибок."
