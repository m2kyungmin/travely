// questions 컬렉션만 빠르게 입력하는 스크립트
// 사용법: node scripts/import_questions_only.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Firebase Admin SDK 초기화
const serviceAccountPath = path.join(__dirname, '../serviceAccountKey.json');

if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ serviceAccountKey.json 파일을 찾을 수 없습니다.');
  console.log('Firebase Console → 프로젝트 설정 → 서비스 계정 → 새 비공개 키 생성');
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function importQuestions() {
  try {
    const dataPath = path.join(__dirname, '../firestore_data.json');
    const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

    if (!data.questions || !Array.isArray(data.questions)) {
      console.error('❌ questions 데이터를 찾을 수 없습니다.');
      process.exit(1);
    }

    console.log('🚀 questions 컬렉션 입력 시작...\n');

    // 배치로 나누어 입력 (Firestore 제한: 500개/배치)
    const batchSize = 500;
    const questions = data.questions;

    for (let i = 0; i < questions.length; i += batchSize) {
      const batch = db.batch();
      const batchQuestions = questions.slice(i, i + batchSize);

      for (const question of batchQuestions) {
        const { id, ...questionData } = question;
        const docRef = db.collection('questions').doc(id);
        batch.set(docRef, questionData);
        console.log(`  ✓ ${id} 준비 완료`);
      }

      await batch.commit();
      console.log(`✅ 배치 ${Math.floor(i / batchSize) + 1} 완료 (${batchQuestions.length}개 문서)\n`);
    }

    console.log(`🎉 총 ${questions.length}개 질문 입력 완료!`);
    process.exit(0);
  } catch (error) {
    console.error('❌ 오류 발생:', error.message);
    process.exit(1);
  }
}

importQuestions();

