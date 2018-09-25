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
    <title>订单管理</title>
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
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'code',title:'订单号',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='javascript:void(0)' class='trbutton' onclick=\"showDetail("+row.id+")\">"+row.code+"</a>";
						}
					},
					{field:'membernickname',title:'会员',width:25,sortable:false,align:'center'},
					{field:'type',title:'类型',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.type=="0"?"微信":"线下";}
					},
					{field:'oldprice',title:'优惠前',width:15,sortable:false,align:'center'},
					{field:'totalprice',title:'支付金额',width:15,sortable:false,align:'center'},
					{field:'balancepay',title:'余额支付',width:15,sortable:false,align:'center'},
					{field:'subtractmoney',title:'满减',width:15,sortable:false,align:'center'},
					{field:'couponspay',title:'优惠券抵扣',width:15,sortable:false,align:'center'},
					{field:'ordertime',title:'下单时间',width:35,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a title='"+formattime(row.ordertime)+"'>"+formattime(row.ordertime)+"</a>";
						}
					},
					{field:'ispay',title:'是否支付',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.ispay=="0"){
								return "<span class='red'>未支付</span>";
							}
							else{
								return "<span class='green'>已支付</span>";
							}
						}
					},
					{field:'issend',title:'是否发货',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.issend=="0"){
								return "<span class='red'>未发货</span>";
							}
							else{
								return "<span class='green'>已发货</span>";
							}
						}
					},
					{field:'isreceive',title:'是否收货',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.isreceive=="0"){
								return "<span class='red'>未收货</span>";
							}
							else{
								return "<span class='green'>已收货</span>";
							}
						}
					},
					{field:'status',title:'是否作废',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.status=="0"){
								return "<span class='green'>正常</span>";
							}
							else{
								return "<span class='red'>作废</span>";
							}
						}
					},
					{field:'remark',title:'备注',width:60,sortable:false,align:'center'},
					{field:'options',title:'操作',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							var html="<a class='trbutton' href='javascript:void(0)' onclick=\"showDetail("+row.id+")\">详情</a>";
							if(row.status=="0"){
								if(row.ispay=="1" && row.issend=="0"){
									html+="|<a class='trbutton' href='javascript:void(0)' onclick=\"sendOrders("+row.id+")\">发货</a>";
								}
								if(row.ispay=="0"){
									html+="|<a class='trbutton' href='javascript:void(0)' onclick=\"cancel("+row.id+")\">取消</a>";
								}
								html+="|<a class='trbutton' href='javascript:void(0)' onclick=\"disable("+row.id+")\">作废</a>";
							}
							return html;
						}
					}
				]],
				toolbar:[{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateOrder();
					}
				},'-',{
					text:'发货',
					iconCls:'icon-send',
					handler:function(){
						sendOrder();
					}
				}],
				onLoadSuccess:function(){
					$('#orderTable').datagrid('clearSelections');
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
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchOrder();
	}
	
	//修改订单
	function updateOrder(){
		var rows = $('#orderTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的订单",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一个订单进行更新",'info');
			return;
		}
		var row=$('#orderTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '修改订单信息',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/order/initOrderEdit.action?id='+row.id,
		    modal: true
		});
	}
	
	function sendOrder(){
		var rows = $('#orderTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要发货的订单",'info');
			return;
		}
		var rows = $('#orderTable').datagrid('getSelections');
    	var ps = "";
    	$.each(rows,function(i,n){
    		ps+=n.id+",";
    	});
    	if(ps.length>0) ps=ps.substring(0,ps.length-1);
    	sendOrders(ps);
	}
	
	
	function sendOrders(ids){
		if(ids){
			$.messager.confirm('提示','您确认要发货吗?',function(result){
		        if (result){
		        	$.ajax({
		        		url:'${ctx}/order/sendOrder.action',
		        		data:{
		        			ids:ids
		        		},
		        		success:function(result){
		    				$.messager.alert('提示',result,'info');
		        			$('#orderTable').datagrid('load'); 
		        			searchOrder();
		        		}
		        	});
		        }
			});
		}
	}
	
	function disable(id){
		$.messager.confirm('提示','您确认要作废订单吗?',function(result){
	        if (result){
	        	$.ajax({
	        		url:'${ctx}/order/disableOrder.action',
	        		data:{
	        			id:id
	        		},
	        		success:function(result){
	    				$.messager.alert('提示',result,'info');
	        			$('#orderTable').datagrid('load'); 
	        		}
	        	});
	        }
		});
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
	
	function cancel(id){
		$.messager.confirm('提示','您确认要取消此订单吗?',function(result){
	        if (result){
	        	$.ajax({
	        		url:'${ctx}/order/cancelOrder.action',
	        		data:{
	        			id:id
	        		},
	        		success:function(result){
	    				$.messager.alert('提示',result,'info');
	        			searchOrder();
	        		}
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
  				<td align="right" width="10%">是否支付:</td>
  				<td align="left" width="15%">
  					<select name="ispay" class="easyui-combobox" data-options="width:147,editable:false,onChange:function(){searchOrder();}">
  						<option value="">支付状态</option>
  						<option value="0">未支付</option>
  						<option value="1">已支付</option>
  					</select>
  				</td>
  				<td align="right" width="10%">是否发货:</td>
  				<td align="left" width="15%">
  					<select name="issend" class="easyui-combobox" data-options="width:147,editable:false,onChange:function(){searchOrder();}">
  						<option value="">发货状态</option>
  						<option value="0">未发货</option>
  						<option value="1">已发货</option>
  					</select>
  				</td>
  			</tr>
  			<tr>
  				<td align="right" width="10%">是否收货:</td>
  				<td align="left" width="15%">
  					<select name="isreceive" class="easyui-combobox" data-options="width:147,editable:false,onChange:function(){searchOrder();}">
  						<option value="">收货状态</option>
  						<option value="0">未收货</option>
  						<option value="1">已收货</option>
  					</select>
  				</td>
  				<td align="right" width="10%">下单时间:</td>
  				<td align="left" width="40%" colspan="3">
  					<input type="text" class="easyui-datebox" name="ordertimestart" id="ordertimestart"/>-
  					<input type="text" class="easyui-datebox" name="ordertimeend" id="ordertimeend"/>
  				</td>
  				<td align="left" width="15%">
  					<select name="orderBy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchOrder()}">
  						<option value="">请选择排序</option>
  						<option value="o.ordertime desc">下单时间倒序</option>
  						<option value="o.totalprice desc,o.ordertime desc">订单金额倒序</option>
  						<option value="o.integralprice desc,o.ordertime desc">积分金额倒序</option>
  					</select>
  				</td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchOrder()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="orderTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
