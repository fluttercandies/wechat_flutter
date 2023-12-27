cd ios
pod install
cd ..
flutter build ios
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath ./archive archive
xcodebuild -exportArchive -archivePath ./archive.xcarchive -exportPath ./export -exportOptionsPlist ./config/ExportOptions.plist
#curl -F "file=@./export/wechat_flutter.ipa" \
#-F "uKey=01e0da7cc9905550619d14e458688472" \
#-F "_api_key=1bff420ce07bc9687cd3a5ca4629b7ec" \
#https://www.pgyer.com/apiv1/app/upload
#echo "";
#echo "IOS包地址：https://www.pgyer.com/86BC";
#echo "";
