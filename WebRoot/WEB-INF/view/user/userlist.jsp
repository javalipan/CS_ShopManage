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
    <title>用户管理</title>
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
			$('#userTable').datagrid({
				title:'用户列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/user/searchUsers.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'name',title:'姓名',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'loginname',title:'登录名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.loginname;} //需要formatter一下才能显示正确的数据
					},
					{field:'mobilephone',title:'手机号',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.mobilephone;
						}
					},
					{field:'microletter',title:'微信号',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.microletter;
						}
					},
					{field:'type',title:'类型',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.type=='2'){
								return "普通用户";
							}
							else{
								return "管理员";
							}
						}
					},
					{field:'status',title:'状态',sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.status=='0'){
								return "正常";
							}
							else{
								return "禁用";
							}
						}
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addUser();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateUser();
					}
				},'-',{
					text:'启用/禁用',
					iconCls:'icon-edit',
					handler:function(){
						changeStatus();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteUser();
					}
				},'-',{
					text:'重置密码',
					iconCls:'icon-pwd',
					handler:function(){
						modifyPass();
					}
				},'-'],
				onLoadSuccess:function(){
					$('#userTable').datagrid('clearSelections');
				}
			});
			
		});
		
			//表格查询
	function searchUser(){
		var params = $('#userTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#userTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchUser();
	}
	
	//添加用户
	function addUser(){
		$('#dialog').dialog({
		    title: '新增用户',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/user/initUserEdit.action',
		    modal: true
		});
	}
	
	//修改用户
	function updateUser(){
		var rows = $('#userTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的用户",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位用户进行更新",'info');
			return;
		}
		var row=$('#userTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '修改用户',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/user/initUserEdit.action?id='+row.id,
		    modal: true
		});
	}
	
	//改变状态
	function changeStatus(){
		var rows = $('#userTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的用户",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位用户进行更新",'info');
			return;
		}
		var row=$('#userTable').datagrid('getSelected');
  		$.messager.confirm('提示','确定要修改吗?',function(result){
	        if (result){
	        	$.post('<%=request.getContextPath()%>/user/changeStatus.action?id='+row.id,function(data){
		        	$('#userTable').datagrid('load'); 
    				searchUser();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//删除用户
	function deleteUser(){
		var rows = $('#userTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的用户",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#userTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/user/deleteUser.action?ids='+ps,function(data){
		        	$('#userTable').datagrid('load'); 
    				searchUser();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//重置密码
	function modifyPass(){
		var rows = $('#userTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要重置密码的用户",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位用户进行重置",'info');
			return;
		}
		var row=$('#userTable').datagrid('getSelected');
  		$.messager.confirm('提示','确定要重置吗?',function(result){
	        if (result){
	        	$.post('<%=request.getContextPath()%>/user/resetPassword.action?id='+row.id,function(data){
		        	$('#userTable').datagrid('load'); 
    				searchUser();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">用户名称:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  				<td align="right" width="10%">登录名:</td>
  				<td align="left" width="20%"><input type="text" name="loginname" id="loginname"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchUser()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="userTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
