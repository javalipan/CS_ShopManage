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
    <title>商品统计</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			$("#typeid").combotree({
				url:'${ctx}/type/searchTypeData.action',
				onSelect : function(node) {  
			        //返回树对象  
			        var tree = $(this).tree;  
			        //选中的节点是否为叶子节点,如果不是叶子节点,清除选中  
			        var isLeaf = tree('isLeaf', node.target);  
			        if (!isLeaf) {  
			            //清除选中  
			            $('#typeid').combotree('clear');  
			        }  
			        else{
			        	searchGoods();
			        }
			    }
			});
			
			//初始化表格
			$('#goodsTable').datagrid({
				title:'商品列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/statistic/goods/searchGoodss.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'type',title:'图片',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<img width='25' height='25' onclick='showImg(this)' src='${ftppath}"+row.img+"'/>";
						} 
					},
					{field:'code',title:'编码',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' href='${ctx}/goods/initGoodsDetail.action?id="+row.id+"'>"+row.code+"</a>";
						} 
					},
					{field:'brandname',title:'品牌名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.brandname;}
					},
					{field:'name',title:'名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'totalamount',title:'累计库存',width:60,sortable:false,align:'left'},
					{field:'amount',title:'剩余库存',width:60,sortable:false,align:'left'},
					{field:'saleamount',title:'累计销量',width:60,sortable:false,align:'left'},
					{field:'saleprice',title:'累计销售金额',width:60,sortable:false,align:'left'},
					{field:'options',title:'操作',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' href='javascript:void(0)' onclick='showDetail("+row.id+")'>详情</a>";
						}
					}
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
	
	function showDetail(id){
		if(window.parent&&parent.openwindow){
			parent.openwindow("详情",'${ctx}/statistic/goods/initDetail.action?id='+id);
		}
		else{
			location.href='${ctx}/statistic/goods/initDetail.action?id='+id;
		}
	}
	</script>
  </head>
  
  <body>
    <form action="${ctx}/goods/exportExcel.action" target="_blank" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">商品编码:</td>
  				<td align="left" width="20%"><input type="text" name="codelike" id="codelike"/></td>
  				<td align="right" width="10%">商品名称:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  				<td align="right" width="10%">商品分类:</td>
  				<td align="left" width="20%"><input type="text" name="typeid" id="typeid"/></td>
			</tr>
 			<tr>
  				<td align="right" width="10%">商品品牌:</td>
  				<td align="left" width="20%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchGoods()}">
						<option value="">商品品牌</option>
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
  				</td>
  				<td></td>
  				<td>
  					<select name="orderBy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchGoods()}">
  						<option value="">请选择排序</option>
  						<option value="totalamount desc">累计库存倒序</option>
  						<option value="amount desc">剩余库存倒序</option>
  						<option value="saleamount desc">累计销量倒序</option>
  						<option value="saleprice desc">累计销售金额</option>
  					</select>
  				</td>
  				<td colspan="2" >
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
