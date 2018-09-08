# ʹ��˵����
## ע��
- ora-auto-exec-script.sh����ANSI���뱣�棬��༭���Դ��ַ����������˽ű��ϴ�Linux������
- ע��SQL�ű��ϴ�Linux�������Ƿ��������
- ������������ʵ��������н���ַ�������

## SQL�ű��������˵��

�ű�����·��./dbexecscript/������Ӧ�Ľű������Ӧ���ļ���
- ./dboracle/sequences
- ./dboracle/functions
- ./dboracle/tablestructure
- ./dboracle/tabledata
- ./dboracle/views
---

## �ű���Ȩ˵��

- �ű��ļ���Ҫ����ִ��Ȩ�ޣ�
- SQL�ű���Ҫ���пɶ�Ȩ�ޣ�
- ��־�ļ�����Ҫ���п�дȨ��

�������ű��ļ���Ȩ����:
```
chmod -R 755 dbexecscript/
```
---
## �ű�����˵��

- ִ�нű�:

```
./ora-auto-exec-script.sh ����1 
./ora-auto-exec-script.sh ����1 ����2
����1ֵ��1 2 3 4 5 6
����2ֵ��ָ��������.sql��β���ļ�
������ʾ������Ӧ��IP���˿ڡ�ʵ�����û���������
```

- ִ��˳��:

```
1.���У�sequences
2.������functions
3.�ṹ��tablestructure
4.���ݣ�tabledata
5.��ͼ��views
```
- �ű�����,�¼���ϸ˵��
- ���� 1: value1 -���� sequences �ļ�����SQL�ű�,ʾ��: 
```
./ora-auto-exec-script.sh 1
```

- ���� 2: value1 -���� functions �ļ�����SQL�ű�,ʾ��: 
```
./ora-auto-exec-script.sh 2
```

- ���� 3: value1  -���� tablestructure �ļ�����SQL�ű�,ʾ��: 
```
./ora-auto-exec-script.sh 3
```

- ���� 4: value1 -���� tabledata �ļ�����SQL�ű�,ʾ��: 
```
./ora-auto-exec-script.sh 4
```

- ���� 5: value1 -���� views �ļ�����SQL�ű�,ʾ��: 
```
./ora-auto-exec-script.sh 5
```

- ���� 6: value1 value2 -����ָ������SQL�ű��ļ�,ʾ��: 
```
./ora-auto-exec-script.sh 6 /home/oracle/test.sql
```
---