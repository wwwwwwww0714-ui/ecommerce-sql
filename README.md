# 电商经营分析驾驶舱（SQL + 前端页面）

这是一个用于电商数据运营面试作品集的演示项目。所有数据均为合成模拟数据，不代表真实企业经营结果。

## 项目组成
- `ecommerce_data_operations_sql_project.sql`：创建 MySQL 数据库、数据表、模拟数据及 SQL 分析查询。
- `app.py`：Streamlit 前端页面，可连接 MySQL 并展示经营指标、销售趋势、渠道漏斗、广告 ROAS、商品估算毛利和用户复购情况。
- `requirements.txt`：Python 依赖。

## 运行步骤

### 1. 初始化数据库
1. 安装并启动 MySQL 8.0+。
2. 使用 MySQL Workbench 或 DBeaver 打开 `ecommerce_data_operations_sql_project.sql`。
3. 执行整个脚本，创建 `ecommerce_ops` 数据库及示例数据。

### 2. 安装 Python 依赖
在项目文件夹的终端运行：
```bash
python -m pip install -r requirements.txt
```

### 3. 启动前端
```bash
python -m streamlit run app.py
```
浏览器打开终端提示的本地地址（通常是 `http://localhost:8501`）。

### 4. 连接数据库
在左侧边栏填写 MySQL 主机、端口、数据库名、用户名和密码。默认数据库名为 `ecommerce_ops`，主机为 `127.0.0.1`，端口为 `3306`，用户名默认 `root`。
如果你本机数据库使用其他账号或端口，请按实际情况填写。

## 面试讲解建议
1. SQL 层负责多表关联、指标聚合、趋势计算和业务口径定义。
2. Streamlit 层负责将查询结果呈现为可交互的经营看板。
3. 通过销售趋势、渠道效率、商品毛利和用户复购分析提出排查方向。
4. 强调这是模拟数据项目，不要将模拟结果描述为真实企业业绩。

## 口径提醒
- 有效订单口径：`paid` 和 `completed`。
- 净销售额：有效订单的 `pay_amount - refund_amount`。
- ROAS：渠道归因销售额 / 广告花费。
- 商品估算毛利：商品明细金额减去商品数量乘以商品单位成本；未扣除平台佣金、履约及其他费用。
- 异常规则是排查线索，不代表统计显著性或因果结论。
