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
    <title>角色管理</title>
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
			$('#roleTable').datagrid({
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
				url:"<%=request.getContextPath()%>/role/searchRoles.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'name',title:'角色名称',width:60,sortable:false,align:'left',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'typeName',title:'角色类型',width:60,sortable:false,align:'left',
						formatter:function(value,row,index){
							if(row.type=="1"){
								return "系统管理员";
							}
							else if(row.type=="2"){
								return "管理员";
							}
							else if(row.type=="3"){
								return "其他";
							}
						} //需要formatter一下才能显示正确的数据
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addRole();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateRole();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteRole();
					}
				},'-',{
					text:'成员设置',
					iconCls:'icon-users',
					handler:function(){
						setMember();
					}
				},'-',{
					text:'角色权限',
					iconCls:'icon-lock',
					handler:function(){
						setRolePermission();
					}
				}],
				onLoadSuccess:function(){
					$('#roleTable').datagrid('clearSelections');
				}
			});
			
		});
		
	function setMember(){
		var rows = $('#roleTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的角色",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位角色",'info');
			return;
		}
		var row=$('#roleTable').datagrid('getSelected');
		window.location.href="<%=request.getContextPath()%>/role/initRoleUserList.action?roleid="+row.id;
	}
	
	function setRolePermission(){
		var rows = $('#roleTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的角色",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位角色",'info');
			return;
		}
		var row=$('#roleTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '角色权限',
		    width: 600,
		    height: 500,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/role/initSetRolePermisstion.action?roleid='+row.id,
		    modal: true
		});
	}
		
			//表格查询
	function searchRole(){
		var params = $('#roleTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#roleTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchRole();
	}
	
	//添加角色
	function addRole(){
		$('#dialog').dialog({
		    title: '新增角色',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/role/initRoleEdit.action',
		    modal: true
		});
	}
	
	//修改角色
	function updateRole(){
		var rows = $('#roleTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的角色",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位角色进行更新",'info');
			return;
		}
		var row=$('#roleTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '修改角色',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/role/initRoleEdit.action?id='+row.id,
		    modal: true
		});
	}
	
	//删除角色
	function deleteRole(){
		var rows = $('#roleTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的角色",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#roleTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/role/deleteRole.action?ids='+ps,function(data){
		        	$('#roleTable').datagrid('load'); 
    				searchRole();
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
  				<td align="right" width="10%">角色名称:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchRole()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="roleTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
