#! /bin/bash -l

echo '*********************************************************************************************************'
echo '**************************************Oracle Automatic execution script**********************************'
echo '*********************************************************************************************************'
echo '*******************************Please input basic information.Execute SQL script��***********************'
echo '*********************************************************************************************************'

#----------------------------------------------------------------
#------------------------�������ÿ�ʼ----------------------------
#----------------------------------------------------------------
#��ǰ�����û�IP
userIp=$(who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g')
#ϵͳ����-������
dbdate=$(date +%Y%m%d)
#ϵͳʱ��-ʱ����
dbtime=$(date +%H%M%S)
#�ָ���
sep='/'
currentDir='./'
uplevelDir='../'
#��ǰ�ű����ڻ���·��
basicPath=$(pwd)
#����·���¶����ļ���ɨ��
dbscript='dboracle'
#----------------------------------------------------------------
#----------------------��������Ĭ��ֵ����------------------------
#----------------------------------------------------------------
#���ݿ�ip��ַ,Ĭ��ֵ��127.0.0.1
dbIpAddr='127.0.0.1'
#���ݿ�˿ں�,Ĭ��ֵ��1521
dbPort='1521'
#���ݿ�ʵ��,Ĭ��ֵ��orcl
dbInstance='orcl'
#���ݿ��û���,Ĭ��ֵ��utest
dbUserName='utest'
#���ݿ�����,Ĭ��ֵ��utest
dbPassWord='utest'

#----------------------------------------------------------------
#-----------------------�ֶ��������Ӳ���-------------------------
#----------------------------------------------------------------
read -p 'please input database ipaddr   ...(enter key default :127.0.0.1):' idbIpAddr
dbIpAddr=${idbIpAddr:-${dbIpAddr}}
echo ${dbIpAddr}
read -p 'please input database port     ...(enter key default :1521):' idbPort
dbPort=${idbPort:-${dbPort}}
echo ${dbPort}
read -p 'please input database instance ...(enter key default :orcl):' idbInstance
dbInstance=${idbInstance:-${dbInstance}}
echo ${dbInstance}
read -p 'please input database username ...(enter key default :utest):' idbUserName
dbUserName=${idbUserName:-${dbUserName}}
echo ${dbUserName}
read -p 'please input database password ...(enter key default :utest):' idbPassWord
dbPassWord=${idbPassWord:-${dbPassWord}}
echo ${dbPassWord}
#----------------------------------------------------------------
#------------------------ִ���ļ�ָ����ʼ------------------------
#----------------------------------------------------------------
#�ű�ִ��ָ�� 1 2 3 4 5 �ֱ�ִ�в�ͬ�������ļ���ɨ��
#./test.sh 6 sqlfile.sql
filesDirName='unspecified'
#����ָ��
inputInstruction=$1
inputOneSQLFile=$2
case ${inputInstruction} in
	1)
		filesDirName='sequences'
		;;
	2)
		filesDirName='functions'
		;;
	3)
		filesDirName='tablestructure'
		;;
	4)
		filesDirName='tabledata'
		;;
	5)	
		filesDirName='views'
		;;
	6)  
		filesDirName='execsql'
		if [ -f "${inputOneSQLFile}" ] && [ "$(echo ${inputOneSQLFile##*.}|tr [A-Z] [a-z])"x = "sql"x ];then			
			echo ${inputOneSQLFile}
		else
			echo "Error: The specified file does not exist or is not a .SQL file."
			exit 1
		fi
		echo 'execute an sql'
		;;
	*)
		echo '----------------------------------------------------------------------------'
		echo '--------TIPS:No parameters specified��Refer to instructions for use---------'
		echo '----------------------------------------------------------------------------'
		echo 'Param 1: value1 --running sequences folder script'
		echo '--Examples: ./ora-auto-exec-script.sh 1'
		echo 'Param 2: value1 --running functions folder script'
		echo '--Examples: ./ora-auto-exec-script.sh 2'
		echo 'Param 3: value1 --running tablestructure folder script'
		echo '--Examples: ./ora-auto-exec-script.sh 3'
		echo 'Param 4: value1 --running tabledata folder script'
		echo '--Examples: ./ora-auto-exec-script.sh 4'
		echo 'Param 5: value1 --running views folder script'
		echo '--Examples: ./ora-auto-exec-script.sh 5'
		echo 'Param 6: value1 value2 --running one script file'
		echo '--Examples: ./ora-auto-exec-script.sh 6 /home/oracle/test.sql'
		echo '----------------------------------------------------------------------------'
		echo '----------------------------------------------------------------------------'
		
		exit 1
		;;
esac

#----------------------------------------------------------------
#-------------------------=��־���ÿ�ʼ--------------------------
#----------------------------------------------------------------
#��־�ļ�������
logsfile='logs'
#��־����·��
logBasicPath=${basicPath}${sep}${logsfile}${sep}${dbdate}${sep}${userIp}
if [ ! -d "${logBasicPath}" ]; then
  mkdir -p ${logBasicPath}
fi

#ִ��SQL�ļ���־����
logFileNameSQL=${filesDirName}'_sql'.log
#�����ű���־����
operationLogFileName=${filesDirName}'_operation'.log
#ȫ��������־
operationLogAllName=operation_all.log

#��־�洢·��
logsPath=${logBasicPath}${sep}${dbtime}'_'${filesDirName}
#�ж���־�洢·���Ƿ���ڣ��������򴴽�
if [ ! -d "${logsPath}" ]; then
  mkdir -p ${logsPath}
fi
#ִ��SQL��־
execLogSQL=${logsPath}${sep}${logFileNameSQL}
#�����ű���־
operationLog=${logsPath}${sep}${operationLogFileName}
#ȫ��������־
operationLogAll=${logBasicPath}${sep}${operationLogAllName}


#----------------------------------------------------------------
#------------------------�ű��ļ����쿪ʼ------------------------
#----------------------------------------------------------------
#�ű�ɨ���ļ���ָ��
findExecSQLScriptPath=${basicPath}${sep}${dbscript}${sep}${filesDirName}
echo 'Scan specified folder '${findExecSQLScriptPath}

if [ "${inputInstruction}" = 6 ];then
	scriptPath=${inputOneSQLFile}
else

	#ָ������sql�ļ�
	buildName=build.sql
	#build�ű�ȫ·��
	scriptPath=${logsPath}${sep}${buildName}
	#������ڹ������ļ���ɾ�����ļ�
	if [ ! -f "${scriptPath}" ]; then
	  rm -rf ${scriptPath}
	fi

	#����build.sql�ļ���������ɨ�赽��SQLд����ļ�
	find ${findExecSQLScriptPath} -type f -iname '*.sql' \
	! -iname 'build.sql' \
	-exec echo 'start '{} \; >> ${scriptPath}
	echo 'Build script completion '${scriptPath}
fi



#---------------------------------------------------------------
#------------------------ִ��SQL�ļ�----------------------------
#---------------------------------------------------------------
execute_data(){

echo 'dbUser      :'${dbUserName} >> ${operationLog}
echo 'dbPwd       :'${dbPassWord} >> ${operationLog}
echo 'dbIpAddr    :'${dbIpAddr} >> ${operationLog}
echo 'dbPort      :'${dbPort} >> ${operationLog}
echo 'dbInstance  :'${dbInstance} >> ${operationLog}
echo 'Instruction :'${inputInstruction}' - '${filesDirName} >> ${operationLog}
echo 'SQLFindPath :'${findExecSQLScriptPath} >>${operationLog}
echo 'buildURL    :'${scriptPath} >>${operationLog}
echo 'buildTotal  :'$(cat ${scriptPath}|wc -l)  >>${operationLog}
#oracle ����dbuser/dbpwd@127.0.0.1:1521/orcl
conn=${dbUserName}${sep}${dbPassWord}@${dbIpAddr}:${dbPort}${sep}${dbInstance}; >> ${execLogSQL}
echo 'dbConn      :'${conn}>>${operationLog}

#�ؼ��ű����Դ�ӡ����̨
set -x
sqlplus "${conn}" <<EOF
	set echo on;
	set define off;
	spool ${execLogSQL}; 
	show user;
		@${scriptPath}
	spool off;
EOF
set +x

#ִ�нű��ǳ�����δ�ύ�����ݽ��лع������˳�
#set -x
#sqlplus "${conn}" <<EOF
#	set echo on;
#	set define off;
#	spool ${execLogSQL}; 
#	show user;
#	WHENEVER SQLERROR SQL.SQLCODE EXIT ROLLBACK 
#		@${scriptPath}
#	exit;
#	spool off;
#EOF
#set +x

}

main(){

	echo '**********************************************************************************'>>${operationLog}
	echo '**********************************************************************************'>>${operationLog}
	echo '****************************** Execution SQL Script Start  ***********************'>>${operationLog}
	echo '***********************'${userIp}' '$(date "+%Y-%m-%d %H:%M:%S")' ***********************'>>${operationLog}
	echo '**********************************************************************************'>>${operationLog}
	echo 'Set NLS_LANG character set temporary variables:ZHS16GBK'
	export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
	echo 'Execute SQL Start ...'
	echo 'Execute SQL Script :'${scriptPath}	
	execute_data $*
	echo 'SQL Logs    :'${execLogSQL} >>${operationLog}
	echo 'OperationLog:'${operationLog}>>${operationLog}
	echo '**********************************************************************************'>>${operationLog}
	echo '**************** YSS-TA Execution SQL Script Completion... ***********************'>>${operationLog}
	echo '***********************'${userIp}' '$(date "+%Y-%m-%d %H:%M:%S")' ***********************'>>${operationLog}
	echo '**********************************************************************************'>>${operationLog}
	echo '**********************************************************************************'>>${operationLog}
	echo '-'>> ${operationLog}
	echo '-'>> ${operationLog}
	echo '-'>> ${operationLog}
	echo '-'>> ${operationLog}

#����־·�����
	echo 'Execute SQL Log   :'${execLogSQL} 
	echo 'Operation Log     :'${operationLog}
	echo 'Operation Log All :'${operationLogAll}
}
main $*

#����ǰ�û����в�����־��д��һ���ļ�
$(cat ${operationLog} >> ${operationLogAll})
