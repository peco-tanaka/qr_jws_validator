/// QRコード用JWT生成ツール
/// jose_plus公式ドキュメントに基づくES256署名付きJWT生成
library qr_jwt_generator;

import 'dart:convert';
import 'dart:io';
import 'package:jose_plus/jose.dart';

/// JWK秘密鍵ファイルを読み込む
/// 
/// 戻り値: JWK形式の秘密鍵
Future<JsonWebKey> _loadPrivateKey() async {
  const keyPath = 'assets/keys/private_key_jwk.json';
  final keyFile = File(keyPath);
  final keyJson = await keyFile.readAsString();
  final keyMap = json.decode(keyJson) as Map<String, dynamic>;
  final jwk = JsonWebKey.fromJson(keyMap);
  if (jwk == null) {
    throw Exception('JWKファイルの読み込みに失敗しました');
  }
  return jwk;
}

/// JWT Claims構築
/// 
/// [payload] - QRコード用のカスタムデータ
/// 戻り値: JWT標準クレームを含むMapデータ
Map<String, dynamic> _buildJWTClaims(Map<String, dynamic> payload) {
  final now = DateTime.now();
  final expiry = now.add(Duration(hours: 1)); // 1時間の有効期限
  
  return {
    'iat': now.millisecondsSinceEpoch ~/ 1000,        // 発行時刻
    'exp': expiry.millisecondsSinceEpoch ~/ 1000,     // 有効期限
    'iss': 'qr-jwt-generator',                        // 発行者
    ...payload,                                       // カスタムペイロード
  };
}

/// QRコード用のJWT生成メイン関数
/// 
/// [payload] - QRコードに埋め込むデータ
/// 戻り値: JWT Compact Serialization形式の文字列
Future<String> generateQRCodeJWT(Map<String, dynamic> payload) async {
  // 1. JWKファイル読み込み ✅
  final privateKey = await _loadPrivateKey();
  
  // 2. JWT Claims構築 ✅
  final claims = _buildJWTClaims(payload);
  
  // 3. JWS署名生成（公式ドキュメントパターン）
  final builder = JsonWebSignatureBuilder();
  builder.jsonContent = claims;
  builder.addRecipient(privateKey, algorithm: 'ES256');
  
  // 4. Compact Serialization返却
  final jws = builder.build();
  return jws.toCompactSerialization();
}

/// メイン実行関数（テスト用）
Future<void> main() async {
  try {
    // サンプルペイロード
    final payload = {
      'userId': '12345',
      'eventId': 'event789',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    final jwt = await generateQRCodeJWT(payload);
    print('生成されたJWT: $jwt');
  } catch (e) {
    print('エラー: $e');
  }
}