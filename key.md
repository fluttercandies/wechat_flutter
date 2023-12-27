# 签名信息
keytool -genkey -alias android.keystore -keyalg RSA -keysize 2048 -validity 36500 -keystore android.keystore
密码123456

# 查看详情
keytool -list -v -keystore android.keystore

```agsl
Keystore type: jks
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: android.keystore
Creation date: Oct 15, 2022
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=a, OU=a, O=good, L=guangzhou, ST=china, C=cn
Issuer: CN=a, OU=a, O=good, L=guangzhou, ST=china, C=cn
Serial number: 67d0efee
Valid from: Sat Oct 15 18:33:25 CST 2022 until: Mon Sep 21 18:33:25 CST 2122
Certificate fingerprints:
         MD5:  29:3F:F2:48:1A:F8:0A:C7:C6:86:CB:D1:D0:6C:18:74
         SHA1: 1C:65:9D:43:06:09:01:67:BC:72:93:38:DA:F1:A8:A7:35:E5:87:37
         SHA256: C3:97:37:64:61:CE:BB:35:B2:15:AB:5C:63:C8:C2:9E:CB:22:BC:D8:40:80:35:12:82:70:B4:9C:13:B2:46:33
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions: 

#1: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: 8E 44 A7 0E DF 2F 17 05   8D AB CB 7C 16 8D CC 79  .D.../.........y
0010: A0 C4 C5 7E                                        ....
]
]



*******************************************
*******************************************



Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore android.keystore -destkeystore android.keystore -deststoretype pkcs12".
 q1@q1deMacBook-Pro  ~/Documents/git/wechat_flutter_inner/android/app   main ±✚  
```