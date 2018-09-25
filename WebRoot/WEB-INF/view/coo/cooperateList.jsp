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
    <title>联名合作管理</title>
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
			$('#cooperateTable').datagrid({
				title:'联名合作列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/coo/searchCooperate.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{programid:'${programid}'}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'img',title:'图片',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<img width='25' height='25' onclick='showImg(this)' src='${ftppath}"+row.img+"'/>";
						} 
					},
					{field:'title',title:'标题',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.title;}
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addCooperate();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateCooperate();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteCooperate();
					}
				}],
				onLoadSuccess:function(){
					$('#cooperateTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchCooperate(){
		var params = $('#cooperateTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#cooperateTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchCooperate();
	}
	
	//添加内容
	function addCooperate(){
		var url="${ctx}/coo/initEditCooperate.action";
		if(window.parent&&parent.openwindow){
			parent.openwindow("联名合作编辑",url);
		}
		else{
			location.href=url;
		}
	}
	
	//修改内容
	function updateCooperate(){
		var rows = $('#cooperateTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的数据",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一个数据进行更新",'info');
			return;
		}
		var row=$('#cooperateTable').datagrid('getSelected');
		var url="${ctx}/coo/initEditCooperate.action?id="+row.id;
		if(window.parent&&parent.openwindow){
			parent.openwindow("联名合作编辑",url);
		}
		else{
			location.href=url;
		}
	}
	
	//删除内容
	function deleteCooperate(){
		var rows = $('#cooperateTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的数据",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#cooperateTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/content/deleteCooperate.action?ids='+ps,function(data){
		        	$('#cooperateTable').datagrid('load'); 
    				searchCooperate();
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
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchCooperate()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="cooperateTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
