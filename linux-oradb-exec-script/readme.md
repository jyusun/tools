# 使用说明：
## 注：
- ora-auto-exec-script.sh采用ANSI编码保存，如编辑请以此字符集保存避免此脚本上传Linux中乱码
- 注意SQL脚本上传Linux环境中是否出现乱码
- 如出现乱码根据实际情况自行解决字符集问题

## SQL脚本放入规则说明

脚本基础路径./dbexecscript/，将相应的脚本放入对应的文件夹
- ./dboracle/sequences
- ./dboracle/functions
- ./dboracle/tablestructure
- ./dboracle/tabledata
- ./dboracle/views
---

## 脚本授权说明

- 脚本文件需要具有执行权限，
- SQL脚本需要具有可读权限，
- 日志文件夹需要具有可写权限

对整个脚本文件授权即可:
```
chmod -R 755 dbexecscript/
```
---
## 脚本运行说明

- 执行脚本:

```
./ora-auto-exec-script.sh 参数1 
./ora-auto-exec-script.sh 参数1 参数2
参数1值：1 2 3 4 5 6
参数2值：指定单个以.sql结尾的文件
根据提示输入相应的IP、端口、实例、用户名、密码
```

- 执行顺序:

```
1.序列：sequences
2.函数：functions
3.结构：tablestructure
4.数据：tabledata
5.视图：views
```
- 脚本运行,下见详细说明
- 参数 1: value1 -运行 sequences 文件夹中SQL脚本,示例: 
```
./ora-auto-exec-script.sh 1
```

- 参数 2: value1 -运行 functions 文件夹中SQL脚本,示例: 
```
./ora-auto-exec-script.sh 2
```

- 参数 3: value1  -运行 tablestructure 文件夹中SQL脚本,示例: 
```
./ora-auto-exec-script.sh 3
```

- 参数 4: value1 -运行 tabledata 文件夹中SQL脚本,示例: 
```
./ora-auto-exec-script.sh 4
```

- 参数 5: value1 -运行 views 文件夹中SQL脚本,示例: 
```
./ora-auto-exec-script.sh 5
```

- 参数 6: value1 value2 -运行指定单个SQL脚本文件,示例: 
```
./ora-auto-exec-script.sh 6 /home/oracle/test.sql
```
---