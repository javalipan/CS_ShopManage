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
    <title>库存管理</title>
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
			$('#repertoryTable').datagrid({
				title:'入库记录', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/res/searchRepertorys.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'code',title:'商品编码',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.code;
						} 
					},
					{field:'detailcode',title:'条形码',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.detailcode;}
					},
					{field:'brandName',title:'品牌',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.brandName;}
					},
					{field:'goodsName',title:'商品名',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.goodsName;}
					},
					{field:'colorName',title:'颜色',width:60,sortable:false,align:'center'},
					{field:'sizeName',title:'尺码',width:60,sortable:false,align:'center'},
					{field:'beforeamount',title:'入库前',width:20,sortable:false,align:'left'},
					{field:'amount',title:'入库数量',width:20,sortable:false,align:'left'},
					{field:'afteramount',title:'入库后',width:20,sortable:false,align:'left'},
					{field:'intime',title:'入库时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formattime(row.intime);
						} 
					}
				]],
				toolbar:[{
					text:'商品入库',
					iconCls:'icon-inresp',
					handler:function(){
						addRepertory();
					}
				}],
				onLoadSuccess:function(){
					$('#repertoryTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchRepertory(){
		var params = $('#repertoryTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#repertoryTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchRepertory();
	}
	
	//添加库存
	function addRepertory(){
		$('#dialog').dialog({
		    title: '商品入库',
		    width: 750,
		    height: 450,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/res/initAddRepertory.action',
		    modal: true
		});
	}
	
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">商品编码:</td>
  				<td align="left" width="15%"><input type="text" name="code" id="code"/></td>
  				<td align="right" width="10%">商品名称:</td>
  				<td align="left" width="15%"><input type="text" name="goodsName" id="goodsName"/></td>
  				<td align="right" width="10%">设计师品牌:</td>
  				<td align="left" width="15%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchRepertory()}">
						<option value="">商品品牌</option>
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
  				</td>
  				<td width="25%">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchRepertory()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="repertoryTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
