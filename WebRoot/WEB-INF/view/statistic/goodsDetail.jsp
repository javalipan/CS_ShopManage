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
    <title>商品详情</title>
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
			$('#repTable').datagrid({
				title:'库存记录', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:'auto', //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"${ctx}/statistic/goods/searchRepertorys.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{
					id:"${id}"
				}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
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
				onLoadSuccess:function(){
					$('#repTable').datagrid('clearSelections');
				}
			});
			
			//初始化表格
			$('#orderTable').datagrid({
				title:'订单记录', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:'auto', //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"${ctx}/statistic/goods/searchOrder.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{
					id:"${id}"
				}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'code',title:'订单号',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='javascript:void(0)' class='trbutton' onclick=\"showDetail("+row.id+")\">"+row.code+"</a>";
						}
					},
					{field:'membernickname',title:'会员',width:30,sortable:false,align:'center'},
					{field:'type',title:'类型',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.type=="0"?"微信":"线下";}
					},
					{field:'oldprice',title:'优惠前',width:20,sortable:false,align:'center'},
					{field:'totalprice',title:'总金额',width:20,sortable:false,align:'center'},
					{field:'ordertime',title:'下单时间',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.ordertime);}
					},
					{field:'ispay',title:'是否支付',width:25,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.ispay=="0"){
								return "<span class='red'>未支付</span>";
							}
							else{
								return "<span class='green'>已支付</span>";
							}
						}
					},
					{field:'issend',title:'是否发货',width:25,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.issend=="0"){
								return "<span class='red'>未发货</span>";
							}
							else{
								return "<span class='green'>已发货</span>";
							}
						}
					},
					{field:'isreceive',title:'是否收货',width:25,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.isreceive=="0"){
								return "<span class='red'>未收货</span>";
							}
							else{
								return "<span class='green'>已收货</span>";
							}
						}
					},
					{field:'status',title:'是否作废',width:25,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.status=="0"){
								return "<span class='green'>正常</span>";
							}
							else{
								return "<span class='red'>作废</span>";
							}
						}
					},
					{field:'options',title:'操作',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							var html="<a class='trbutton' href='javascript:void(0)' onclick=\"showDetail("+row.id+")\">详情</a>";
							return html;
						}
					}
				]],
				onLoadSuccess:function(){
					$('#orderTable').datagrid('clearSelections');
				}
			});
			
		});
		
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
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="repTable"></table>
  	</div>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="orderTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
