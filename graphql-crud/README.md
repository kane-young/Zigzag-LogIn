GraphQL을 이해하고 사용할 수 있는지 확인하는 과제입니다.

GraphQL API를 사용한 간단한 CRUD 애플리케이션을 작성하시면 됩니다.

# 요구사항
* 기본 화면은 상품 목록 화면입니다.
    * product\_list Query API를 사용합니다.
    * 목록에서는 ID, 한국어 상품명, 영어 상품명, 가격, 공급사를 표시합니다.
* 상품 목록 화면에서 상품 추가 버튼을 눌러 상품을 추가할 수 있습니다.
    * createProduct Mutation API를 사용합니다.
    * 한국어 상품명, 가격, 공급사만 입력받아서 추가합니다.
    * 공급사는 supplier\_list Query API를 통해 목록을 가져와 선택할 수 있게 하면 됩니다.
* 상품 목록 화면에서 상품을 클릭해 상품 정보 화면으로 진입할 수 있습니다.
    * product Query API를 사용합니다.
    * 한국어/영어 상품명, 요약설명, 가격, 공급사를 표시합니다.
* 상품 정보 화면에서 상품을 삭제할 수 있습니다. 삭제시 목록으로 돌아갑니다.
    * deleteProduct Mutation API를 사용합니다.
* (선택사항) 상품 정보 화면에서 상품을 수정할 수 있습니다.
    * 정보 화면에서 직접 수정하게 해도 되고, 별로 화면으로 구성해도 됩니다.
    * updateProduct Mutation API를 사용합니다.
    * 상품 정보 저장에 성공하면 상품 정보 화면으로 돌아가 바뀐 내용을 표시합니다.

# GraphQL API 사용 방법
* 과제에 필요한 GraphQL API는 http://test.recruit.croquis.com:28500/ 주소에서 제공합니다.
* 작업자 별로 다른 데이터 제공을 위해 식별자를 인자로 요구합니다. UUID 형태의 36자 문자열을 Croquis-UUID 헤더에 담아 호출하면 됩니다.
    ```
    $ curl http://test.recruit.croquis.com:28500/ -H 'Croquis-UUID: 00000000-0000-0000-0000-000000000000' -X POST -H "Content-Type: application/json" --data '{ "query": "{ supplier_list { item_list { id name } } } "}'
    {"data":{"supplier_list":{"item_list":[{"id":"1","name":"크로키"},{"id":"2","name":"지그재그"},{"id":"3","name":"니케"},{"id":"4","name":"언발란스"}]}},"extensions":{}}
    ```
    * 주의: 작성한 애플리케이션에서 '00000000-0000-0000-0000-000000000000'를 UUID로 사용하지 마세요.
* GraphQL 스키마는 첨부된 schema.graphql 파일을 참고하면 됩니다.

# 평가기준
* 기능 완성도
* UI는 평가하지 않습니다
* 코드 구성 / 코드 가독성 (불필요한 주석은 없는 것을 선호합니다)
