-- 服务器基本信息
SELECT CONCAT(
  '### 服务器基本信息', CHAR(10),
  '- MySQL 版本: `', VERSION(), '`', CHAR(10),
  '- InnoDB 版本: `', @@innodb_version, '`', CHAR(10),
  '- 数据库位置: `', @@datadir, '`'
) AS '';

-- 数据库名称及占用空间大小
SELECT '- 数据库名称及占用空间大小' AS '';
SELECT CONCAT(
  '   - ', RPAD(CONCAT('`', table_schema, '`'), 36, ' '),
  ': ', LPAD(ROUND(SUM(data_length + index_length) / 1024 / 1024, 3), 16, ' '), ' MB'
) AS ''
FROM information_schema.tables
GROUP BY table_schema
ORDER BY table_schema;

-- 缓冲区和缓存相关参数
SELECT CONCAT(
  '### 缓冲区和缓存相关参数', CHAR(10),
  '- **`innodb_buffer_pool_size`**: 控制 InnoDB 缓冲池的大小, 用于缓存数据和索引. 推荐设置为服务器物理内存的 70%-80%, 以确保数据和索引能够尽可能多地缓存在内存中, 减少磁盘 I/O. ', CHAR(10),
  '   - innodb_buffer_pool_size=`', @@innodb_buffer_pool_size, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_log_buffer_size`**: 控制 InnoDB 日志缓冲区的大小. 适当增大可以减少日志写入磁盘的频率, 提升性能, 通常设置为 64MB. ', CHAR(10),
  '   - innodb_log_buffer_size=`', @@innodb_log_buffer_size, '`'
) AS '';
SELECT CONCAT(
  '- **`tmp_table_size` 和 `max_heap_table_size`**: 控制内存中临时表的大小. 如果临时表过大, MySQL 会将其写入磁盘, 从而影响性能. 根据应用需求适当增大这两个参数. ', CHAR(10),
  '   - tmp_table_size=`', @@tmp_table_size, '`', CHAR(10),
  '   - max_heap_table_size=`', @@max_heap_table_size, '`'
) AS '';

-- 连接和线程相关参数
SELECT CONCAT(
  '### 连接和线程相关参数', CHAR(10),
  '- **`max_connections`**: 设置 MySQL 服务器允许的最大并发连接数. 根据应用的并发连接需求和硬件资源进行调整. ', CHAR(10),
  '   - max_connections=`', @@max_connections, '`'
) AS '';
SELECT CONCAT(
  '- **`thread_cache_size`**: 控制线程缓存的大小, 减少线程创建和销毁的开销. 根据应用的并发需求设置适当大小. ', CHAR(10),
  '   - thread_cache_size=`', @@thread_cache_size, '`'
) AS '';
SELECT CONCAT(
  '- **`wait_timeout` 和 `interactive_timeout`**: 设置非交互式和交互式连接的超时时间. 适当减小这些值可以避免过多的空闲连接占用资源. ', CHAR(10),
  '   - wait_timeout=`', @@wait_timeout, '`', CHAR(10),
  '   - interactive_timeout=`', @@interactive_timeout, '`'
) AS '';

-- InnoDB 存储引擎相关参数
SELECT CONCAT(
  '### InnoDB 存储引擎相关参数', CHAR(10),
  '- **`innodb_flush_log_at_trx_commit`**: 控制事务提交时 InnoDB 刷新日志到磁盘的策略. 设置为 1 时最安全, 但性能较差；设置为 2 时, 性能和数据安全之间取得平衡. ', CHAR(10),
  '   - innodb_flush_log_at_trx_commit=`', @@innodb_flush_log_at_trx_commit, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_file_per_table`**: 每个 InnoDB 表使用独立的表空间文件. 开启此选项有助于管理表的大小和碎片化. ', CHAR(10),
  '   - innodb_file_per_table=`', @@innodb_file_per_table, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_flush_method`**: 控制 InnoDB 刷新数据和日志文件的方法. 对于大多数现代操作系统, 使用 O_DIRECT 可以提升性能. ', CHAR(10),
  '   - innodb_flush_method=`', @@innodb_flush_method, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_io_capacity` 和 `innodb_io_capacity_max`**: 控制 InnoDB 的 I/O 能力. 根据硬件类型和性能需求进行调整. ', CHAR(10),
  '   - innodb_io_capacity=`', @@innodb_io_capacity, '`', CHAR(10),
  '   - innodb_io_capacity_max=`', @@innodb_io_capacity_max, '`'
) AS '';

-- 查询优化相关参数
SELECT CONCAT(
  '### 查询优化相关参数', CHAR(10),
  '- **`join_buffer_size`**: 控制连接操作的缓冲区大小, 每个线程独占. 适当增大可以提升多表连接查询的性能. ', CHAR(10),
  '   - join_buffer_size=`', @@join_buffer_size, '`'
) AS '';
SELECT CONCAT(
  '- **`sort_buffer_size`**: 控制排序操作的缓冲区大小, 每个线程独占. 适当增大可以提升排序查询的性能. ', CHAR(10),
  '   - sort_buffer_size=`', @@sort_buffer_size, '`'
) AS '';

-- 日志相关参数
SELECT CONCAT(
  '### 日志相关参数', CHAR(10),
  '- **`slow_query_log` 和 `long_query_time`**: 开启慢查询日志, 记录执行时间超过指定阈值的查询. 通过分析慢查询日志可以发现性能瓶颈. ', CHAR(10),
  '   - slow_query_log=`', @@slow_query_log, '`', CHAR(10),
  '   - long_query_time=`', @@long_query_time, '`'
) AS '';
SELECT CONCAT(
  '- **`sync_binlog`**: 控制事务提交时同步二进制日志到磁盘的行为. 设置为 1 时, 确保每次事务提交后立即同步. ', CHAR(10),
  '   - sync_binlog=`', @@sync_binlog, '`'
) AS '';

-- 表和文件缓存相关参数
SELECT CONCAT(
  '### 表和文件缓存相关参数', CHAR(10),
  '- **`table_open_cache` 和 `table_definition_cache`**: 控制表缓存和表定义缓存的大小, 减少表打开和关闭的开销. 根据系统打开的表数量和需求进行调整. ', CHAR(10),
  '   - table_open_cache=`', @@table_open_cache, '`', CHAR(10),
  '   - table_definition_cache=`', @@table_definition_cache, '`'
) AS '';

-- 事务和并发控制
SELECT CONCAT(
  '### 事务和并发控制', CHAR(10),
  '- **`transaction_isolation`**: 设置事务的隔离级别, 控制事务之间的可见性. 常见的隔离级别包括 `READ UNCOMMITTED`、`READ COMMITTED`、`REPEATABLE READ`(默认值)和 `SERIALIZABLE`. 根据应用需求选择合适的隔离级别, 以平衡性能和数据一致性. ', CHAR(10),
  '   - transaction_isolation=`', @@transaction_isolation, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_lock_wait_timeout`**: 控制一个事务等待锁的最大时间. 如果设置过低, 可能会导致大量事务因等待锁超时而失败；如果设置过高, 可能会导致系统响应变慢. 默认值通常是 50 秒, 可以根据应用需求调整. ', CHAR(10),
  '   - innodb_lock_wait_timeout=`', @@innodb_lock_wait_timeout, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_thread_concurrency`**: 控制 InnoDB 的线程并发数. 设置为 0(默认值)时, InnoDB 会自动调整线程并发数. 如果需要手动限制并发线程数, 可以根据服务器的 CPU 核心数进行调整. ', CHAR(10),
  '   - innodb_thread_concurrency=`', @@innodb_thread_concurrency, '`'
) AS '';

-- 内存和资源管理
SELECT CONCAT(
  '### 内存和资源管理', CHAR(10),
  '- **`innodb_buffer_pool_instances`**: 控制 InnoDB 缓冲池的实例数量. 默认值为 8, 可以根据服务器的 CPU 核心数和内存大小进行调整. 增加实例数量可以减少锁争用, 但会增加内存开销. ', CHAR(10),
  '   - innodb_buffer_pool_instances=`', @@innodb_buffer_pool_instances, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_log_file_size`**: 控制 InnoDB 日志文件的大小. 较大的日志文件可以减少日志切换的频率, 从而提升性能, 但也会增加恢复时间. 建议设置为 128MB 或更大. ', CHAR(10),
  '   - innodb_log_file_size=`', @@innodb_log_file_size, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_log_files_in_group`**: 控制日志文件组的数量. 默认值为 2, 可以根据需求调整, 但通常不需要设置过高. ', CHAR(10),
  '   - innodb_log_files_in_group=`', @@innodb_log_files_in_group, '`'
) AS '';

-- 复制和高可用性
SELECT CONCAT(
  '### 复制和高可用性', CHAR(10),
  '- **`binlog_format`**: 设置二进制日志的格式, 包括 `STATEMENT`、`ROW` 和 `MIXED`. `ROW` 格式更安全, 但可能会增加日志大小；`STATEMENT` 格式更节省空间, 但可能会导致某些问题. `MIXED` 格式会根据情况自动选择. ', CHAR(10),
  '   - binlog_format=`', @@binlog_format, '`'
) AS '';
SELECT CONCAT(
  '- **`gtid_mode`**: 控制是否启用全局事务标识符(GTID). 启用 GTID 可以简化复制的管理和故障转移, 但需要确保主从服务器的版本支持 GTID. ', CHAR(10),
  '   - gtid_mode=`', @@gtid_mode, '`'
) AS '';

-- 安全和权限
SELECT CONCAT(
  '### 安全和权限', CHAR(10),
  '- **`sql_mode`**: 设置 SQL 模式, 控制 MySQL 的行为. 例如, `STRICT_TRANS_TABLES` 和 `ONLY_FULL_GROUP_BY` 等模式可以防止某些不安全的 SQL 语句执行. ', CHAR(10),
  '   - sql_mode=`', @@sql_mode, '`'
) AS '';
SELECT CONCAT(
  '- **`max_allowed_packet`**: 设置允许的最大数据包大小. 如果应用中需要传输较大的数据(如大文本或大二进制数据), 需要适当增大此值. ', CHAR(10),
  '   - max_allowed_packet=`', @@max_allowed_packet, '`'
) AS '';
SELECT CONCAT(
  '- **`secure_file_priv`**: 限制 `LOAD DATA INFILE` 和 `SELECT ... INTO OUTFILE` 的文件路径, 增强安全性. ', CHAR(10),
  '   - secure_file_priv=`', @@secure_file_priv, '`'
) AS '';

-- 其他重要参数
SELECT CONCAT(
  '### 其他重要参数', CHAR(10),
  '- **`skip_name_resolve`**: 禁用主机名解析, 直接使用 IP 地址. 可以减少 DNS 解析的开销, 提升性能. ', CHAR(10),
  '   - skip_name_resolve=`', @@skip_name_resolve, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_autoinc_lock_mode`**: 控制自增列的锁模式. 默认值为 1(连续模式), 适用于大多数场景. 如果应用中存在高并发的自增列插入操作, 可以考虑设置为 2(无锁模式). ', CHAR(10),
  '   - innodb_autoinc_lock_mode=`', @@innodb_autoinc_lock_mode, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_read_io_threads` 和 `innodb_write_io_threads`**: 控制 InnoDB 的读写 I/O 线程数量. 默认值为 4, 可以根据服务器的磁盘 I/O 性能进行调整. ', CHAR(10),
  '   - innodb_read_io_threads=`', @@innodb_read_io_threads, '`', CHAR(10),
  '   - innodb_write_io_threads=`', @@innodb_write_io_threads, '`'
) AS '';

-- 监控和调试
SELECT CONCAT(
  '### 监控和调试', CHAR(10),
  '- **`performance_schema`**: 启用性能模式, 用于监控数据库的性能. 虽然会增加一定的性能开销, 但可以帮助诊断性能问题. ', CHAR(10),
  '   - performance_schema=`', @@performance_schema, '`'
) AS '';
SELECT CONCAT(
  '- **`innodb_print_all_deadlocks`**: 启用此参数后, InnoDB 会将所有死锁事件记录到错误日志中, 便于分析死锁原因. ', CHAR(10),
  '   - innodb_print_all_deadlocks=`', @@innodb_print_all_deadlocks, '`'
) AS '';
