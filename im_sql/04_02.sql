create index idx_dept_name on department(dept_name);

show index from department;

#인덱스 만들기
# orders 테이블의 order_date 컬럼에 보조 인덱스 추가
CREATE INDEX idx_order_date ON orders(order_date);
SHOW INDEX FROM orders;

