// Firestore의 여행지 이미지 URL 확인 스크립트
// 사용법: node scripts/check_destination_images.js

const admin = require('firebase-admin');

// Firebase Admin SDK 초기화
const serviceAccount = require('../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function checkDestinationImages() {
  try {
    console.log('🔍 Firestore 여행지 이미지 URL 확인 중...\n');

    // 모든 types 문서 가져오기
    const typesSnapshot = await db.collection('types').get();
    
    let totalDestinations = 0;
    let emptyImageUrls = 0;

    for (const typeDoc of typesSnapshot.docs) {
      const typeData = typeDoc.data();
      const destinations = typeData.destinations || [];
      
      console.log(`\n📋 ${typeData.name} (${typeDoc.id}):`);
      console.log(`   여행지 개수: ${destinations.length}`);
      
      for (let i = 0; i < destinations.length; i++) {
        const dest = destinations[i];
        totalDestinations++;
        
        const imageUrl = dest.imageUrl || '';
        const isEmpty = !imageUrl || imageUrl.trim() === '';
        
        if (isEmpty) {
          emptyImageUrls++;
          console.log(`   ❌ 여행지 ${i + 1}: ${dest.name}`);
          console.log(`      imageUrl: "${imageUrl}" (비어있음)`);
        } else {
          console.log(`   ✅ 여행지 ${i + 1}: ${dest.name}`);
          console.log(`      imageUrl: "${imageUrl.substring(0, 60)}..."`);
        }
      }
    }

    console.log(`\n📊 요약:`);
    console.log(`   - 총 여행지: ${totalDestinations}개`);
    console.log(`   - 이미지 URL 비어있음: ${emptyImageUrls}개`);
    console.log(`   - 이미지 URL 있음: ${totalDestinations - emptyImageUrls}개`);
    
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
  }
}

checkDestinationImages();

