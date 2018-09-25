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
    <title>商品入库</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		$(function(){
			
			$("input[name='code']").bind("input propertychange",function(){
				var code=$(this).val();
				$.ajax({
					url:'${ctx}/res/getGoodsDetail.action',
					data:{
						code:code
					},
					dataType:'json',
					success:function(result){
						if(result){
							if(result.goodsQuery){
								$("#goodsname").text(result.goodsQuery.name);
								$("#material").text(result.goodsQuery.material);
								$("#washway").text(result.goodsQuery.washway);
								$("#brand").text(result.goodsQuery.brandname);
								$("#typename").text(result.goodsQuery.typename);
								$("#unit").text(result.goodsQuery.unit);
								$("#sex").text(result.goodsQuery.sex=="0"?"男性":(result.goodsQuery.sex=="1"?"女性":"所有"));
								$("#material").text(result.goodsQuery.material);
								$("#standard").text(result.goodsQuery.standard);
								if(result.goodsQuery.season=="0"){
									$("#season").text("春季");
								}
								else if(result.goodsQuery.season=="1"){
									$("#season").text("夏季");
								}
								else if(result.goodsQuery.season=="2"){
									$("#season").text("秋季");
								}
								else if(result.goodsQuery.season=="3"){
									$("#season").text("冬季");
								}
								$("input[name='id']").text(result.goodsQuery.id);
							}
							else{
								$("#goodsname").text("");
								$("#material").text("");
								$("#washway").text("");
								$("#brand").text("");
								$("#typename").text("");
								$("#unit").text("");
								$("#sex").text("");
								$("#material").text("");
								$("#standard").text("");
								$("#season").text("");
								$("input[name='id']").text("");
							}
							if(result.details){
								$("#detailTable").datagrid("loadData",result.details);
							}
							else{
								$("#detailTable").datagrid("loadData",[]);
							}
						}
					}
				});
			});
			
			$('#detailTable').datagrid({
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				singleSelect:true,
				idField:'id', //主键字段
				rownumbers:true, //显示行号
				columns:[[
					{field:'id',title:'id',width:10,sortable:false,align:'center',hidden:true},
					{field:'detailcode',title:'条形码',width:70,sortable:false,align:'center'},
					{field:'colorName',title:'颜色',width:30,sortable:false,align:'center'},
					{field:'sizeName',title:'尺码',width:30,sortable:false,align:'center'},
					/* {field:'costprice',title:'成本价',width:40,sortable:false,align:'center'}, */
					{field:'oldprice',title:'吊牌价',width:40,sortable:false,align:'center'},
					{field:'price',title:'成交价',width:40,sortable:false,align:'center'},
					{field:'vipprice',title:'折扣价',width:40,sortable:false,align:'center'},
					{field:'amount',title:'当前数量',width:40,sortable:false,align:'center'},
					{field:'inaamount',title:'入库数量',width:40,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<input type='text' js-value='"+row.id+"' js-max='"+row.amount+"' name='innum'/>";
						}
					}
				]],
				onLoadSuccess:function(){
					$('#repertoryTable').datagrid('clearSelections');
				}
			});
			
			$("input[name='code']").focus();
		});
		
		function saveRep(){
			var array=[];
			for(var i=0;i<$("input[name='innum']").length;i++){
				var val=$("input[name='innum']").eq(i).val()?$("input[name='innum']").eq(i).val():0;
				if(!val||val==0){
					continue;
				}
				var max=$("input[name='innum']").eq(i).attr("js-max");
				if(parseInt(val)+parseInt(max)<0){
					$.messager.alert('提示',"数据输入不合法",'info');
					$("input[name='innum']").eq(i).focus();
					return;
				}
				if(val&&!isNaN(val)&&/^-?\d+$/.test(val)&&parseInt(val)!=0){
					array.push({
						id:$("input[name='innum']").eq(i).attr("js-value"),
						amount:parseInt(val)
					});
				}
				else{
					$.messager.alert('提示',"数据输入不合法",'info');
					$("input[name='innum']").eq(i).focus();
					return;
				}
			}
			$.post("<%=request.getContextPath()%>/res/saveRepertory.action",{json:JSON.stringify(array)},function(data){
				$.messager.alert('提示',data,'info',function(){
					$.messager.alert('提示',data,'info');
					$("#dialog").dialog("close");
					searchRepertory();
				});
			}); 
		}
	</script>
  	<form name="form1" method="post" id="form1" action="<%=request.getContextPath() %>/menu/saveMenu.action" class="l-form">
		<input type="hidden" name="id"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>选择商品</span>
		</div>
		<div class="formitems">
			<div class="item full">
				商品编号:<input type="text" name="code" />
			</div>
			<div class="item">
				商品名称:<span id="goodsname"></span>
			</div>
			<div class="item">
				品牌:<span id="brand"></span>
			</div>
			<div class="item">
				分类:<span id="typename"></span>
			</div>
			<div class="item">
				单位：<span id="unit"></span>
			</div>
			<div class="item">
				适用性别：<span id="sex"></span>
			</div>
			<div class="item">
				主要材质：<span id="material"></span>
			</div>
			<div class="item">
				执行标准：<span id="standard"></span>
			</div>
			<div class="item">
				季节：<span id="season"></span>
			</div>
			<div class="item">
				洗涤方式:<span id="washway"></span>
			</div>
			<div class="item full">
				<table id="detailTable" width="100%">
				</table>
			</div>
			
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveRep()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">入库</a>
		</div>
	</form>
  </body>
</html>
