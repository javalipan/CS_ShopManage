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
    <title>订单统计</title>
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
			$('#orderTable').datagrid({
				title:'订单列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/order/searchOrders.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{
					ispay:1,
					status:0
				}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'code',title:'订单号',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='javascript:void(0)' class='trbutton' onclick=\"showDetail("+row.id+")\">"+row.code+"</a>";
						}
					},
					{field:'amount',title:'商品数量',width:20,sortable:false,align:'center'},
					{field:'type',title:'类型',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.type=="0"?"微信":"线下";}
					},
					{field:'oldprice',title:'应付金额',width:20,sortable:false,align:'center'},
					{field:'totalprice',title:'实付金额',width:20,sortable:false,align:'center'},
					{field:'integralprice',title:'积分抵扣',width:20,sortable:false,align:'center'},
					{field:'ordertime',title:'下单时间',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.ordertime);}
					},
					{field:'membernickname',title:'会员',width:30,sortable:false,align:'center'},
					{field:'memberlevel',title:'会员等级',width:30,sortable:false,align:'center'},
					{field:'options',title:'操作',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							var html="<a class='trbutton' href='javascript:void(0)' onclick=\"showDetail("+row.id+")\">详情</a>";
							return html;
						}
					}
				]],
				onLoadSuccess:function(){
					$('#orderTable').datagrid('clearSelections');
					sumOrder();
				}
			});
			
		});
		
		
			//表格查询
	function searchOrder(){
		var params = $('#orderTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#orderTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
			
	function sumOrder(){
		$.ajax({
			url:'${ctx}/statistic/sale/getSumOrder.action',
			data:$('#queryForm').serializeArray(),
			dataType:'json',
			success:function(data){
				$(".totalinfo label:eq(0)").find("span").text(data.ordercount);
				$(".totalinfo label:eq(1)").find("span").text(fix(data.oldpricesum)+"元");
				$(".totalinfo label:eq(2)").find("span").text(fix(data.totalpricesum)+"元");
				$(".totalinfo label:eq(3)").find("span").text(fix(data.integralPricesum)+"元");
				$(".totalinfo label:eq(4)").find("span").text(data.membercount);
			}
		});
	}
	
	function fix(num){
		if(num&&!isNaN(num)){
			return Number(num).toFixed(2);
		}
		else{
			return 0;
		}
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		$("input[name='ispay']").val(1);
		$("input[name='status']").val(0);
		searchOrder();
	}
	
	function showDetail(id){
		$('#dialog').dialog({
		    title: '订单详情',
		    width: 950,
		    height: 450,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/order/initOrderDetail.action?id='+id,
		    modal: true
		});
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
    	<input type="hidden" name="ispay" value="1"/>
    	<input type="hidden" name="status" value="0"/>
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">下单时间:</td>
  				<td align="left" width="40%" colspan="3">
  					<input type="text" class="easyui-datebox" name="ordertimestart" id="ordertimestart"/>-
  					<input type="text" class="easyui-datebox" name="ordertimeend" id="ordertimeend"/>
  				</td>
  				<td align="right" width="10%">商品品牌:</td>
  				<td align="left" width="20%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchOrder()}">
						<option value="">商品品牌</option>
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
  				</td>
  				<td align="right" width="10%">商品名称:</td>
  				<td align="left" width="20%"><input type="text" name="goodsName" id="goodsName"/></td>
  			</tr>
  			<tr>
  				<td align="right" width="10%">订单编号:</td>
  				<td align="left" width="15%"><input type="text" name="code" id="code"/></td>
  				<td align="right" width="10%">类型:</td>
  				<td align="left" width="15%">
  					<select name="type" class="easyui-combobox" data-options="width:147,editable:false,onChange:function(){searchOrder();}">
  						<option value="">订单类型</option>
  						<option value="0">微信线上订单</option>
  						<option value="1">线下订单</option>
  					</select>
  				</td>
  				<td></td>
  				<td align="left" width="15%">
  					<select name="orderBy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchOrder()}">
  						<option value="">请选择排序</option>
  						<option value="o.ordertime desc">下单时间倒序</option>
  						<option value="o.totalprice desc,o.ordertime desc">订单金额倒序</option>
  						<option value="o.integralprice desc,o.ordertime desc">积分金额倒序</option>
  					</select>
  				</td>
  				<td width="15%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchOrder()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="totalinfo">
  		<label>订单数量：<span class="num"></span></label>
  		<label>应付金额合计：<span class="num"></span></label>
  		<label>实付金额合计：<span class="num"></span></label>
  		<label>积分抵扣合计：<span class="num"></span></label>
  		<label>客户数量合计：<span class="num"></span></label>
  	</div>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="orderTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
