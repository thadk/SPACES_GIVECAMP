rm -rf tmp
mkdir tmp
cd tmp
mkdir Payload
cp -a ../build/AdHoc-iphoneos/SPACES.app Payload/SPACES.app
ID=`strings Payload/SPACES.app/embedded.mobileprovision | grep -A1 UUID | tail -1 | cut -d\> -f2 | cut -d\< -f1`
cp Payload/SPACES.app/embedded.mobileprovision Payload/${ID}.mobileprovision
cp ../spaces_app-512.png iTunesArtwork
rm ../SPACES.ipa
zip -r ../SPACES.ipa iTunesArtwork Payload
cd ..
