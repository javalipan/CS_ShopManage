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
    <title>新老客户按月统计</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/echarts.min.js"></script>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#sumTable').datagrid({
				title:'新老客户按月统计', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'y',title:'年',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.y;}
					},
					{field:'m',title:'月',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.m;}
					},
					{field:'totalcount',title:'订单总数',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.totalcount;}
					},
					{field:'new',title:'新顾客占比',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return Number(Number(Number(Number(row.totalcount).sub(row.oldcount)).div(row.totalcount)).mul(100)).toFixed(2)+"%";
						}
					},
					{field:'old',title:'老顾客占比',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return Number(Number(Number(row.oldcount).div(row.totalcount)).mul(100)).toFixed(2)+"%";
						}
					}
				]],
				onLoadSuccess:function(){
					$('#sumTable').datagrid('clearSelections');
				}
			});
			
		});
	
			//表格查询
	function searchData(){
		$('#sumTable').datagrid('options').url="<%=request.getContextPath()%>/statistic/orn/sumByOldOrNew.action";
		var params = $('#sumTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#sumTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchData();
	}
	</script>
  </head>
  
  <body>
    <form action="${ctx}/goods/exportExcel.action" target="_blank" method="post" id="queryForm">
  		<table border="0">
 			<tr>
  				<td align="right" width="10%">年:</td>
  				<td align="left" width="20%">
  					<select name="year" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchData()}">
						<c:forEach begin="2017" end="2037" var="year">
							<option value="${year }">${year }</option>
						</c:forEach>
					</select>
  				</td>
  				<td colspan="2" >
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchData()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="sumTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
