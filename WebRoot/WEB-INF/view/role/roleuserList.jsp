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
    <title>角色用户列表</title>
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
			$('#roleuserTable').datagrid({
				title:'角色成员列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/role/getAddedUserList.action?id=${roleid}", //数据来源
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
					text:'新增成员',
					iconCls:'icon-add',
					handler:function(){
						initaddMember();
					}
				},'-',{
					text:'删除成员',
					iconCls:'icon-cancel',
					handler:function(){
						deleteMember();
					}
				}],
				onLoadSuccess:function(){
					$('#roleuserTable').datagrid('clearSelections');
				}
			});
			
		});
		
		//清空查询条件
		function clearForm(){
			$('#queryForm').form('clear');
			searchMembers();
		}
		
		//刷新列表
		function searchMembers(){
			var params = $('#roleuserTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
			var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
			$.each( fields, function(i, field){
				params[field.name] = field.value; //设置查询参数
			});
			$('#roleuserTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
		}
		
		//添加成员
		function initaddMember(){
			$('#dialog').dialog({
			    title: '添加成员角色',
			    width: 800,
			    height: 500,
			    closed: false,
			    cache: false,
			    href: '<%=request.getContextPath()%>/role/initUnaddedUserPage.action?roleid=${roleid}',
			    modal: true
			});
		}
		
		//删除成员
		function deleteMember(){
			var rows = $('#roleuserTable').datagrid('getSelections');
			if(rows.length==0){
				$.messager.alert('提示',"请选择你要删除的角色",'info');
				return;
			}
		    var rows = $('#roleuserTable').datagrid('getSelections');
	       	var ps = "";
	       	$.each(rows,function(i,n){
	       		ps+=n.id+",";
	       	});
	       	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	       	$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	       		if (result){
	       			$.ajax({
	       				url:'<%=request.getContextPath()%>/role/deleteRoleMember.action?roleid=${roleid}&userids='+ps,
                        asysc:false,
                        type:'POST',
                        success:function(data){
			 				$.messager.alert('提示',data,'info');
			       		}
	       			});
			       	searchMembers();
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
  				<td align="left" width="20%"><input type="text" name="username" id="name"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchMembers()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="roleuserTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
