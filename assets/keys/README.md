# 鍵の運用方法

## ファイル概要

| ファイル                       | 用途                        | 配置場所         | 形式 |
| ------------------------------ | --------------------------- | ---------------- | ---- |
| `private_key.pem`              | JWS署名生成（QRコード生成） | LINEミニアプリ側 | PEM  |
| `private_key_jwk.json`         | JWS署名生成（QRコード生成） | LINEミニアプリ側 | JWK  |
| `public_key.pem`               | JWS署名検証（QRコード検証） | ゲート側         | PEM  |
| `public_key_jwk.json`          | JWS署名検証（QRコード検証） | ゲート側         | JWK  |
| `private_key_jwk.json.example` | 開発・テスト用サンプル      | 開発環境         | JWK  |
| `public_key_jwk.json.example`  | 開発・テスト用サンプル      | 開発環境         | JWK  |

## 運用フロー

### 1. QRコード生成側

- **使用鍵**: `private_key_jwk.json`
- **処理**: ES256アルゴリズムでJWS署名を生成
- **出力**: JWSコンパクトシリアライゼーション形式の文字列

### 2. QRコード検証側（ゲート）

- **使用鍵**: `public_key_jwk.json`
- **処理**: ES256アルゴリズムでJWS署名を検証
- **入力**: QRコードから読み取ったJWS文字列

## セキュリティ注意事項

### ⚠️ 秘密鍵の管理

- `private_key.pem` と `private_key_jwk.json` は厳重に管理する
- 外部に漏洩しないよう適切なアクセス制御を実施
- 本番環境では環境変数や専用のキー管理サービスを使用

### ✅ 公開鍵の配布

- `public_key.pem` と `public_key_jwk.json` は検証側に安全に配布
- 鍵の真正性を保証する仕組み（証明書等）の検討

## JWS仕様

- **署名アルゴリズム**: ES256 (ECDSA using P-256 and SHA-256)
- **楕円曲線**: P-256 (secp256r1)
- **ヘッダー**: `{"alg": "ES256"}` (kid無し)
- **出力形式**: JWSコンパクトシリアライゼーション

## ペイロード構造

```json
{
  "event_code": "イベントコード",
  "ticket_id": "チケットID（UUID形式）",
  "ticket_type_code": "チケット種別コード",
  "sponsor_code": "スポンサーコード（nullable）",
  "special_ticket_code": "特別チケットコード（nullable）",
  "issued_at": "発行日時（ISO8601形式）"
}
```

## サンプルファイル

### 📁 .example ファイルについて

- **`private_key_jwk.json.example`**: 秘密鍵JWKのサンプル形式
- **`public_key_jwk.json.example`**: 公開鍵JWKのサンプル形式

### 🔧 使用方法

1. `.example`ファイルをコピーして実際のファイル名にリネーム
2. サンプルの鍵値を実際の鍵値に置き換え
3. 本番環境では`.example`ファイルは除外

```bash
# サンプルファイルから実際のファイルを作成
cp private_key_jwk.json.example private_key_jwk.json
cp public_key_jwk.json.example public_key_jwk.json

# 実際の鍵値に更新（手動編集）
# 注意: サンプルの鍵値は使用しないこと
```
