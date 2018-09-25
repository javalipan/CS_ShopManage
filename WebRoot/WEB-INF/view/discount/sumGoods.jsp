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
    <title>商品折扣</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript" src="${ctx }/My97DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#goodsTable').datagrid({
				title:'商品统计', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/discount/sumGoods.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'name',title:'品牌',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'goodsyear',title:'年',width:60,sortable:false,align:'left'},
					{field:'goods_season',title:'季节',width:60,sortable:false,align:'center'},
					{field:'totalcost',title:'总成本',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.remaincost+row.selledcost;
						}
					},
					{field:'totalresp',title:'总库存',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.selledamount+row.remainresp;
						}
					},
					{field:'selledamount',title:'已售',width:60,sortable:false,align:'center'},
					{field:'selledmoney',title:'已售金额',width:60,sortable:false,align:'center'},
					{field:'rate',title:'利润率',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return Number(row.rate).toFixed(2);
						}
					},
					{field:'remainresp',title:'剩余库存',width:60,sortable:false,align:'center'},
					{field:'remaincost',title:'剩余成本',width:60,sortable:false,align:'center'},
					{field:'remainsell',title:'预计销售额',width:60,sortable:false,align:'center'},
					{field:'options',title:'操作',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' href='javascript:void(0)' onclick=\"setDiscount("+row.id+",'"+row.goodsyear+"','"+row.goods_season+"')\">设置折扣</a>";
						}
					},
				]],
				onLoadSuccess:function(){
					$('#goodsTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchGoods(){
		var params = $('#goodsTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#goodsTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchGoods();
	}
	
	function setDiscount(id,goodsyear,season){
		var url="${ctx}/discount/initGoodsList.action?brandid="+id+"&year="+goodsyear+"&season="+season;
		if(window.parent&&parent.openwindow){
			parent.openwindow("折扣设置",url);
		}
		else{
			location.href=url;
		}
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">品牌名称:</td>
  				<td align="left" width="15%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false">
  						<c:forEach items="${brands }" var="brand">
	  						<option value="${brand.id }">${brand.name }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">年:</td>
  				<td align="left" width="15%">
  					<input type="text" name="year" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy'})"/>
  				</td>
  				<td align="right" width="10%">季:</td>
  				<td align="left" width="15%">
  					<select name="season" class="easyui-combobox" style="width:137px;" data-options="editable:false">
  						<option value="SS">SS</option>
  						<option value="AW">AW</option>
  					</select>
  				</td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchGoods()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="goodsTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
