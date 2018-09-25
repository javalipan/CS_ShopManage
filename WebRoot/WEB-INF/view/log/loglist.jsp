<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>日志管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#logTable').datagrid({
				title:'角色列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/log/searchLog.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'name',title:'操作人',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.username;}
					},
					{field:'time',title:'操作时间',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.operatetime);} //需要formatter一下才能显示正确的数据
					},
					{field:'logtype',title:'日志类型',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.logtype=='0'){
								return "登录日志";
							}
							else if(row.logtype=='1'){
								return "操作日志";
							}
						}
					},
					{field:'operatetype',title:'操作类型',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.operatetype=='0'){
								return "添加";
							}
							else if(row.operatetype=='1'){
								return "删除";
							}
							else if(row.operatetype=='2'){
								return "修改";
							}
							else if(row.operatetype=='3'){
								return "登录";
							}
						}
					},
					{field:'ipaddress',title:'IP',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.ipaddress);} //需要formatter一下才能显示正确的数据
					},
					{field:'content',title:'内容',width:90,sortable:false,align:'left',
						formatter:function(value,row,index){return formattime(row.content);} //需要formatter一下才能显示正确的数据
					}
				]],
				toolbar:[],
				onLoadSuccess:function(){
					$('#logTable').datagrid('clearSelections');
				}
			});
			
		});
		
			//表格查询
	function searchRole(){
		var params = $('#logTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#logTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchRole();
	}
	
	function formattime(val) {
		if(val==null) return "";
		if(typeof val=="string") return val;
		var year=parseInt(val.year)+1900;
		var month=(parseInt(val.month)+1);
		month=month>9?month:('0'+month);
		var date=parseInt(val.date);
		date=date>9?date:('0'+date);
		var hours=parseInt(val.hours);
		hours=hours>9?hours:('0'+hours);
		var minutes=parseInt(val.minutes);
		minutes=minutes>9?minutes:('0'+minutes);
		var seconds=parseInt(val.seconds);
		seconds=seconds>9?seconds:('0'+seconds);
		var time=year+'-'+month+'-'+date+' '+hours+':'+minutes+':'+seconds;
		return time;
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">用户:</td>
  				<td align="left" width="15%"><input type="text" name="username" id="username"/></td>
  				<td align="right" width="10%">时间大于:</td>
  				<td align="left" width="15%"><input type="text" class="easyui-datebox" editable="fasle" name="starttime" id="starttime"/></td>
  				<td align="right" width="10%">时间小于:</td>
  				<td align="left" width="15%"><input type="text" class="easyui-datebox" editable="fasle" name="endtime" id="endtime"/></td>
  				<td width="25%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchRole()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="logTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
