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
    <title>会员标签(NES)统计分析</title>
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
				title:'会员标签(NES)统计分析', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				rownumbers:true, //显示行号
				nowrap:false,
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'name',title:'姓名',width:40,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name+(row.nickname?"("+row.nickname+")":"");}
					},
					{field:'phone',title:'电话',width:40,sortable:false,align:'center',
						formatter:function(value,row,index){return row.phone;}
					},
					{field:'memberLabels',title:'会员标签',width:120,sortable:false,align:'center',
						formatter:function(value,row,index){
							var html="<div>";
							for(var i=0;i<row.memberLabels.length;i++){
								html+="<span class='label'>"+row.memberLabels[i].labelname+"</span>";
							}
							html+="</div>";
							return html;
						}
					},
					{field:'membertype',title:'会员类型',width:40,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.membertype=="R"){
								return "注册";
							}
							else if(row.membertype=="N"){
								return "新顾客";
							}
							else if(row.membertype=="E"){
								return "活跃顾客";
							}
							else if(row.membertype=="S1"){
								return "瞌睡顾客";
							}
							else if(row.membertype=="S2"){
								return "半睡顾客";
							}
							else if(row.membertype=="S3"){
								return "沉睡顾客";
							}
							else if(row.membertype=="X1"){
								return "唤醒瞌睡";
							}
							else if(row.membertype=="X2"){
								return "唤醒半睡";
							}
							else if(row.membertype=="X3"){
								return "唤醒沉睡";
							}
						}
					},
					{field:'totalmoney',title:'累计消费',width:40,sortable:false,align:'center',
						formatter:function(value,row,index){return Number(row.totalmoney).toFixed(2);}
					},
					{field:'orderCnt',title:'订单数',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.orderCnt;}
					},
					{field:'orderAvgPrice',title:'平均订单价',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return Number(row.orderAvgPrice).toFixed(2);}
					},
					{field:'lastbuytime',title:'最近购买',width:50,sortable:false,align:'center',
						formatter:function(value,row,index){return formatdate(row.lastbuytime);}
					},
					{field:'during',title:'距当前(天)',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){return row.days;}
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
		$('#sumTable').datagrid('options').url="<%=request.getContextPath()%>/member/analysis/searchMember.action";
		var params = $('#sumTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#sumTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
		
		$.ajax({
			url:"<%=request.getContextPath()%>/member/analysis/getPieData.action",
			data:$("#queryForm").serializeArray(),
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
	<style>
	.label{color:#fff;background-color: #f0ad4e;border:1px solid #eea236;border-radius: 4px;margin:5px 0 0 5px;padding:3px;display:inline-block;}
	</style>
  </head>
  
  <body>
    <form action="${ctx}/goods/exportExcel.action" target="_blank" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">会员级别:</td>
  				<td align="left" width="15%">
  					<select name="levelLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${levelLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">购物金额:</td>
  				<td align="left" width="15%">
  					<select name="moneyLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${moneyLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">回头客:</td>
  				<td align="left" width="15%">
  					<select name="repeatLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${repeatLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">近期购物情景:</td>
  				<td align="left" width="15%">
  					<select name="recentLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${recentLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  			</tr>
  			<tr>
  				<td align="right" width="10%">入店资历:</td>
  				<td align="left" width="15%">
  					<select name="timeLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${timeLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">品牌:</td>
  				<td align="left" width="15%">
  					<select name="brandLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${brandLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">身形:</td>
  				<td align="left" width="15%">
  					<select name="sizeLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${sizeLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="right" width="10%">风格:</td>
  				<td align="left" width="15%">
  					<select name="styleLabel" style="width:137px;" class="easyui-combobox" data-options="editable:false">
  						<option value="">请选择</option>
  						<c:forEach items="${styleLabels }" var="label">
  							<option value="${label.labelname }">${label.labelname }</option>
  						</c:forEach>
  					</select>
  				</td>
  			</tr>
 			<tr>
  				<td align="right" width="10%">会员类型</td>
  				<td align="left" width="15%">
  					<select name="membertype" class="easyui-combobox" data-options="editable:false,width:147">
						<option value="">会员类型</option>
						<option value="R">注册</option>
						<option value="N">新顾客</option>
						<option value="E">活跃顾客</option>
						<option value="S1">瞌睡顾客</option>
						<option value="S2">半睡顾客</option>
						<option value="S3">沉睡顾客</option>
						<option value="X1">唤醒瞌睡</option>
						<option value="X2">唤醒半睡</option>
						<option value="X3">唤醒沉睡</option>
					</select>
  				</td>
  				<td align="right" width="10%">会员昵称:</td>
  				<td align="left" width="15%"><input type="text" name="nickname" id="nickname"/></td>
  				<td align="right" width="10%">会员手机:</td>
  				<td align="left" width="15%"><input type="text" name="phone" id="phone"/></td>
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
