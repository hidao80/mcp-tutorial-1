# SQLite MCP Serverチュートリアル(1)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

SQLiteデータベースを操作するためのModel Context Protocol (MCP) サーバーの最初のチュートリアルです。Cursorエディターやその他のMCP対応クライアントで使用できます。

## 本リポジトリの機能

- SQLiteデータベースの読み書き操作
- SQLクエリの実行
- テーブルの作成・削除・変更
- データの挿入・更新・削除
- スキーマの確認

## 本リポジトリの特徴

- **ゼロ設定**: 追加設定なしで即座に使用開始
- **完全なSQL操作サポート**: 作成、読み取り、更新、削除の全操作
- **クロスプラットフォーム**: Windows、macOS、Linux対応

## セットアップ

### 1. データベースの初期化

初期データが必要な場合は、SQLiteコマンドまたはDBブラウザーを使用して`init_ja.sql`を実行してください：

#### SQLite3がインストールされている場合

```sh
# bash、コマンドプロンプト、zshの場合
sqlite3 database.db < init_ja.sql

# powershellの場合
Get-Content .\init_ja.sql | sqlite3.exe .\database.db
```

### 2. MCPサーバーの動作環境のインストール

本リポジトリでは`uvx`を利用しますので、あらかじめ`uv`のインストールが必要です。

```sh
# macOS
brew install uv

# Windows11
winget install --id=astral-sh.uv
```

## 3. MCP設定ファイルの配置

**Cursorの場合**: `.cursor/mcp.json`
**VS Codeの場合**: `.vscode/mcp.json`
**Windsurfの場合**: `.windsurf/mcp.json`

このプロジェクトでは`./.cursor/mcp.json`と`./.vscode/mcp.json`と`./.windsurf/mcp.json`を
配置しているため、プロジェクトを開いた際に自動的に認識されます。

## 4. セットアップ手順

### Cursorの場合

1. このリポジトリをクローンまたはダウンロード
2. Cursorでこのリポジトリのディレクトリを開く
3. `Shift + Ctrl + P`（Windows/Linxu）`Cmd + Shift + P`（MacBook）で
  コマンドパレットを開く
4. `openmcp`と入力し、「Tools & Integrations」タブを開く
5. 「MCP Tools」節より「sqlite」MCPサーバのスイッチをオン（緑色）にする

### VS Codeの場合

1. このリポジトリをクローンまたはダウンロード
2. VS Codeでこのリポジトリのディレクトリを開く
3. `Shift + Ctrl + P`（Windows/Linxu）`Cmd + Shift + P`（MacBook）で
  コマンドパレットを開く
4. `mcpli`と入力し、「MCP: サーバーの一覧表示」を選択する
5. コマンドパレットから「sqlite　停止中」を選択し、起動する

### Windsurfの場合

1. このリポジトリをクローンまたはダウンロード
2. Windsurfでこのリポジトリのディレクトリを開く
3. `Shift + Ctrl + P`（Windows/Linxu）`Cmd + Shift + P`（MacBook）で
  コマンドパレットを開く
4. `mcpli`と入力し、「MCP: サーバーの一覧表示」を選択する
5. コマンドパレットから「sqlite　停止中」を選択し、起動する

### Claude Desktopでの使用方法

Claude DesktopでMCPサーバーを利用するためにDXT（Desktop extentions：デスクトップ拡張機能）パッケージをビルドしてインストールします。

Claude Desktop用のDXTパッケージをビルドする手順は以下の通り：

```sh
# bash、コマンドプロンプト、PowerShell、zsh共通
# dxtディレクトリに移動してビルド
cd dxt-src
npm run package

# PowerShellだけコマンドが異なる
npm run package-ps
```

ビルドが成功すると、`dist/sqlite-mcp-server.dxt`ファイルが生成されます。

### 必要な依存関係

DXTパッケージのビルドには以下が必要です：

- Node.js 18以上
- 公式DXT CLI（npm run build実行時に自動インストール）

### Claude Desktopへのインストール

1. 上記の手順でDXTパッケージをビルド
2. 生成された`.dxt`ファイルをClaude Desktopの設定＞拡張機能画面にドラッグアンドドロップ
3. 「SQLite MCP Server」にSqliteのデータベースファイルのパスを与え、「有効」スイッチをオン（青色）にする
4. データベースファイルが指定された位置にあれば、SQLite MCPサーバーが利用可能になります

## トラブルシューティング

### MCPサーバーが起動しない場合

1. `uv`がインストールされていることを確認
2. インターネット接続を確認（`uvx`でパッケージをダウンロードするため）
3. データベースファイルがプロジェクトルートに`database.db`という名前で存在することを確認

### データベースファイルが見つからない場合

1. プロジェクトディレクトリの書き込み権限を確認
2. `init_ja.sql`を`sqlite3`で実行してデータベースを作成
3. `mcp.json`や「SQLite MCP Server」DXTにデータベースファイルへのパスが
  正しく設定されているか確認

## ファイル構成

```plain
mcp-tutorial-1/
├── init_ja.sql               # 初期データベーススキーマとサンプルデータ（日本語版）
├── init.sql                  # 初期データベーススキーマとサンプルデータ（英語版）
├── README.md                 # このファイル
├── database.db               # SQLiteデータベースファイル（初期化時に作成）
├── .gitignore                # Git除外設定
├── .cursor/mcp.json          # MCP設定ファイル（Cursor用）
├── .vscode/mcp.json          # MCP設定ファイル（VS Code用）
├── .windsurf/mcp.json        # MCP設定ファイル（Windsurf用）
├── docs/                     # 設計ドキュメントファイル群
│   ├── DESIGN_ja.md          # 設計ドキュメント（日本語）
│   └── DESIGN.md             # 設計ドキュメント（英語）
├── dxt-src/                  # Claude Desktop用DXTファイル群
│   ├── manifest.json         # DXTマニフェストファイル
│   ├── icon.png              # DXTアイコン画像
│   ├── index.js              # DXTメインエントリーポイント
│   ├── package.json          # DXT用パッケージ設定
│   ├── README_ja.md          # DXT固有のドキュメント（日本語）
│   └── README.md             # DXT固有のドキュメント（英語）
└── dist/                     # ビルド成果物（.dxtファイル）
    └── sqlite-mcp-server.dxt # Claude Desktop用デスクトップ拡張機能
```

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルをご覧ください。
