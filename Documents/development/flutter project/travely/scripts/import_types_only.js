// Firestore types 컬렉션만 업데이트하는 스크립트
// 사용법: node scripts/import_types_only.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Firebase Admin SDK 초기화
const serviceAccount = require('../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function importTypes() {
  try {
    // complete_travel_types.json 파일 읽기
    const dataPath = path.join(__dirname, '../complete_travel_types.json');
    const typesData = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

    console.log('🚀 Firestore types 컬렉션 업데이트 시작...\n');

    // types 컬렉션 입력/업데이트
    const batch = db.batch();
    let count = 0;
    
    for (const [code, typeData] of Object.entries(typesData)) {
      const docRef = db.collection('types').doc(code);
      batch.set(docRef, typeData, { merge: true });
      console.log(`📝 ${code}: ${typeData.name} 준비됨`);
      count++;
    }
    
    await batch.commit();
    console.log(`\n✅ ${count}개 유형 업데이트 완료!`);
    console.log('\n🎉 모든 데이터 입력 완료!');
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
  }
}

importTypes();
