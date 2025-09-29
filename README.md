# qr_jws_validator

> JWS検証機能の事前検証アプリ

## 1. 鍵生成コマンド

### ES256対応の秘密鍵生成

```txt
cd assets/keys
```

```txt
openssl genpkey -algorithm EC -out private_key.pem -pkeyopt ec_paramgen_curve:P-256
```

- -algorithm alg: 楕円曲線暗号アルゴリズムを指定（ES256アルゴリズムの基盤となる暗号方式）
- -out filename: 秘密鍵の出力ファイル名
- -pkeyopt ec_paramgen_curve:P-256: ES256で使用するP-256曲線を指定
    - [openssl: genpkeyリファレンス](https://docs.openssl.org/master/man1/openssl-genpkey/)

### 2. 公開鍵の抽出

```txt
openssl pkey -in private_key.pem -pubout -out public_key.pem
```

- -in filename|uri: 入力ファイル名またはURIを指定
- -pubout: 公開鍵または鍵ペアの公開コンポーネントの正確性をチェック
- -out filename: 出力ファイル名を指定
    - [openssl: pkeyリファレンス](https://docs.openssl.org/master/man1/openssl-pkey/)

オプション

- 秘密鍵の内容を確認

```txt
openssl pkey -in private_key.pem -text -noout
```

- 公開鍵の内容を確認

```txt
openssl pkey -in public_key.pem -pubin -text -noout
```

## 3. PEM形式の公開鍵をJWK形式に変換

- ツール
    - [PEM to JWK Converter](https://www.authgear.com/tools/jwk-generator)

## 4
