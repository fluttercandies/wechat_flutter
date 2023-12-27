flutter build apk
mkdir androidApk
mv build/app/outputs/flutter-apk/app-release.apk androidApk/app-release.apk
curl -F "file=@./androidApk/app-release.apk" \
-F "uKey=01e0da7cc9905550619d14e458688472" \
-F "_api_key=1bff420ce07bc9687cd3a5ca4629b7ec" \
https://www.pgyer.com/apiv1/app/upload
echo "";
echo "Android包地址：https://www.pgyer.com/bVyU";
echo "";
