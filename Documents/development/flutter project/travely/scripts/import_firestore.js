// Firestore 데이터 자동 입력 스크립트
// 사용법: node scripts/import_firestore.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Firebase Admin SDK 초기화
// 서비스 계정 키 파일이 필요합니다 (Firebase Console에서 다운로드)
const serviceAccount = require('../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function importData() {
  try {
    // firestore_data.json 파일 읽기
    const dataPath = path.join(__dirname, '../firestore_data.json');
    const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

    console.log('🚀 Firestore 데이터 입력 시작...\n');

    // 1. questions 컬렉션 입력
    if (data.questions && Array.isArray(data.questions)) {
      console.log('📝 questions 컬렉션 입력 중...');
      const questionsBatch = db.batch();
      
      for (const question of data.questions) {
        const docRef = db.collection('questions').doc(question.id);
        // id 필드 제거 (문서 ID로 사용)
        const { id, ...questionData } = question;
        questionsBatch.set(docRef, questionData);
      }
      
      await questionsBatch.commit();
      console.log(`✅ ${data.questions.length}개 질문 입력 완료\n`);
    }

    // 2. types 컬렉션 입력
    if (data.types && typeof data.types === 'object') {
      console.log('🎯 types 컬렉션 입력 중...');
      const typesBatch = db.batch();
      let count = 0;
      
      for (const [code, typeData] of Object.entries(data.types)) {
        const docRef = db.collection('types').doc(code);
        typesBatch.set(docRef, typeData);
        count++;
      }
      
      await typesBatch.commit();
      console.log(`✅ ${count}개 유형 입력 완료\n`);
    }

    console.log('🎉 모든 데이터 입력 완료!');
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
  }
}

importData();

