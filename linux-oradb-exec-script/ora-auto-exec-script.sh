#! /bin/bash -l

echo '*********************************************************************************************************'
echo '**************************************Oracle Automatic execution script**********************************'
echo '*********************************************************************************************************'
echo '*******************************Please input basic information.Execute SQL script：***********************'
echo '*********************************************************************************************************'

#----------------------------------------------------------------
#------------------------基础配置开始----------------------------
#----------------------------------------------------------------
#当前操作用户IP
userIp=$(who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g')
#系统日期-年月日
dbdate=$(date +%Y%m%d)
#系统时间-时分秒
dbtime=$(date +%H%M%S)
#分隔符
sep='/'
currentDir='./'
uplevelDir='../'
#当前脚本所在基础路径
basicPath=$(pwd)
#基础路径下二级文件夹扫描
dbscript='dboracle'
#----------------------------------------------------------------
#----------------------基础参数默认值设置------------------------
#----------------------------------------------------------------
#数据库ip地址,默认值：127.0.0.1
dbIpAddr='127.0.0.1'
#数据库端口号,默认值：1521
dbPort='1521'
#数据库实例,默认值：orcl
dbInstance='orcl'
#数据库用户名,默认值：utest
dbUserName='utest'
#数据库密码,默认值：utest
dbPassWord='utest'

#----------------------------------------------------------------
#-----------------------手动输入连接参数-------------------------
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
#------------------------执行文件指定开始------------------------
#----------------------------------------------------------------
#脚本执行指定 1 2 3 4 5 分别执行不同的三级文件夹扫描
#./test.sh 6 sqlfile.sql
filesDirName='unspecified'
#输入指令
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
		echo '--------TIPS:No parameters specified，Refer to instructions for use---------'
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
#-------------------------=日志配置开始--------------------------
#----------------------------------------------------------------
#日志文件夹名称
logsfile='logs'
#日志基础路径
logBasicPath=${basicPath}${sep}${logsfile}${sep}${dbdate}${sep}${userIp}
if [ ! -d "${logBasicPath}" ]; then
  mkdir -p ${logBasicPath}
fi

#执行SQL文件日志名称
logFileNameSQL=${filesDirName}'_sql'.log
#操作脚本日志名称
operationLogFileName=${filesDirName}'_operation'.log
#全部操作日志
operationLogAllName=operation_all.log

#日志存储路径
logsPath=${logBasicPath}${sep}${dbtime}'_'${filesDirName}
#判断日志存储路径是否存在，不存在则创建
if [ ! -d "${logsPath}" ]; then
  mkdir -p ${logsPath}
fi
#执行SQL日志
execLogSQL=${logsPath}${sep}${logFileNameSQL}
#操作脚本日志
operationLog=${logsPath}${sep}${operationLogFileName}
#全部操作日志
operationLogAll=${logBasicPath}${sep}${operationLogAllName}


#----------------------------------------------------------------
#------------------------脚本文件构造开始------------------------
#----------------------------------------------------------------
#脚本扫描文件夹指定
findExecSQLScriptPath=${basicPath}${sep}${dbscript}${sep}${filesDirName}
echo 'Scan specified folder '${findExecSQLScriptPath}

if [ "${inputInstruction}" = 6 ];then
	scriptPath=${inputOneSQLFile}
else

	#指定构造sql文件
	buildName=build.sql
	#build脚本全路径
	scriptPath=${logsPath}${sep}${buildName}
	#如果存在构造后的文件则删除此文件
	if [ ! -f "${scriptPath}" ]; then
	  rm -rf ${scriptPath}
	fi

	#构造build.sql文件，将所有扫描到的SQL写入此文件
	find ${findExecSQLScriptPath} -type f -iname '*.sql' \
	! -iname 'build.sql' \
	-exec echo 'start '{} \; >> ${scriptPath}
	echo 'Build script completion '${scriptPath}
fi



#---------------------------------------------------------------
#------------------------执行SQL文件----------------------------
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
#oracle 连接dbuser/dbpwd@127.0.0.1:1521/orcl
conn=${dbUserName}${sep}${dbPassWord}@${dbIpAddr}:${dbPort}${sep}${dbInstance}; >> ${execLogSQL}
echo 'dbConn      :'${conn}>>${operationLog}

#关键脚本调试打印控制台
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

#执行脚本是出错，对未提交的数据进行回滚处理并退出
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

#将日志路径输出
	echo 'Execute SQL Log   :'${execLogSQL} 
	echo 'Operation Log     :'${operationLog}
	echo 'Operation Log All :'${operationLogAll}
}
main $*

#将当前用户所有操作日志，写入一个文件
$(cat ${operationLog} >> ${operationLogAll})
