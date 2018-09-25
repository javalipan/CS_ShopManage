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
				url:"<%=request.getContextPath()%>/discount/searchGoods.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{
					brandid:${brandid}, 
					year:'${year}',
					season:'${season}'
				}, //查询条件
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
							return "<a class='trbutton' onclick='showDetail("+row.id+")' href='javascript:void(0)'>"+row.code+"</a>";
						} 
					},
					{field:'name',title:'名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'isdiscount',title:'是否折扣',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.isdiscount=='0'){
								return '否';
							}
							else if(row.isdiscount=='1'){
								return '未开始';
							}
							else if(row.isdiscount=='2'){
								return '折扣中';
							}
							else if(row.isdiscount=='3'){
								return '已过期';
							}
						}
					},
					{field:'discount',title:'折扣',width:60,sortable:false,align:'center'},
					{field:'starttime',title:'开始时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.starttime);}
					},
					{field:'endtime',title:'结束时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return formattime(row.endtime);}
					}
				]],
				toolbar:[{
					text:'设置折扣',
					iconCls:'icon-edit',
					handler:function(){
						setDiscount();
					}
				},'-',{
					text:'取消折扣',
					iconCls:'icon-edit',
					handler:function(){
						calcelDiscount();
					}
				}],
				onLoadSuccess:function(){
					$('#goodsTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchGoods(){
		var params = $('#goodsTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		if($("input[name='isdiscount']").is(":checked")){
			params['isdiscount'] =1;
		}
		else{
			params['isdiscount'] =null;
		}
		$('#goodsTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchGoods();
	}
	
	function setDiscount(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的商品",'info');
			return;
		}
		var ps = "";
    	$.each(rows,function(i,n){
    		ps+=n.id+",";
    	});
    	if(ps.length>0) ps=ps.substring(0,ps.length-1);
    	$('#dialog').dialog({
		    title: '设置折扣',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/discount/initSetDiscount.action?ids='+ps,
		    modal: true
		});
	}
	
	//详情
	function showDetail(id){
		if(window.parent&&parent.openwindow){
			parent.openwindow("商品详情","${ctx}/goods/initGoodsDetail.action?id="+id);
		}
		else{
			location.href='${ctx}/goods/initGoodsDetail.action?id='+id;
		}
	}
	
	function calcelDiscount(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的商品",'info');
			return;
		}
		var ps = "";
    	$.each(rows,function(i,n){
    		ps+=n.id+",";
    	});
    	if(ps.length>0) ps=ps.substring(0,ps.length-1);
    	$.messager.confirm('提示','确认要取消折扣?',function(result){
	        if (result){
	        	$.ajax({
	        		url:"${ctx}/discount/calcelDiscount.action",
	        		data:{
	        			ids:ps
	        		},
	        		type:'POST',
	        		success:function(data){
	        			searchGoods();
	        			$.messager.alert('提示',data,'info');
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
  				<td align="right" width="10%">品牌名称:</td>
  				<td align="left" width="15%">
  					${brand.name }
  				</td>
  				<td align="right" width="10%">年:</td>
  				<td align="left" width="15%">
  					${year }
  				</td>
  				<td align="right" width="10%">季:</td>
  				<td align="left" width="15%">
  					${season }
  				</td>
			</tr>
 			<tr>
  				<td align="left" width="15%">
  					<label><input type="checkbox" name="isdiscount" value="1"/>已设置折扣</label>
  				</td>
  				<td width="30%" colspan="5">
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
