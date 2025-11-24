#!/usr/bin/env python3
"""
Firestore 데이터 자동 입력 스크립트 (Python)
사용법: python3 scripts/import_firestore_python.py
"""

import json
import sys
from pathlib import Path

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
except ImportError:
    print("❌ firebase-admin 패키지가 필요합니다.")
    print("설치: pip install firebase-admin")
    sys.exit(1)

def import_data():
    # Firebase Admin SDK 초기화
    # 서비스 계정 키 파일이 필요합니다
    service_account_path = Path(__file__).parent.parent / 'serviceAccountKey.json'
    
    if not service_account_path.exists():
        print(f"❌ 서비스 계정 키 파일을 찾을 수 없습니다: {service_account_path}")
        print("Firebase Console → 프로젝트 설정 → 서비스 계정 → 새 비공개 키 생성")
        sys.exit(1)
    
    cred = credentials.Certificate(str(service_account_path))
    firebase_admin.initialize_app(cred)
    
    db = firestore.client()
    
    # firestore_data.json 파일 읽기
    data_path = Path(__file__).parent.parent / 'firestore_data.json'
    
    with open(data_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    print('🚀 Firestore 데이터 입력 시작...\n')
    
    # 1. questions 컬렉션 입력
    if 'questions' in data and isinstance(data['questions'], list):
        print('📝 questions 컬렉션 입력 중...')
        batch = db.batch()
        
        for question in data['questions']:
            doc_id = question.pop('id')  # id를 문서 ID로 사용
            doc_ref = db.collection('questions').document(doc_id)
            batch.set(doc_ref, question)
        
        batch.commit()
        print(f"✅ {len(data['questions'])}개 질문 입력 완료\n")
    
    # 2. types 컬렉션 입력
    if 'types' in data and isinstance(data['types'], dict):
        print('🎯 types 컬렉션 입력 중...')
        batch = db.batch()
        count = 0
        
        for code, type_data in data['types'].items():
            doc_ref = db.collection('types').document(code)
            batch.set(doc_ref, type_data)
            count += 1
        
        batch.commit()
        print(f"✅ {count}개 유형 입력 완료\n")
    
    print('🎉 모든 데이터 입력 완료!')

if __name__ == '__main__':
    try:
        import_data()
    except Exception as e:
        print(f'❌ 오류 발생: {e}')
        sys.exit(1)

