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
    <title>消息管理</title>
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
			$('#msgTable').datagrid({
				title:'消息列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/msg/searchMsg.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'title',title:'标题',width:60,sortable:false,align:'center'},
					{field:'msgtype',title:'消息类型',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.msgtype=="1"){
								return "文字消息";
							}
							else if(row.msgtype=="2"){
								return "图片消息";
							}
							else if(row.msgtype=="3"){
								return "视频消息";
							}
							else if(row.msgtype=="4"){
								return "小视频消息";
							}
							else if(row.msgtype=="5"){
								return "位置消息";
							}
							else if(row.msgtype=="6"){
								return "收到链接";
							}
							else if(row.msgtype=="7"){
								return "订阅";
							}
							else if(row.msgtype=="8"){
								return "取消订阅";
							}
							else if(row.msgtype=="9"){
								return "点击菜单";
							}
							else if(row.msgtype=="10"){
								return "点击链接菜单";
							}
						} 
					},
					{field:'picaddr',title:'图片',width:8,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.picaddr){
								return "<a href='"+row.picaddr+"' target='_blank'><img src='"+row.picaddr+"' width='20' height='20'/></a>";
							}
							else{
								return "";	
							}
						} 
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addMsg();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateMsg();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteMsg();
					}
				}],
				onLoadSuccess:function(){
					$('#msgTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchMsg(){
		var params = $('#msgTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#msgTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchMsg();
	}
	
	//添加消息
	function addMsg(){
		$('#dialog').dialog({
		    title: '新增消息',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/msg/initMsgEdit.action',
		    modal: true
		});
	}
	
	//修改消息
	function updateMsg(){
		var rows = $('#msgTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的消息",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一条消息进行更新",'info');
			return;
		}
		var row=$('#msgTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '修改消息',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/msg/initMsgEdit.action?id='+row.id,
		    modal: true
		});
	}
	
	//删除消息
	function deleteMsg(){
		var rows = $('#msgTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的消息",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#msgTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/msg/deleteMsg.action?ids='+ps,function(data){
		        	$('#msgTable').datagrid('load'); 
    				searchMsg();
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
  				<td align="right" width="10%">标题:</td>
  				<td align="left" width="20%"><input type="text" name="title" id="title"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchMsg()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="msgTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
