# ConCal - 習慣トラッカーカレンダー

毎日の習慣継続を記録するシンプルなカレンダーアプリ。

## 技術スタック

- **バックエンド**: Common Lisp (SBCL)
- **Webサーバー**: Hunchentoot
- **テンプレート**: Spinneret (S式 → HTML)
- **ORM**: Mito (PostgreSQL)
- **フロントエンド**: HTMX (ページリロードなしの部分更新)
- **データベース**: PostgreSQL (Docker)

## セットアップ (Nix Flakes)

### 1. 開発環境に入る

```bash
cd /home/user/src/concal
nix develop
# または direnv が有効な場合は自動で環境に入る
```

### 2. PostgreSQL起動

```bash
docker-compose up -d
```

### 3. アプリケーション起動

```bash
sbcl
```

```lisp
(ql:quickload :concal)
(concal:start)
```

### 4. アクセス

ブラウザで http://localhost:8080 にアクセス

### ビルド (オプション)

実行可能バイナリを作成:

```bash
nix build
./result/bin/concal
```

## 使い方

1. カレンダーの日付をタップして、その日の習慣を達成したことを記録
2. もう一度タップすると記録を解除
3. 「<」「>」ボタンで前月/翌月を表示
4. 「今日」ボタンで現在の月に戻る

## API

| メソッド | パス | 説明 |
|----------|------|------|
| GET | `/` | メインページ |
| GET | `/calendar?year=&month=` | カレンダー部分HTML (HTMX) |
| POST | `/api/toggle/:date` | チェックトグル (HTMX) |

## 環境変数

| 変数名 | デフォルト | 説明 |
|--------|------------|------|
| `CONCAL_DB_HOST` | localhost | PostgreSQLホスト |
| `CONCAL_DB_PORT` | 5432 | PostgreSQLポート |
| `CONCAL_DB_NAME` | concal | データベース名 |
| `CONCAL_DB_USER` | concal | DBユーザー |
| `CONCAL_DB_PASSWORD` | concal_password | DBパスワード |
| `CONCAL_PORT` | 8080 | Webサーバーポート |

## ファイル構成

```
concal/
├── src/
│   ├── package.lisp       # パッケージ定義
│   ├── config.lisp        # 設定
│   ├── db/
│   │   ├── connection.lisp    # DB接続
│   │   └── migrations.lisp    # マイグレーション
│   ├── models/
│   │   └── habit-record.lisp  # Mitoモデル
│   ├── views/
│   │   ├── layout.lisp        # 共通レイアウト
│   │   ├── components.lisp    # UIコンポーネント
│   │   └── calendar.lisp      # カレンダービュー
│   ├── handlers/
│   │   ├── pages.lisp         # ページハンドラー
│   │   └── api.lisp           # APIハンドラー
│   ├── routes.lisp        # ルート定義
│   ├── server.lisp        # サーバー設定
│   └── main.lisp          # エントリーポイント
├── static/
│   └── css/
│       └── style.css      # スタイルシート
├── concal.asd             # ASDF定義
├── docker-compose.yml
└── README.md
```
