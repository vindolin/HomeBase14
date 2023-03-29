adb connect %1
java -jar ../bundletool-all-1.14.0.jar build-apks --connected-device --device-id=%1 --bundle=build\app\outputs\bundle\release\app-release.aab --output=..\homebase_tablet.apks
java -jar ../bundletool-all-1.14.0.jar install-apks --device-id=%1 --apks=..\homebase_tablet.apks
