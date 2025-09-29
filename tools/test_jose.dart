// 最小限のjose_plusテスト
import 'package:jose_plus/jose.dart';

void main() {
  // 公式ドキュメントの例をそのまま実行
  var jwk = JsonWebKey.fromJson({
    "kty": "EC",
    "crv": "P-256",
    "x": "f83OJ3D2xF1Bg8vub9tLe1gHMzV76e8Tus9uPHvRVEU",
    "y": "x_FEzRu9m36HLN_tue659LNpXW6pCyStikYjKIWI5a0",
  });
  
  if (jwk != null) {
    print('JWK loaded: ${jwk.keyType}');
  } else {
    print('JWK読み込みに失敗しました');
  }
}