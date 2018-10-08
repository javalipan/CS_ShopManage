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
    <title>品牌销售及服装属性统计</title>
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
			$("#brandPie,#stylePie,#colorPie,#sizePie").css({
				height:$(window).width()*0.8,
			});
			
			//初始化表格
			$('#sumTable').datagrid({
				title:'品牌销售及服装属性统计', //标题
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
					{field:'brandname',title:'品牌名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.brandname;}
					},
					{field:'totalprice',title:'销售额',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return Number(row.totalprice).toFixed(2);}
					},
					{field:'totalprofit',title:'利润',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return Number(row.totalprofit).toFixed(2);}
					}
				]],
				onLoadSuccess:function(){
					$('#sumTable').datagrid('clearSelections');
				}
			});
			
		});
	
		var option = {
			    title : {
			        text: '',
			        x:'center'
			    },
			    legend: {
			        type: 'scroll',
			        orient: 'vertical',
			        right: 10,
			        top: 20,
			        bottom: 20
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{a} <br/>{b} : {c} ({d}%)"
			    },
			    series : [
			        {
			            name: '销售额',
			            type: 'pie',
			            radius : '55%',
			            center: ['40%', '50%'],
			            itemStyle: {
			                emphasis: {
			                    shadowBlur: 10,
			                    shadowOffsetX: 0,
			                    shadowColor: 'rgba(0, 0, 0, 0.5)'
			                }
			            }
			        }
			    ]
			};
		
			//表格查询
	function searchData(){
		$('#sumTable').datagrid('options').url="<%=request.getContextPath()%>/statistic/brand/sumBrand.action";
		var params = $('#sumTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#sumTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
		
		$.ajax({
			url:"<%=request.getContextPath()%>/statistic/brand/getPieData.action",
			data:{
				startTime:params.startTime,
				endTime:params.endTime,
				brandid:params.brandid
			},
			dataType:"json",
			success:function(result){
				option.title.text="品牌销量饼图";
				option.series[0].data=result.seriesData_brand;
				option.legend.data=result.legendData_brand;
				myChart_brand = echarts.init(document.getElementById('brandPie'));
				myChart_brand.setOption(option,true);
				
				option.title.text="风格销量饼图";
				option.series[0].data=result.seriesData_style;
				option.legend.data=result.legendData_style;
				myChart_style = echarts.init(document.getElementById('stylePie'));
				myChart_style.setOption(option,true);
				
				option.title.text="颜色销量饼图";
				option.series[0].data=result.seriesData_color;
				option.legend.data=result.legendData_color;
				myChart_color = echarts.init(document.getElementById('colorPie'));
				myChart_color.setOption(option,true);
				
				option.title.text="尺码销量饼图";
				option.series[0].data=result.seriesData_size;
				option.legend.data=result.legendData_size;
				myChart_size = echarts.init(document.getElementById('sizePie'));
				myChart_size.setOption(option,true);
			}
		})
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
  				<td align="right" width="10%">时间:</td>
  				<td align="left" width="40%" colspan="3">
  					<input type="text" class="easyui-datebox" name="startTime" id="startTime"/>-
  					<input type="text" class="easyui-datebox" name="endTime" id="endTime"/>
  				</td>
			</tr>
 			<tr>
  				<td align="right" width="10%">商品品牌:</td>
  				<td align="left" width="20%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchData()}">
						<option value="">商品品牌</option>
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
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
  	<div>
  		<div id="brandPie" style="width:100%;"></div>
  		<div id="stylePie" style="width:100%;"></div>
  	</div>
  	<div>
  		<div id="colorPie" style="width:100%;"></div>
  		<div id="sizePie" style="width:100%;"></div>
  	</div>
  	
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
