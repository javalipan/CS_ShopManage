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
    <title>满减规则管理</title>
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
			$('#fullruleTable').datagrid({
				title:'规则列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/fullrule/searchFullRules.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'amount',title:'消费额',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.amount;
						}
					},
					{field:'subtractamount',title:'满减额',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.subtractamount;
						} 
					},
					{field:'options',title:'操作',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='javascrript:void(0)' onclick='deleteFullrule("+row.id+")'>删除</a>";
						} 
					}
				]],
				onLoadSuccess:function(){
					$('#fullruleTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchFullRule(){
		var params = $('#fullruleTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#fullruleTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
	
	//删除规则
	function deleteFullrule(id){
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	$.post('<%=request.getContextPath()%>/fullrule/deleteFullRule.action?id='+id,function(data){
    				searchFullRule();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	function saveFullRule(){
		var flag = $('#form1').form('validate');
		if(!flag) {
			return false;
		}
		$.post("<%=request.getContextPath()%>/fullrule/saveFullRule.action",$("#form1").serializeArray(),function(data){
			searchFullRule();
			$('#form1').form('clear');
			$.messager.alert('提示',data,'info');
		});
	}
	
	</script>
  </head>
  
  <body>
  	<form action="" method="post" id="form1">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%"><span style="color:red">*</span>消费金额:</td>
  				<td align="left" width="25%">
  					<input name="amount" type="text" id="amount" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</td>
  				<td align="right" width="10%"><span style="color:red">*</span>满减额:</td>
  				<td align="left" width="25%"><input name="subtractamount" type="text" id="subtractamount" data-options="required:true,validType:['number']" class="easyui-validatebox"/></td>
  				<td width="10%">
  					<a id="saveBtn" href="javascript:void(0);" onclick="saveFullRule()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="fullruleTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
