# NixOS Configuration

複数ホストを同じリポジトリで管理しやすくした、モジュール化された NixOS + Home Manager 設定です。

## ディレクトリ構造

```
.
├── flake.nix                  # Flake設定
├── dotfiles/                  # シェル設定ファイル
├── hosts/                     # ホスト構成
│   ├── common/                # 全ホスト共通のシステムモジュール束ね
│   │   └── default.nix
│   └── nixos/                 # 現在のホスト
│       ├── default.nix        # このホストの構成エントリーポイント
│       └── hardware-configuration.nix
├── home/                      # Home Manager設定
│   ├── default.nix           # Home Managerのメインファイル
│   └── programs/             # プログラム別設定
│       ├── git.nix           # Git設定
│       ├── gnome.nix         # GNOME/dconf設定
│       ├── packages.nix      # ユーザーパッケージ
│       └── shell.nix         # シェル設定
└── modules/                   # 機能別モジュール
    ├── audio/                # オーディオ設定（PipeWire）
    ├── boot/                 # ブート設定
    ├── desktop/              # デスクトップ環境（X11/GNOME）
    ├── gaming/               # ゲーム関連（Steam）
    ├── hardware/             # ハードウェア固有設定（NVIDIA）
    ├── locale/               # ロケール/フォント/入力メソッド
    ├── networking/           # ネットワーク設定
    ├── users/                # ユーザー設定
    └── vr/                   # VR関連（WiVRn）
```

## 使い方

### 設定を適用する

```bash
sudo nixos-rebuild switch --flake .#nixos
```

別ホストを追加した場合は `.#<host>` を使います。

### 設定をテストする（再起動せずに適用）

```bash
sudo nixos-rebuild test --flake .#nixos
```

### ビルドのみ（適用しない）

```bash
nixos-rebuild dry-build --flake .#nixos
```

### Flake設定をチェック

```bash
nix flake check
```

## GitHub Actionsで自動更新

`.github/workflows/flake-update.yml` で、3日に1回 `nix flake update` を実行します。
更新があった場合は以下を自動で行います。

1. `flake.lock` を更新
2. `.#nixosConfigurations.${HOST_NAME:-nixos}.config.system.build.toplevel` をビルド
3. ビルド結果をCachixへpush
4. `flake.lock` をコミットして `main` にpush

必要なGitHub設定:

- Actions secret: `CACHIX_AUTH_TOKEN`
- Actions variable（任意）: `CACHIX_CACHE_NAME`（未設定時は `akazdayo` を使用）

## 新しいモジュールを追加する

1. `modules/` に新しいディレクトリとファイルを作成
2. 共通機能なら `hosts/common/default.nix` の `imports` に追加
3. 特定ホスト専用なら `hosts/<host>/default.nix` の `imports` に追加

例：
```nix
# modules/新機能/default.nix
{pkgs, ...}: {
  # 設定をここに記述
}
```

```nix
# hosts/common/default.nix
{
  imports = [
    # ...
    ../../modules/新機能
  ];
}
```

## Home Manager設定を追加する

1. `home/programs/` に新しいファイルを作成
2. `home/default.nix` の `imports` に追加
