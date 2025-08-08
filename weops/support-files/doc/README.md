## 嘉为蓝鲸RocketMQ插件使用说明

## 使用说明

### 插件功能
通过连接RocketMQ查询系统表，采集RocketMQ的运行状态、性能指标等信息，并将其转换为Prometheus格式。


### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

RocketMQ: 通用

**是否支持远程采集:**

是

### 参数说明


| **参数名**               | **含义**                             | **是否必填** | **使用举例**        |
|-----------------------|------------------------------------|----------|-----------------|
| --rocketmq.nameserver | RocketMQ服务地址                       | 是        | 127.0.0.1:9876  |

### 使用指引
请确保RocketMQ服务已启动，并可通过指定的 nameserver 地址访问。如果使用域名，请在 `/etc/hosts` 中配置对应的 IP 地址，因为监控探针无法直接解析域名。

### 指标简介
| **指标ID**                                         | **指标中文名**         | **维度ID**                                                     | **维度含义**                                             | **单位** | **指标类型** |
|--------------------------------------------------|-------------------|--------------------------------------------------------------|------------------------------------------------------|--------|----------|
| rocketmq_up                                      | 监控插件运行状态          | -                                                            | -                                                    | -      | gauge    |
| rocketmq_broker_tps                              | Broker每秒写入消息的数量   | broker, brokerIP, cluster                                    | Broker ID, Broker IP地址, 集群名称                         | -      | gauge    |
| rocketmq_broker_qps                              | Broker每秒处理的消息请求总量 | broker, brokerIP, cluster                                    | Broker ID, Broker IP地址, 集群名称                         | -      | gauge    |
| rocketmq_producer_message_size                   | 生产消息大小            | topic, broker, cluster                                       | 订阅主题, Broker ID, 集群名称                                | bytes  | gauge    |
| rocketmq_producer_offset                         | 生产偏移量             | broker, topic, cluster, lastUpdateTimestamp                  | Broker ID, 订阅主题, 集群名称, 最近更新时间戳                       | -      | gauge    |
| rocketmq_producer_tps                            | 生产者每秒写入消息的数量      | topic, broker, cluster                                       | 订阅主题, Broker ID, 集群名称                                | -      | gauge    |
| rocketmq_consumer_message_size                   | 消费消息大小            | broker, cluster, group, topic                                | Broker ID, 集群名称, 消费者组名称, 订阅主题                        | bytes  | gauge    |
| rocketmq_consumer_offset                         | 消费偏移量             | broker, cluster, group, topic                                | Broker ID, 集群名称, 消费者组名称, 订阅主题                        | -      | gauge    |
| rocketmq_consumer_tps                            | 消费者每秒消费消息的数量      | broker, cluster, group, topic                                | Broker ID, 集群名称, 消费者组名称, 订阅主题                        | -      | gauge    |
| rocketmq_group_count                             | 消费组数量             | caddr, group, localaddr, topic                               | 消费者客户端连接地址, 消费者组名称, Broker本地地址, 订阅主题                 | -      | gauge    |
| rocketmq_group_diff                              | 消费滞后量             | countOfOnlineConsumers, group, msgModel, topic               | 当前在线的消费者数量, 消费者组名称, 消息模式, 订阅主题                       | -      | gauge    |
| rocketmq_group_get_latency_by_storetime          | 按存储时间计算的消费延迟      | broker, cluster, group, topic                                | Broker ID, 集群名称, 消费者组名称, 订阅主题                        | ms     | gauge    |
| rocketmq_group_retrydiff                         | 重试积压数量            | countOfOnlineConsumers, group, msgModel, topic               | 在线的消费者数量, 消费者组名称, 消息模式, 订阅主题                         | -      | gauge    |
| rocketmq_brokeruntime_pmdt_0ms                   | 消息写入耗时0ms数量       | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_0to10ms               | 消息写入耗时0-10ms数量    | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_100to200ms            | 消息写入耗时100-200ms数量 | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_10stomore             | 消息写入耗时大于10s的数量    | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_10to50ms              | 消息写入耗时10-50ms数量   | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_1to2s                 | 消息写入耗时1-2s数量      | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_200to500ms            | 消息写入耗时200-500ms数量 | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_2to3s                 | 消息写入耗时2-3s数量      | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_3to4s                 | 消息写入耗时3-4s数量      | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_4to5s                 | 消息写入耗时4-5s数量      | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_500to1s               | 消息写入耗时500ms-1s数量  | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_50to100ms             | 消息写入耗时50-100ms数量  | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_pmdt_5to10s                | 消息写入耗时5-10s数量     | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_putmessage_entire_time_max | 最大写入耗时            | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | ms     | gauge    |
| rocketmq_client_consume_fail_msg_count           | 客户端消费失败消息数        | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | -      | gauge    |
| rocketmq_client_consume_fail_msg_tps             | 客户端消费失败TPS        | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | -      | gauge    |
| rocketmq_client_consume_ok_msg_tps               | 客户端消费成功TPS        | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | -      | gauge    |
| rocketmq_client_consume_rt                       | 客户端消费耗时           | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | ms     | gauge    |
| rocketmq_client_consumer_pull_rt                 | 客户端拉取耗时           | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | ms     | gauge    |
| rocketmq_client_consumer_pull_tps                | 客户端拉取TPS          | clientAddr, clientId, group, topic                           | 客户端地址, 客户端ID, 消费者组名称, 订阅主题                           | -      | gauge    |
| rocketmq_brokeruntime_putmessage_times_total     | 总写入次数             | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_remain_howmanydata_toflush | 剩余待刷写数据量          | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | -      | gauge    |
| rocketmq_brokeruntime_getmessage_entire_time_max | 获取消息最大耗时          | bootTime, brokerIP, brokerVersion, brokerVersionDes, cluster | Broker启动时间, Broker IP地址, Broker版本号, Broker版本描述, 集群名称 | ms     | gauge    |


### 版本日志

#### weops_RocketMQ_exporter v0.1.1

- weops调整



