# SQLite MCP Server DXT パッケージ

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

このディレクトリには、Claude Desktop統合用のDXT（Desktop Extension）パッケージファイルが含まれています。

## 概要

DXTパッケージにより、このSQLite MCPサーバーをClaude Desktop内でネイティブ拡張として簡単にインストール・使用でき、Model Context Protocolを通じてシームレスなデータベース操作を提供します。

## ファイル説明

- **manifest.json**: メタデータと設定を含むDXTマニフェストファイル
- **index.js**: DXTパッケージのメインエントリーポイント
- **package.json**: DXT用のNode.jsパッケージ設定
- **README_ja.md**: このドキュメントファイル（日本語）
- **README.md**: 英語ドキュメント

## 機能

- ゼロ設定でのSQLiteデータベースアクセス
- Claude Desktopとのシームレスな統合
- すべての標準的なSQL操作のサポート
- 組み込みエラーハンドリングとログ出力

## Claude Desktopでのインストール

1. DXTパッケージをビルド（プロジェクトルートのREADME参照）
2. 生成された`.dxt`ファイルをClaude Desktopの拡張機能ディレクトリにコピー
3. Claude Desktopを再起動
4. SQLite MCPサーバーが利用可能になります

## ビルド方法

### bash、コマンドプロンプト、PowerShell、zsh共通

```sh
# bash、コマンドプロンプト、PowerShell、zsh共通
npm run package

# PowerShellだけコマンドが異なる
npm run package-ps
```

ビルド後、`../dist/sqlite-mcp-server.dxt` が生成されます。

## 使用方法

インストール後、以下のことができます：

- データベーステーブルの作成と管理
- データの挿入、更新、削除
- SQL操作によるデータ分析
- レポートと洞察の生成

## データベースの場所

SQLiteデータベースファイル（`database.db`）はプロジェクトルートディレクトリに作成されます。`init_ja.sql`を利用して初期化も可能です。必要に応じて各種DBツールで直接操作できます。

## トラブルシューティング

拡張機能が読み込まれない場合：

1. Node.js 18以上がインストールされていることを確認
2. Claude Desktopの内蔵Node.jsを利用していることを確認
3. DXTファイルが正しく生成されたことを確認
4. Claude Desktopがファイルシステムへのアクセス権限を持つことを確認
5. Claude Desktopの拡張機能ログでエラーメッセージを確認

## サポート

DXTパッケージ固有の問題は、[プロジェクトルートのREADME_ja.md](../README_ja.md)を参照してください。追加の質問やバグ報告は、リポジトリのIssue機能をご利用ください。

## ライセンス

このパッケージはMITライセンスです。詳細はプロジェクトルートのLICENSEファイルを参照してください。
