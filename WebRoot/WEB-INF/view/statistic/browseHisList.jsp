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
    <title>商品浏览记录管理</title>
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
			$('#hisTable').datagrid({
				title:'商品浏览记录列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/statistic/browse/getBrowseHisData.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'membernickname',title:'会员昵称',width:60,sortable:false,align:'center'},
					{field:'phone',title:'手机号',width:60,sortable:false,align:'center'},
					{field:'name',title:'商品名称',width:60,sortable:false,align:'center'},
					{field:'ipaddr',title:'ip地址',width:60,sortable:false,align:'center'},
					{field:'browsetime',title:'时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formattime(row.browsetime);
						} 
					}
				]],
				onLoadSuccess:function(){
					$('#hisTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchMenu(){
		var params = $('#hisTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#hisTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchMenu();
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">会员昵称:</td>
  				<td align="left" width="20%"><input type="text" name="membernickname" id="membernickname"/></td>
  				<td align="right" width="10%">会员电话:</td>
  				<td align="left" width="20%"><input type="text" name="phone" id="phone"/></td>
  				<td align="right" width="10%">商品名称:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  			</tr>
  			<tr>
  				<td align="right" width="10%">时间:</td>
  				<td align="left" width="40%" colspan="3">
  					<input type="text" class="easyui-datebox" name="startTime" id="startTime"/>-
  					<input type="text" class="easyui-datebox" name="endTime" id="endTime"/>
  				</td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchMenu()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="hisTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
