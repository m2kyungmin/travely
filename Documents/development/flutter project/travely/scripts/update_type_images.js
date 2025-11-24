// types 컬렉션의 imageUrl을 Unsplash 이미지로 업데이트하는 스크립트
// 사용법: node scripts/update_type_images.js

const admin = require('firebase-admin');

// Firebase Admin SDK 초기화
const serviceAccount = require('../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// 유형별 Unsplash 이미지 URL 매핑
const typeImages = {
  'SABN': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&h=600&fit=crop', // 자유로운 탐험가
  'SABC': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop', // 모험가
  'SALN': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&h=600&fit=crop', // 자유로운 힐러
  'SALC': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&h=600&fit=crop', // 힐링 전문가
  'SRBN': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&h=600&fit=crop', // 계획적인 탐험가
  'SRBC': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&h=600&fit=crop', // 완벽주의 모험가
  'SRLN': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop', // 계획적인 힐러
  'SRLC': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&h=600&fit=crop', // 완벽주의 힐러
  'PABN': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800&h=600&fit=crop', // 자유로운 도시 탐험가
  'PABC': 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=800&h=600&fit=crop', // 도시 모험가
  'PALN': 'https://images.unsplash.com/photo-1595425970377-c97044cbd0a3?w=800&h=600&fit=crop', // 자유로운 도시 힐러
  'PALC': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop', // 도시 힐링 전문가
  'PRBN': 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=800&h=600&fit=crop', // 계획적인 도시 탐험가
  'PRBC': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&h=600&fit=crop', // 완벽주의 도시 모험가
  'PRLN': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop', // 계획적인 도시 힐러
  'PRLC': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&h=600&fit=crop', // 완벽주의 도시 힐러
};

async function updateTypeImages() {
  try {
    console.log('🚀 유형 이미지 URL 업데이트 시작...\n');

    // 모든 types 문서 가져오기
    const typesSnapshot = await db.collection('types').get();
    
    let totalUpdated = 0;

    for (const typeDoc of typesSnapshot.docs) {
      const typeData = typeDoc.data();
      const typeCode = typeData.code || typeDoc.id;
      const currentImageUrl = typeData.imageUrl || '';
      const newImageUrl = typeImages[typeCode];

      // example.com을 포함하거나 Unsplash가 아닌 경우 업데이트
      if (newImageUrl && (currentImageUrl.includes('example.com') || !currentImageUrl.includes('unsplash.com'))) {
        await typeDoc.ref.update({
          imageUrl: newImageUrl,
        });
        console.log(`✅ ${typeData.name || typeCode} (${typeCode}): 이미지 URL 업데이트`);
        console.log(`   ${currentImageUrl} → ${newImageUrl}\n`);
        totalUpdated++;
      } else if (!newImageUrl) {
        console.log(`⚠️  ${typeCode}: 매핑된 이미지 URL 없음 (건너뜀)\n`);
      } else {
        console.log(`✓ ${typeData.name || typeCode} (${typeCode}): 이미지 URL 이미 업데이트됨\n`);
      }
    }

    console.log(`\n🎉 완료!`);
    console.log(`   - ${totalUpdated}개 유형 이미지 업데이트`);
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
  }
}

updateTypeImages();

