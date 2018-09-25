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
    <title>角色编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
	$(function(){
		//初始化表格
		$('#unaddtable').datagrid({
			title:'用户列表列表', //标题
			method:'post',
			iconCls:'icon-list', //图标
			singleSelect:false, //多选
			height:370, //高度
			nowrap: true,// True 就会把数据显示在一行里。
			autoRowHeight: false, // 自动调整行高
			fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
			striped: true, //奇偶行颜色不同
			collapsible:true,//可折叠
			url:"<%=request.getContextPath()%>/role/searchUnaddedUser.action?id=${roleid}", //数据来源
			remoteSort : false, //服务器端排序
			idField:'id', //主键字段
			queryParams:{}, //查询条件
			pagination:true, //显示分页
			rownumbers:true, //显示行号
			columns:[[
				{field:'ck',checkbox:true,width:2}, //显示复选框
				{field:'name',title:'姓名',width:60,sortable:false,align:'left',
					formatter:function(value,row,index){return row.name;}
				},
				{field:'loginname',title:'登录名',width:60,sortable:false,align:'left',
					formatter:function(value,row,index){return row.loginname;} //需要formatter一下才能显示正确的数据
				}
			]],
			toolbar:[{
				text:'添加',
				iconCls:'icon-add',
				handler:function(){
					addmember();
				}
			}],
			onLoadSuccess:function(){
				$('#roleuserTable').datagrid('clearSelections');
			}
		});
		
	});
	
	function addmember(){
		var rows = $('#unaddtable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的角色",'info');
			return;
		}
	    var rows = $('#unaddtable').datagrid('getSelections');
       	var ps = "";
       	$.each(rows,function(i,n){
       		ps+=n.id+",";
       	});
       	if(ps.length>0) ps=ps.substring(0,ps.length-1);
       	$.ajax({
			url:'<%=request.getContextPath()%>/role/addRoleMember.action?roleid=${roleid}&userids='+ps,
            asysc:false,
            type:'POST',
            success:function(data){
				$.messager.alert('提示',data,'info');
				$('#roleuserTable').datagrid('load');
				$('#dialog').dialog("close");
  			}
		});
	}
	
		//清空查询条件
	function clearForm2(){
		$('#queryForm2').form('clear');
		searchUser();
	}
		
	//刷新列表
	function searchUser(){
		var params = $('#unaddtable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm2').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#unaddtable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
	</script>
	<form action="" method="post" id="queryForm2">
    	<table border="0">
  			<tr>
  				<td align="right" width="10%">用户名称:</td>
  				<td align="left" width="20%"><input type="text" name="username" id="name"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm2()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchUser()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
	<div class="tableDiv" style="padding: 5px;">
  		<table id="unaddtable"></table>
  	</div>
  </body>
</html>
