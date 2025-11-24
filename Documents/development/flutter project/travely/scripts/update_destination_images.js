// 여행지 이미지 URL을 Unsplash 이미지로 업데이트하는 스크립트
// 사용법: node scripts/update_destination_images.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Firebase Admin SDK 초기화
const serviceAccount = require('../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// 여행지별 Unsplash 이미지 URL 매핑
const destinationImages = {
  '베트남 다낭': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&h=600&fit=crop',
  '태국 치앙마이': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800&h=600&fit=crop',
  '필리핀 보라카이': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '타이베이': 'https://images.unsplash.com/photo-1595425970377-c97044cbd0a3?w=800&h=600&fit=crop',
  '방콕': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800&h=600&fit=crop',
  '쿠알라룸푸르': 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=800&h=600&fit=crop',
  '몰디브': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop',
  '세이셸': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '보라보라': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '도쿄': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&h=600&fit=crop',
  '싱가포르': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&h=600&fit=crop',
  '두바이': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&h=600&fit=crop',
  '제주도': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop',
  '발리': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&h=600&fit=crop',
  '푸켓': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '부산': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop',
  '호치민': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&h=600&fit=crop',
  '페낭': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '라오스': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800&h=600&fit=crop',
  '네팔': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&h=600&fit=crop',
  '스리랑카': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
  '서울': 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=800&h=600&fit=crop',
  '홍콩': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&h=600&fit=crop',
};

async function updateDestinationImages() {
  try {
    console.log('🚀 여행지 이미지 URL 업데이트 시작...\n');

    // 모든 types 문서 가져오기
    const typesSnapshot = await db.collection('types').get();
    
    let totalUpdated = 0;
    let typesUpdated = 0;

    for (const typeDoc of typesSnapshot.docs) {
      const typeData = typeDoc.data();
      const destinations = typeData.destinations || [];
      let hasUpdates = false;
      const updatedDestinations = [];

      for (const destination of destinations) {
        const destName = destination.name;
        const newImageUrl = destinationImages[destName];
        
        if (newImageUrl) {
          // 항상 Unsplash URL로 업데이트 (강제 업데이트)
          updatedDestinations.push({
            ...destination,
            imageUrl: newImageUrl,
          });
          hasUpdates = true;
          totalUpdated++;
          console.log(`  📸 ${destName}: 이미지 URL 업데이트 (기존: ${destination.imageUrl || '비어있음'} → ${newImageUrl})`);
        } else {
          // 매핑에 없는 여행지
          console.log(`  ⚠️ ${destName}: 매핑에 없는 여행지 (현재 imageUrl: ${destination.imageUrl || '비어있음'})`);
          updatedDestinations.push(destination);
        }
      }

      if (hasUpdates) {
        await typeDoc.ref.update({
          destinations: updatedDestinations,
        });
        console.log(`✅ ${typeData.name} (${typeDoc.id}): ${updatedDestinations.length}개 여행지 업데이트\n`);
        typesUpdated++;
      }
    }

    console.log(`\n🎉 완료!`);
    console.log(`   - ${typesUpdated}개 유형 업데이트`);
    console.log(`   - ${totalUpdated}개 여행지 이미지 업데이트`);
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
  }
}

updateDestinationImages();

